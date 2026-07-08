import '../core/constants/enums.dart';
import '../core/utils/date_range.dart';
import '../data/models/asset.dart';
import '../data/models/liability.dart';
import '../data/repositories/asset_repository.dart';
import '../data/repositories/contribution_repository.dart';
import '../data/repositories/currency_repository.dart';
import '../data/repositories/expense_repository.dart';
import '../data/repositories/income_repository.dart';
import '../data/repositories/liability_repository.dart';
import '../data/repositories/settings_repository.dart';
import 'currency_service.dart';

/// نقطة على منحنى تطور الثروة عبر الزمن.
class NetWorthPoint {
  NetWorthPoint(this.date, this.netWorth, this.assets, this.liabilities);
  final DateTime date;
  final double netWorth;
  final double assets;
  final double liabilities;
}

/// شريحة من مخطط توزيع الأصول.
class AllocationSlice {
  AllocationSlice(this.type, this.value);
  final AssetType type;
  final double value;
}

/// نتيجة شاملة لكل مؤشرات الوضع المالي (كلها بالعملة الأساسية).
class FinancialSummary {
  FinancialSummary({
    required this.currency,
    required this.netWorth,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.cash,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.monthlyCashFlow,
    required this.savingRate,
    required this.liquidityRatio,
    required this.debtRatio,
    required this.healthScore,
    required this.healthLabel,
    required this.allocation,
    required this.upcomingLiabilities,
    required this.contributionsTotal,
  });

  final String currency;
  final double netWorth;
  final double totalAssets;
  final double totalLiabilities;
  final double cash;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double monthlyCashFlow;
  final double savingRate; // %
  final double liquidityRatio; // %
  final double debtRatio; // %
  final int healthScore; // 0..100
  final String healthLabel;
  final List<AllocationSlice> allocation;
  final List<Liability> upcomingLiabilities;
  final double contributionsTotal;
}

/// محرك الحسابات المالية — يجمع البيانات من المستودعات ويحسب كل المؤشرات.
///
/// كل المبالغ تُحوَّل إلى العملة الأساسية قبل الجمع.
class CalculationEngine {
  CalculationEngine({
    required AssetRepository assets,
    required LiabilityRepository liabilities,
    required IncomeRepository income,
    required ExpenseRepository expenses,
    required ContributionRepository contributions,
    required CurrencyRepository currency,
    required SettingsRepository settings,
  })  : _assets = assets,
        _liabilities = liabilities,
        _income = income,
        _expenses = expenses,
        _contributions = contributions,
        _currency = currency,
        _settings = settings;

  final AssetRepository _assets;
  final LiabilityRepository _liabilities;
  final IncomeRepository _income;
  final ExpenseRepository _expenses;
  final ContributionRepository _contributions;
  final CurrencyRepository _currency;
  final SettingsRepository _settings;

  Future<CurrencyService> _currencyService(String base) async {
    final map = await _currency.rateMap(base);
    return CurrencyService(base, map);
  }

