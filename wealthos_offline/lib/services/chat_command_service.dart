import '../core/constants/enums.dart';
import '../core/utils/formatters.dart';
import '../data/models/asset.dart';
import '../data/models/income.dart';
import '../data/repositories/asset_repository.dart';
import '../data/repositories/income_repository.dart';
import '../data/repositories/liability_repository.dart';
import '../data/repositories/settings_repository.dart';
import 'calculation_engine.dart';

/// نتيجة معالجة أمر المحادثة.
class ChatResult {
  ChatResult(this.reply, {this.intent = 'unknown', this.applied = false});
  final String reply;
  final String intent;
  final bool applied;
}

/// مساعد أوامر ذكي قائم على القواعد (Rule-Based) — بدون أي اتصال بالإنترنت.
///
/// يحلّل جملًا عربية بسيطة مثل:
///  - "اشتريت سيارة بـ 80000 كاش"
///  - "راتبي أصبح 22000"
///  - "دفعت 50000 من قسط الشقة"
///  - "بعت الأرض بـ 500000"
///  - "كم ثروتي؟"  /  "هل وضعي المالي جيد؟"
class ChatCommandService {
  ChatCommandService({
    required AssetRepository assets,
    required LiabilityRepository liabilities,
    required IncomeRepository income,
    required SettingsRepository settings,
    required CalculationEngine engine,
  })  : _assets = assets,
        _liabilities = liabilities,
        _income = income,
        _settings = settings,
        _engine = engine;

  final AssetRepository _assets;
  final LiabilityRepository _liabilities;
  final IncomeRepository _income;
  final SettingsRepository _settings;
  final CalculationEngine _engine;

  Future<ChatResult> handle(String rawInput) async {
    final input = _normalize(rawInput);
    final base = (await _settings.get()).baseCurrency;

    // استعلامات (أسئلة).
    if (_matchesAny(input, ['كم ثروتي', 'صافي ثروتي', 'كم املك', 'ثروتي'])) {
      return _answerNetWorth();
    }
    if (_matchesAny(input, ['وضعي المالي', 'صحتي المالية', 'وضعي كويس', 'وضعي جيد'])) {
      return _answerHealth();
    }
    if (_matchesAny(input, ['دخلي', 'راتبي كم', 'كم راتبي'])) {
      return _answerIncome();
    }

    // أوامر تعديل.
    if (_matchesAny(input, ['اشتريت', 'شريت'])) {
      return _handleBuyAsset(input, base);
    }
    if (_matchesAny(input, ['بعت', 'بيعت'])) {
      return _handleSellAsset(input, base);
    }
    if (input.contains('راتب') &&
        _matchesAny(input, ['اصبح', 'صار', 'زاد', 'الان', 'ريال', 'اصبحت']) ) {
      return _handleSalaryChange(input, base);
    }
    if (input.contains('راتب') && _extractNumber(input) != null) {
      return _handleSalaryChange(input, base);
    }
    if (_matchesAny(input, ['دفعت', 'سددت']) &&
        _matchesAny(input, ['قسط', 'قرض', 'دين'])) {
      return _handlePayment(input, base);
    }
    if (_matchesAny(input, ['اضف اصل', 'اضافة اصل', 'اصل جديد'])) {
      return ChatResult(
        'لإضافة أصل جديد أخبرني بالنوع والقيمة، مثال: "اشتريت ذهب بـ 20000".\n'
        'أو استخدم شاشة الأصول لإضافة تفاصيل كاملة.',
        intent: 'add_asset_prompt',
      );
    }

    return ChatResult(
      'لم أفهم الطلب تمامًا. جرّب مثلًا:\n'
      '• اشتريت سيارة بـ 80000 كاش\n'
      '• راتبي أصبح 22000\n'
      '• دفعت 5000 من القسط\n'
      '• كم ثروتي؟',
      intent: 'unknown',
    );
  }

  // ---- معالجات الأوامر ----

  Future<ChatResult> _handleBuyAsset(String input, String base) async {
    final amount = _extractNumber(input);
    final type = _detectAssetType(input);
    if (amount == null) {
      return ChatResult('كم كانت قيمة الشراء؟ مثال: "اشتريت ${type.label} بـ 50000".',
          intent: 'buy_asset_incomplete');
    }
    final asset = Asset(
      name: type.label,
      type: type,
      purchaseValue: amount,
      currentValue: amount,
      currency: base,
      purchaseDate: DateTime.now(),
    );
    await _assets.create(asset, source: AuditSource.chat);
    return ChatResult(
      'تم تسجيل شراء ${type.label} بقيمة ${Fmt.money(amount, base)}. حُدِّثت لوحة التحكم.',
      intent: 'buy_asset',
      applied: true,
    );
  }

  Future<ChatResult> _handleSellAsset(String input, String base) async {
    final amount = _extractNumber(input);
    final type = _detectAssetType(input);
    final assets = await _assets.all();
    final match = assets.where((a) => a.type == type).toList();
    if (match.isEmpty) {
      return ChatResult('لم أجد ${type.label} مسجّلًا لبيعه.',
          intent: 'sell_asset_notfound');
    }
    final target = match.first;
    await _assets.sell(target.id!, amount ?? target.currentValue,
        source: AuditSource.chat);
    return ChatResult(
      'تم تسجيل بيع ${target.name}${amount != null ? ' بمبلغ ${Fmt.money(amount, base)}' : ''}.',
      intent: 'sell_asset',
      applied: true,
    );
  }

