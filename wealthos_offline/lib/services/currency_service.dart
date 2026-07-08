/// خدمة تحويل العملات إلى العملة الأساسية باستخدام أسعار مُدخَلة يدويًا.
class CurrencyService {
  CurrencyService(this.baseCurrency, this.rateMap);

  final String baseCurrency;

  /// code -> سعر تحويل الوحدة الواحدة إلى العملة الأساسية.
  final Map<String, double> rateMap;

  /// تحويل [amount] من العملة [from] إلى العملة الأساسية.
  /// إذا لم يوجد سعر، تُعامل كأنها بنفس العملة الأساسية (بدون تحويل).
  double toBase(double amount, String from) {
    if (from == baseCurrency) return amount;
    final rate = rateMap[from];
    if (rate == null || rate <= 0) return amount;
    return amount * rate;
  }
}
