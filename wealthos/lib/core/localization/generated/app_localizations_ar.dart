// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'WealthOS';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonDone => 'تم';

  @override
  String get commonAdd => 'إضافة';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonOptional => 'اختياري';

  @override
  String get commonRequired => 'مطلوب';

  @override
  String get commonAmount => 'المبلغ';

  @override
  String get commonNote => 'ملاحظة';

  @override
  String get commonDate => 'التاريخ';

  @override
  String get commonAll => 'الكل';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonUndo => 'تراجع';

  @override
  String get onboardingLanguageTitle => 'اختر لغتك';

  @override
  String get onboardingLanguageSubtitle => 'يمكنك تغييرها لاحقًا من الإعدادات.';

  @override
  String get onboardingCurrencyTitle => 'العملة الأساسية';

  @override
  String get onboardingCurrencySubtitle =>
      'جميع حساباتك تستخدم هذه العملة حاليًا.';

  @override
  String get onboardingAccountTitle => 'أضف حسابك الأول';

  @override
  String get onboardingAccountSubtitle =>
      'أعطه اسمًا ورصيدًا افتتاحيًا اختياريًا.';

  @override
  String get onboardingFinish => 'لنبدأ';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get dashboardTitle => 'الرئيسية';

  @override
  String get dashboardWelcome => 'مرحبًا بعودتك';

  @override
  String get dashboardNetWorth => 'صافي الثروة';

  @override
  String get dashboardTotalAssets => 'إجمالي الأصول';

  @override
  String get dashboardTotalLiabilities => 'إجمالي الالتزامات';

  @override
  String get dashboardMonthlyIncome => 'دخل هذا الشهر';

  @override
  String get dashboardMonthlyExpense => 'مصروف هذا الشهر';

  @override
  String get dashboardRecentTransactions => 'آخر العمليات';

  @override
  String get dashboardViewAll => 'عرض الكل';

  @override
  String get dashboardEmptyTitle => 'ابدأ بتتبّع ثروتك';

  @override
  String get dashboardEmptyMessage =>
      'أضف أول عملية لتظهر أرصدتك وصافي ثروتك هنا.';

  @override
  String get dashboardNoTransactions => 'لا توجد عمليات بعد.';

  @override
  String get accountsTitle => 'الحسابات';

  @override
  String get accountsAdd => 'إضافة حساب';

  @override
  String get accountsEmptyTitle => 'لا توجد حسابات بعد';

  @override
  String get accountsEmptyMessage => 'أضف حساب نقد أو بنك أو محفظة للبدء.';

  @override
  String get accountsCurrentBalance => 'الرصيد الحالي';

  @override
  String get accountsOpeningBalance => 'الرصيد الافتتاحي';

  @override
  String get accountsName => 'اسم الحساب';

  @override
  String get accountsType => 'نوع الحساب';

  @override
  String get accountsClassification => 'التصنيف';

  @override
  String get accountsInstitution => 'الجهة (اختياري)';

  @override
  String get accountsLast4 => 'آخر ٤ أرقام (اختياري)';

  @override
  String get accountsArchive => 'أرشفة الحساب';

  @override
  String get accountsUnarchive => 'إلغاء الأرشفة';

  @override
  String get accountsArchived => 'مؤرشف';

  @override
  String get accountsArchiveWarning =>
      'تؤدي الأرشفة إلى إخفاء الحساب من القوائم مع الاحتفاظ بعملياته وأرصدته. يمكنك إلغاء الأرشفة في أي وقت.';

  @override
  String get accountsRecentActivity => 'آخر النشاط';

  @override
  String get accountsOwedAmount => 'المبلغ المستحق';

  @override
  String get accountsOutstandingBalance => 'الرصيد المستحق';

  @override
  String get classificationAsset => 'أصل';

  @override
  String get classificationLiability => 'التزام';

  @override
  String get accountTypeCash => 'نقد';

  @override
  String get accountTypeBank => 'بنك';

  @override
  String get accountTypeWallet => 'محفظة';

  @override
  String get accountTypeCreditCard => 'بطاقة ائتمان';

  @override
  String get accountTypeInvestment => 'استثمار';

  @override
  String get accountTypeAsset => 'أصل';

  @override
  String get accountTypeLoan => 'قرض';

  @override
  String get accountTypeOther => 'أخرى';

  @override
  String get transactionAdd => 'إضافة عملية';

  @override
  String get transactionTypeIncome => 'دخل';

  @override
  String get transactionTypeExpense => 'مصروف';

  @override
  String get transactionTypeTransfer => 'تحويل';

  @override
  String get transactionTypeAdjustment => 'تعديل رصيد';

  @override
  String get transactionAccount => 'الحساب';

  @override
  String get transactionFromAccount => 'من حساب';

  @override
  String get transactionToAccount => 'إلى حساب';

  @override
  String get transactionCategory => 'التصنيف';

  @override
  String get transactionSelectAccount => 'اختر حسابًا';

  @override
  String get transactionSelectCategory => 'اختر تصنيفًا';

  @override
  String get transactionAdjustmentReason => 'سبب التعديل';

  @override
  String get transactionAdjustmentHint =>
      'أدخل الرصيد الفعلي وسيحسب النظام الفرق. لا تُحتسب التعديلات ضمن تقارير التدفق النقدي.';

  @override
  String get transactionSaved => 'تم حفظ العملية';

  @override
  String get transactionEdit => 'تعديل العملية';

  @override
  String get transactionUpdated => 'تم تحديث العملية';

  @override
  String get transactionActualBalance => 'الرصيد الفعلي';

  @override
  String get transactionCalculatedBalance => 'الرصيد المحسوب الحالي';

  @override
  String get transactionDifference => 'الفرق';

  @override
  String get transactionDetailsTitle => 'تفاصيل العملية';

  @override
  String get transactionStatusActive => 'نشطة';

  @override
  String get transactionStatusDeleted => 'محذوفة';

  @override
  String get transactionEffect => 'الأثر على الحسابات';

  @override
  String get transactionCreatedAt => 'تاريخ الإنشاء';

  @override
  String get transactionUpdatedAt => 'آخر تعديل';

  @override
  String get transactionDelete => 'حذف العملية';

  @override
  String get transactionDeleteConfirm =>
      'حذف هذه العملية؟ سيتم تحديث الأرصدة. يمكنك التراجع.';

  @override
  String get transactionDeleted => 'تم حذف العملية';

  @override
  String get transactionRestore => 'استعادة';

  @override
  String get transactionRestored => 'تمت استعادة العملية';

  @override
  String get semanticLiabilityCharge => 'زيادة التزام';

  @override
  String get semanticLiabilityRepayment => 'سداد التزام';

  @override
  String get semanticLiabilityDrawdown => 'سحب من التزام';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsCurrency => 'العملة الأساسية';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsThemeSystem => 'تلقائي';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsSecurity => 'الأمان';

  @override
  String get settingsBiometricLock => 'القفل بالبصمة';

  @override
  String get settingsBiometricSubtitle =>
      'طلب بصمة الإصبع أو الوجه عند فتح التطبيق.';

  @override
  String get settingsAbout => 'حول التطبيق';

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get lockTitle => 'التطبيق مقفل';

  @override
  String get lockUnlock => 'فتح القفل';

  @override
  String get lockReason => 'قم بالمصادقة لفتح WealthOS';

  @override
  String get errorRequired => 'هذا الحقل مطلوب.';

  @override
  String get errorInvalidAmount => 'أدخل مبلغًا صحيحًا.';

  @override
  String get errorAmountPositive => 'يجب أن يكون المبلغ أكبر من صفر.';

  @override
  String get errorCurrencyMismatch =>
      'يجب أن تستخدم جميع الحسابات العملة الأساسية في هذا الإصدار.';

  @override
  String get errorSameAccountTransfer =>
      'يجب أن يكون حساب المصدر والوجهة مختلفين.';

  @override
  String get errorAccountRequired => 'من فضلك اختر حسابًا.';

  @override
  String get errorDestinationRequired => 'من فضلك اختر حساب الوجهة.';

  @override
  String get errorCategoryRequired => 'من فضلك اختر تصنيفًا.';

  @override
  String get errorAdjustmentReasonRequired => 'من فضلك اذكر سبب التعديل.';

  @override
  String get errorCategoryNotAllowed =>
      'لا يمكن تحديد تصنيف إلا للدخل أو المصروف.';

  @override
  String get errorCategoryTypeMismatch => 'التصنيف لا يطابق نوع العملية.';

  @override
  String get errorAccountArchived => 'هذا الحساب مؤرشف ولا يمكن استخدامه.';

  @override
  String get errorCategoryArchived => 'هذا التصنيف مؤرشف ولا يمكن استخدامه.';

  @override
  String get errorAdjustmentNoChange => 'لم يتغير الرصيد؛ لا حاجة للتعديل.';

  @override
  String get errorAccountNotFound => 'الحساب غير موجود.';

  @override
  String get errorCategoryNotFound => 'التصنيف غير موجود.';

  @override
  String get errorTransactionNotFound => 'العملية غير موجودة.';

  @override
  String get errorDatabase => 'حدث خطأ في قاعدة البيانات.';

  @override
  String get errorUnexpected => 'حدث خطأ ما. حاول مرة أخرى.';
}