  Future<ChatResult> _handleSalaryChange(String input, String base) async {
    final amount = _extractNumber(input);
    if (amount == null) {
      return ChatResult('كم أصبح الراتب؟ مثال: "راتبي أصبح 22000".',
          intent: 'salary_incomplete');
    }
    // أوجد أو أنشئ مصدر دخل من نوع راتب.
    final sources = await _income.sources();
    IncomeSource? salary;
    for (final s in sources) {
      if (s.type == IncomeType.salary) {
        salary = s;
        break;
      }
    }
    int sourceId;
    if (salary == null) {
      sourceId = await _income.createSource(
        IncomeSource(name: 'الراتب', type: IncomeType.salary, currency: base),
        source: AuditSource.chat,
      );
    } else {
      sourceId = salary.id!;
    }
    await _income.addHistory(
      IncomeHistory(sourceId: sourceId, amount: amount, fromDate: DateTime.now()),
      source: AuditSource.chat,
    );
    return ChatResult(
      'تم تحديث الراتب إلى ${Fmt.money(amount, base)} شهريًا اعتبارًا من اليوم.',
      intent: 'update_salary',
      applied: true,
    );
  }

  Future<ChatResult> _handlePayment(String input, String base) async {
    final amount = _extractNumber(input);
    if (amount == null) {
      return ChatResult('كم المبلغ المدفوع؟ مثال: "دفعت 5000 من القسط".',
          intent: 'payment_incomplete');
    }
    final active = await _liabilities.active();
    if (active.isEmpty) {
      return ChatResult('لا يوجد التزام نشط لتسجيل دفعة عليه.',
          intent: 'payment_notfound');
    }
    // فضّل التزامًا يطابق كلمة في الجملة، وإلا أوّل التزام نشط.
    final target = active.firstWhere(
      (l) => input.contains(_normalize(l.name)),
      orElse: () => active.first,
    );
    await _liabilities.addPayment(target.id!, amount, source: AuditSource.chat);
    return ChatResult(
      'تم تسجيل دفعة ${Fmt.money(amount, base)} على "${target.name}".',
      intent: 'pay_liability',
      applied: true,
    );
  }

  Future<ChatResult> _answerNetWorth() async {
    final s = await _engine.compute();
    return ChatResult(
      'صافي ثروتك الحالي ${Fmt.money(s.netWorth, s.currency)}.\n'
      'إجمالي الأصول ${Fmt.money(s.totalAssets, s.currency)} '
      'والالتزامات ${Fmt.money(s.totalLiabilities, s.currency)}.',
      intent: 'query_net_worth',
    );
  }

  Future<ChatResult> _answerHealth() async {
    final s = await _engine.compute();
    return ChatResult(
      'مؤشر صحتك المالية ${s.healthScore}/100 (${s.healthLabel}).\n'
      'معدل الادخار ${Fmt.percent(s.savingRate)} ونسبة الديون ${Fmt.percent(s.debtRatio)}.',
      intent: 'query_health',
    );
  }

  Future<ChatResult> _answerIncome() async {
    final s = await _engine.compute();
    return ChatResult(
      'دخلك الشهري ${Fmt.money(s.monthlyIncome, s.currency)} '
      'ومصروفك ${Fmt.money(s.monthlyExpenses, s.currency)}، '
      'أي تدفق نقدي ${Fmt.money(s.monthlyCashFlow, s.currency)}.',
      intent: 'query_income',
    );
  }

  // ---- أدوات مساعدة ----

  /// تبسيط النص: توحيد الألف/الهمزات وإزالة التشكيل وتحويل الأرقام العربية.
  String _normalize(String s) {
    var t = s.trim();
    // أرقام عربية-هندية إلى لاتينية.
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    for (var i = 0; i < arabicDigits.length; i++) {
      t = t.replaceAll(arabicDigits[i], '$i');
    }
    t = t
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll(RegExp('[ًٌٍَُِّْ]'), '');
    return t;
  }

  bool _matchesAny(String input, List<String> keys) =>
      keys.any((k) => input.contains(_normalize(k)));

  /// استخراج أول رقم من الجملة مع دعم "ألف" و"مليون".
  double? _extractNumber(String input) {
    final cleaned = input.replaceAll(',', '');
    final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(cleaned);
    if (match == null) return null;
    var value = double.tryParse(match.group(1)!);
    if (value == null) return null;
    if (cleaned.contains('مليون')) {
      value *= 1000000;
    } else if (cleaned.contains('الف') || cleaned.contains('ألف')) {
      value *= 1000;
    }
    return value;
  }

  AssetType _detectAssetType(String input) {
    if (_matchesAny(input, ['سياره', 'عربيه', 'مركبه'])) return AssetType.vehicle;
    if (_matchesAny(input, ['ارض', 'قطعه ارض'])) return AssetType.land;
    if (_matchesAny(input, ['عقار', 'شقه', 'بيت', 'منزل', 'فيلا'])) {
      return AssetType.property;
    }
    if (_matchesAny(input, ['ذهب', 'سبيكه', 'جرام'])) return AssetType.gold;
    if (_matchesAny(input, ['اسهم', 'سهم'])) return AssetType.stocks;
    if (_matchesAny(input, ['عمله رقميه', 'بيتكوين', 'كريبتو'])) {
      return AssetType.crypto;
    }
    if (_matchesAny(input, ['كاش', 'نقد', 'فلوس'])) return AssetType.cash;
    return AssetType.other;
  }
}
