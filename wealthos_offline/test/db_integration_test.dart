import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wealthos_offline/core/constants/enums.dart';
import 'package:wealthos_offline/core/security/encryption_service.dart';
import 'package:wealthos_offline/data/database/app_database.dart';
import 'package:wealthos_offline/data/models/asset.dart';
import 'package:wealthos_offline/data/models/contribution.dart';
import 'package:wealthos_offline/data/models/expense.dart';
import 'package:wealthos_offline/data/models/income.dart';
import 'package:wealthos_offline/data/models/liability.dart';
import 'package:wealthos_offline/data/repositories/asset_repository.dart';
import 'package:wealthos_offline/data/repositories/audit_repository.dart';
import 'package:wealthos_offline/data/repositories/contribution_repository.dart';
import 'package:wealthos_offline/data/repositories/currency_repository.dart';
import 'package:wealthos_offline/data/repositories/expense_repository.dart';
import 'package:wealthos_offline/data/repositories/income_repository.dart';
import 'package:wealthos_offline/data/repositories/liability_repository.dart';
import 'package:wealthos_offline/data/repositories/settings_repository.dart';
import 'package:wealthos_offline/data/repositories/timeline_repository.dart';
import 'package:wealthos_offline/services/calculation_engine.dart';
import 'package:wealthos_offline/services/chat_command_service.dart';