  Future<FinancialSummary> compute() async {
    final settings = await _settings.get();
    final base = settings.baseCurrency;
    final fx = await _currencyService(base);

    final assets = await _assets.all();
    final liabilities = await _liabilities.all();
    final contributions = await _contributions.all();

    // إجمالي الأصول والسيولة وتوزيع الأصول.
    double totalAssets = 0;
    double cash = 0;
    final byType = <AssetType, double>{};
    for (final a in assets) {
      final v = fx.toBase(a.currentValue, a.currency);
      totalAssets += v;
      if (a.type.isLiquid) cash += v;
      byType[a.type] = (byType[a.type] ?? 0) + v;
    }

    // إجمالي الالتزامات (النشطة فقط لها متبقٍ).
    double totalLiabilities = 0;
    for (final l in liabilities) {
      if (l.status == LiabilityStatus.paidOff) continue;
      totalLiabilities += fx.toBase(l.remainingAmount, l.currency);
    }

    final netWorth = totalAssets - totalLiabilities;

    // الدخل والمصروف الشهري (بجمع الفترات الحالية وتحويل العملات المصدرية).
    final monthlyIncome = await _monthlyIncomeInBase(fx);
    final monthlyExpenses = await _monthlyExpenseInBase(fx);
    final monthlyCashFlow = monthlyIncome - monthlyExpenses;

    final savingRate =
        monthlyIncome <= 0 ? 0.0 : (monthlyCashFlow / monthlyIncome) * 100;
    final liquidityRatio = netWorth <= 0 ? 0.0 : (cash / netWorth) * 100;
    final debtRatio =
        totalAssets <= 0 ? 0.0 : (totalLiabilities / totalAssets) * 100;

    final allocation = byType.entries
        .map((e) => AllocationSlice(e.key, e.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // الالتزامات القادمة (نشطة ولها تاريخ استحقاق).
    final upcoming = liabilities
        .where((l) => l.status == LiabilityStatus.active && l.dueDate != null)
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    double contributionsTotal = 0;
    for (final c in contributions) {
      contributionsTotal += fx.toBase(c.amount, c.currency);
    }

    final score = _healthScore(
      savingRate: savingRate,
      debtRatio: debtRatio,
      liquidityRatio: liquidityRatio,
      distinctAssetTypes: byType.keys.length,
      cash: cash,
      monthlyExpenses: monthlyExpenses,
      netWorth: netWorth,
    );

    return FinancialSummary(
      currency: base,
      netWorth: netWorth,
      totalAssets: totalAssets,
      totalLiabilities: totalLiabilities,
      cash: cash,
      monthlyIncome: monthlyIncome,
      monthlyExpenses: monthlyExpenses,
      monthlyCashFlow: monthlyCashFlow,
      savingRate: savingRate,
      liquidityRatio: liquidityRatio,
      debtRatio: debtRatio,
      healthScore: score,
      healthLabel: _healthLabel(score),
      allocation: allocation,
      upcomingLiabilities: upcoming.take(5).toList(),
      contributionsTotal: contributionsTotal,
    );
  }

  Future<double> _monthlyIncomeInBase(CurrencyService fx) async {
    final sources = await _income.sources();
    final now = DateTime.now();
    double total = 0;
    for (final s in sources) {
      final history = await _income.history(s.id!);
      for (final h in history) {
        if (DateRangeUtils.contains(now, h.fromDate, h.toDate)) {
          total += fx.toBase(h.amount, s.currency);
        }
      }
    }
    return total;
  }

  Future<double> _monthlyExpenseInBase(CurrencyService fx) async {
    final cats = await _expenses.categories();
    final now = DateTime.now();
    double total = 0;
    for (final c in cats) {
      final history = await _expenses.history(c.id!);
      for (final h in history) {
        if (DateRangeUtils.contains(now, h.fromDate, h.toDate)) {
          total += fx.toBase(h.amount, c.currency);
        }
      }
    }
    return total;
  }

  /// حساب Financial Health Score من 100 اعتمادًا على ستة عوامل.
  int _healthScore({
    required double savingRate,
    required double debtRatio,
    required double liquidityRatio,
    required int distinctAssetTypes,
    required double cash,
    required double monthlyExpenses,
    required double netWorth,
  }) {
    // 1) معدل الادخار — 25 نقطة (20%+ = كامل).
    final savingPts = (savingRate / 20 * 25).clamp(0, 25).toDouble();

    // 2) نسبة الديون — 20 نقطة (0% = كامل، 100%+ = صفر).
    final debtPts = ((100 - debtRatio) / 100 * 20).clamp(0, 20).toDouble();

    // 3) نسبة السيولة — 15 نقطة (10%+ = كامل).
    final liquidityPts = (liquidityRatio / 10 * 15).clamp(0, 15).toDouble();

    // 4) تنوع الأصول — 15 نقطة (4 أنواع فأكثر = كامل).
    final diversityPts = (distinctAssetTypes / 4 * 15).clamp(0, 15).toDouble();

    // 5) صندوق طوارئ — 15 نقطة (نقد يغطي 6 أشهر مصروفات = كامل).
    final emergencyPts = monthlyExpenses <= 0
        ? (cash > 0 ? 15.0 : 0.0)
        : (cash / (monthlyExpenses * 6) * 15).clamp(0, 15).toDouble();

    // 6) صافي ثروة موجب — 10 نقاط.
    final netWorthPts = netWorth > 0 ? 10.0 : 0.0;

    final total = savingPts +
        debtPts +
        liquidityPts +
        diversityPts +
        emergencyPts +
        netWorthPts;
    return total.round().clamp(0, 100).toInt();
  }

  String _healthLabel(int score) {
    if (score >= 80) return 'ممتاز';
    if (score >= 60) return 'جيد';
    if (score >= 40) return 'متوسط';
    if (score >= 20) return 'ضعيف';
    return 'يحتاج تحسين';
  }

  /// منحنى تطور الثروة عبر الزمن (تقريبي، اعتمادًا على تواريخ الاقتناء).
  Future<List<NetWorthPoint>> netWorthTimeline() async {
    final settings = await _settings.get();
    final base = settings.baseCurrency;
    final fx = await _currencyService(base);
    final assets = await _assets.all(activeOnly: false);
    final liabilities = await _liabilities.all();

    final start = settings.analysisStartDate ??
        _earliestDate(assets, liabilities) ??
        DateTime(DateTime.now().year - 1);
    final marks = DateRangeUtils.monthlyMarks(start, DateTime.now());

    return marks.map((t) {
      double a = 0;
      for (final asset in assets) {
        final acquired = asset.purchaseDate ?? asset.createdAt;
        // أصل نشط تمّ اقتناؤه في هذا التاريخ أو قبله.
        if (asset.isActive && !acquired.isAfter(t)) {
          a += fx.toBase(asset.currentValue, asset.currency);
        }
      }
      double l = 0;
      for (final liab in liabilities) {
        final started = liab.startDate ?? liab.createdAt;
        if (!started.isAfter(t) && liab.status != LiabilityStatus.paidOff) {
          l += fx.toBase(liab.remainingAmount, liab.currency);
        }
      }
      return NetWorthPoint(t, a - l, a, l);
    }).toList();
  }

  DateTime? _earliestDate(List<Asset> assets, List<Liability> liabilities) {
    final dates = <DateTime>[
      for (final a in assets) a.purchaseDate ?? a.createdAt,
      for (final l in liabilities) l.startDate ?? l.createdAt,
    ];
    if (dates.isEmpty) return null;
    dates.sort();
    return dates.first;
  }
}