/// اختبارات تكامل على SQLite حقيقي (in-memory عبر sqflite_common_ffi).
///
/// خدمة التشفير تُنشأ بدون init() فتعمل في وضع تمرير النص كما هو —
/// كافٍ لاختبار منطق المستودعات والمحرك دون قنوات المنصة.
void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late AppDatabase appDb;
  late EncryptionService enc;
  late AuditRepository audit;
  late TimelineRepository timeline;
  late SettingsRepository settings;
  late CurrencyRepository currency;
  late AssetRepository assets;
  late LiabilityRepository liabilities;
  late IncomeRepository income;
  late ExpenseRepository expenses;
  late ContributionRepository contributions;
  late CalculationEngine engine;

  setUp(() async {
    appDb = AppDatabase.instance;
    await appDb.close();
    await appDb.openAt(inMemoryDatabasePath);
    enc = EncryptionService(const FlutterSecureStorage());
    audit = AuditRepository(appDb);
    timeline = TimelineRepository(appDb);
    settings = SettingsRepository(appDb);
    currency = CurrencyRepository(appDb);
    assets = AssetRepository(appDb, audit, timeline, enc);
    liabilities = LiabilityRepository(appDb, audit, timeline, enc);
    income = IncomeRepository(appDb, audit, timeline);
    expenses = ExpenseRepository(appDb, audit, timeline);
    contributions = ContributionRepository(appDb, audit, timeline);
    engine = CalculationEngine(
      assets: assets,
      liabilities: liabilities,
      income: income,
      expenses: expenses,
      contributions: contributions,
      currency: currency,
      settings: settings,
    );
  });

  tearDown(() async => appDb.close());

  group('المخطط والبذر', () {
    test('كل الجداول العشرين موجودة', () async {
      final db = await appDb.database;
      final rows = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'");
      final names = rows.map((r) => r['name'] as String).toSet();
      const expected = {
        'users', 'app_settings', 'currencies', 'exchange_rates',
        'income_sources', 'income_history', 'expense_categories',
        'expense_history', 'assets', 'asset_valuations', 'liabilities',
        'liability_payments', 'contributions', 'transactions',
        'timeline_events', 'goals', 'reminders', 'chat_messages',
        'reports_snapshots', 'audit_logs',
      };
      expect(names.containsAll(expected), isTrue,
          reason: 'ناقص: ${expected.difference(names)}');
    });

    test('العملات الافتراضية وصف الإعدادات مبذوران', () async {
      final currencies = await currency.currencies();
      expect(currencies.map((c) => c.code).toSet(),
          containsAll({'AED', 'EGP', 'USD', 'SAR'}));
      final s = await settings.get();
      expect(s.baseCurrency, 'AED');
      expect(s.onboardingCompleted, isFalse);
    });
  });

  group('الأصول', () {
    test('الإنشاء يسجّل تدقيقًا وحدث مسار زمني، والملاحظات لا تُسرَّب', () async {
      final id = await assets.create(Asset(
        name: 'سيارة',
        type: AssetType.vehicle,
        purchaseValue: 80000,
        currentValue: 75000,
        notes: 'ملاحظة سرية جدًا',
      ));
      expect(id, greaterThan(0));

      final logs = await audit.all();
      expect(logs, hasLength(1));
      expect(logs.first.action, AuditAction.create);
      expect(logs.first.newValue, isNot(contains('ملاحظة سرية')));

      final events = await timeline.all();
      expect(events, hasLength(1));
      expect(events.first.type, TimelineEventType.assetPurchased);
    });

    test('تحديث القيمة يضيف تقييمًا وحدث تحديث', () async {
      final id = await assets.create(
          Asset(name: 'ذهب', type: AssetType.gold, currentValue: 20000));
      final a = (await assets.byId(id))!;
      await assets.update(a.copyWith(currentValue: 25000));

      final vals = await assets.valuations(id);
      expect(vals, hasLength(1));
      expect(vals.first.value, 25000);

      final events = await timeline.all();
      expect(events.map((e) => e.type),
          contains(TimelineEventType.assetValueUpdated));
    });

    test('البيع يلغي التفعيل ويستبعده من الإجماليات', () async {
      final id = await assets.create(
          Asset(name: 'أرض', type: AssetType.land, currentValue: 500000));
      await assets.sell(id, 550000);
      final active = await assets.all();
      expect(active, isEmpty);
      final summary = await engine.compute();
      expect(summary.totalAssets, 0);
    });
  });

  group('الالتزامات والسداد', () {
    test('الدفعة تخفّض المتبقي وتقفل الالتزام عند الصفر', () async {
      final id = await liabilities.create(Liability(
        name: 'قرض السيارة',
        type: LiabilityType.loan,
        originalAmount: 10000,
        remainingAmount: 10000,
        monthlyPayment: 5000,
      ));
      await liabilities.addPayment(id, 5000);
      var l = (await liabilities.byId(id))!;
      expect(l.remainingAmount, 5000);
      expect(l.status, LiabilityStatus.active);

      await liabilities.addPayment(id, 5000);
      l = (await liabilities.byId(id))!;
      expect(l.remainingAmount, 0);
      expect(l.status, LiabilityStatus.paidOff);

      // الالتزام المسدّد لا يُحتسب في الإجمالي.
      final summary = await engine.compute();
      expect(summary.totalLiabilities, 0);
    });
  });

  group('الدخل والمصروف — الفترات التاريخية', () {
    test('إضافة فترة مفتوحة تقفل السابقة ولا يحدث ازدواج', () async {
      final srcId = await income.createSource(
          IncomeSource(name: 'الراتب', type: IncomeType.salary));
      await income.addHistory(IncomeHistory(
          sourceId: srcId, amount: 5000, fromDate: DateTime(2019, 1)));
      await income.addHistory(IncomeHistory(
          sourceId: srcId, amount: 10000, fromDate: DateTime(2023, 1)));

      // القيمة الحالية = آخر فترة فقط.
      expect(await income.currentMonthlyIncome(), 10000);
      // القيمة التاريخية = فترة 2019.
      expect(await income.monthlyIncomeAt(DateTime(2020, 6)), 5000);
    });

    test('فترتان مفتوحتان في نفس الشهر لا تُجمعان (إصلاح الازدواج)', () async {
      final srcId = await income.createSource(
          IncomeSource(name: 'الراتب', type: IncomeType.salary));
      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month);
      await income.addHistory(IncomeHistory(
          sourceId: srcId, amount: 8000, fromDate: thisMonth));
      await income.addHistory(IncomeHistory(
          sourceId: srcId, amount: 9000, fromDate: thisMonth));
      // الأحدث فقط، وليس 17000.
      expect(await income.currentMonthlyIncome(), 9000);
    });

    test('مصادر متعددة تُجمع معًا', () async {
      final salary = await income.createSource(
          IncomeSource(name: 'راتب', type: IncomeType.salary));
      final rent = await income.createSource(
          IncomeSource(name: 'إيجار', type: IncomeType.rental));
      await income.addHistory(IncomeHistory(
          sourceId: salary, amount: 10000, fromDate: DateTime(2024, 1)));
      await income.addHistory(IncomeHistory(
          sourceId: rent, amount: 3000, fromDate: DateTime(2024, 1)));
      expect(await income.currentMonthlyIncome(), 13000);
    });

    test('المصروفات: الفترة المغلقة لا تُحتسب اليوم', () async {
      final cat = await expenses.createCategory(
          ExpenseCategory(name: 'معيشة', type: ExpenseType.living));
      await expenses.addHistory(ExpenseHistory(
          categoryId: cat,
          amount: 1800,
          fromDate: DateTime(2019, 1),
          toDate: DateTime(2022, 12)));
      await expenses.addHistory(ExpenseHistory(
          categoryId: cat, amount: 10000, fromDate: DateTime(2023, 1)));
      expect(await expenses.currentMonthlyExpense(), 10000);
      expect(await expenses.monthlyExpenseAt(DateTime(2020, 5)), 1800);
    });
  });

  group('المحرك الحسابي', () {
    test('صافي الثروة والتحويل متعدد العملات', () async {
      // العملة الأساسية AED، وسعر USD يدوي = 3.67.
      await currency.setRate('USD', 3.67);
      await assets.create(Asset(
          name: 'نقد', type: AssetType.cash, currentValue: 10000));
      await assets.create(Asset(
          name: 'أسهم أمريكية',
          type: AssetType.stocks,
          currentValue: 1000,
          currency: 'USD'));
      await liabilities.create(Liability(
          name: 'دين', type: LiabilityType.personalDebt, remainingAmount: 3000));

      final s = await engine.compute();
      expect(s.totalAssets, closeTo(10000 + 3670, 0.01));
      expect(s.totalLiabilities, 3000);
      expect(s.netWorth, closeTo(10670, 0.01));
      expect(s.cash, 10000); // النقد فقط سائل
    });

    test('المساهمات العائلية لا تدخل صافي الثروة', () async {
      await assets.create(Asset(
          name: 'نقد', type: AssetType.cash, currentValue: 5000));
      await contributions.create(
          Contribution(title: 'بيت العائلة', amount: 100000));
      final s = await engine.compute();
      expect(s.netWorth, 5000);
      expect(s.contributionsTotal, 100000);
    });

    test('مؤشر الصحة المالية ضمن 0..100 ومعدل الادخار صحيح', () async {
      final srcId = await income.createSource(
          IncomeSource(name: 'راتب', type: IncomeType.salary));
      await income.addHistory(IncomeHistory(
          sourceId: srcId, amount: 10000, fromDate: DateTime(2024, 1)));
      final cat = await expenses.createCategory(
          ExpenseCategory(name: 'معيشة', type: ExpenseType.living));
      await expenses.addHistory(ExpenseHistory(
          categoryId: cat, amount: 6000, fromDate: DateTime(2024, 1)));
      await assets.create(Asset(
          name: 'نقد', type: AssetType.cash, currentValue: 50000));

      final s = await engine.compute();
      expect(s.monthlyCashFlow, 4000);
      expect(s.savingRate, closeTo(40, 0.01));
      expect(s.healthScore, inInclusiveRange(0, 100));
      expect(s.healthScore, greaterThan(50),
          reason: 'ادخار 40% وسيولة عالية وبلا ديون = صحة جيدة');
    });

    test('منحنى تطور الثروة يُنتج نقاطًا مرتّبة', () async {
      await assets.create(Asset(
          name: 'عقار',
          type: AssetType.property,
          currentValue: 300000,
          purchaseDate: DateTime(2022, 3)));
      final points = await engine.netWorthTimeline();
      expect(points.length, greaterThanOrEqualTo(2));
      for (var i = 1; i < points.length; i++) {
        expect(points[i].date.isAfter(points[i - 1].date), isTrue);
      }
      expect(points.last.netWorth, 300000);
    });
  });

  group('تشفير النسخ الاحتياطي', () {
    test('encryptWithPassword/decryptWithPassword دورة كاملة', () {
      const secret = '{"table":"data","note":"سرّي"}';
      final payload = enc.encryptWithPassword(secret, 'P@ssw0rd');
      // الحمولة JSON فيها iv وdata ولا تحتوي النص الأصلي.
      final map = jsonDecode(payload) as Map<String, dynamic>;
      expect(map.keys, containsAll(['iv', 'data', 'v']));
      expect(payload, isNot(contains('سرّي')));
      expect(enc.decryptWithPassword(payload, 'P@ssw0rd'), secret);
    });

    test('كلمة مرور خاطئة ترمي استثناءً أو تعيد نصًا تالفًا', () {
      final payload = enc.encryptWithPassword('بيانات', 'صحيحة');
      expect(
        () {
          final out = enc.decryptWithPassword(payload, 'خاطئة');
          if (out == 'بيانات') fail('يجب ألا تنجح كلمة المرور الخاطئة');
        },
        anyOf(returnsNormally, throwsA(anything)),
      );
    });
  });

  group('مساعد الأوامر (Rule-Based)', () {
    late ChatCommandService chat;
    setUp(() {
      chat = ChatCommandService(
        assets: assets,
        liabilities: liabilities,
        income: income,
        settings: settings,
        engine: engine,
      );
    });

    test('«اشتريت سيارة بـ 80000» ينشئ أصلًا', () async {
      final r = await chat.handle('اشتريت سيارة بـ 80000 كاش');
      expect(r.applied, isTrue);
      expect(r.intent, 'buy_asset');
      final list = await assets.all();
      expect(list, hasLength(1));
      expect(list.first.type, AssetType.vehicle);
      expect(list.first.currentValue, 80000);
    });

    test('«راتبي أصبح 22000» ينشئ مصدر راتب وفترة', () async {
      final r = await chat.handle('راتبي أصبح 22000');
      expect(r.applied, isTrue);
      expect(await income.currentMonthlyIncome(), 22000);
    });

    test('«دفعت 5000 من القسط» يسدّد على التزام نشط', () async {
      final id = await liabilities.create(Liability(
          name: 'قسط الشقة',
          type: LiabilityType.installment,
          remainingAmount: 50000));
      final r = await chat.handle('دفعت 5000 من القسط');
      expect(r.applied, isTrue);
      final l = (await liabilities.byId(id))!;
      expect(l.remainingAmount, 45000);
    });

    test('«كم ثروتي؟» يجيب دون تعديل بيانات', () async {
      await assets.create(Asset(
          name: 'نقد', type: AssetType.cash, currentValue: 1000));
      final r = await chat.handle('كم ثروتي؟');
      expect(r.applied, isFalse);
      expect(r.intent, 'query_net_worth');
      expect(r.reply, contains('1,000'));
    });

    test('الأرقام العربية-الهندية تُفهم', () async {
      final r = await chat.handle('اشتريت ذهب بـ ٢٠٠٠٠');
      expect(r.applied, isTrue);
      final list = await assets.all();
      expect(list.first.currentValue, 20000);
    });

    test('جملة غير مفهومة تعيد إرشادات دون تعديل', () async {
      final r = await chat.handle('مرحبا كيف الحال');
      expect(r.applied, isFalse);
      expect(r.intent, 'unknown');
    });
  });
}
