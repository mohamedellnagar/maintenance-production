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
  String get navDashboard => 'الرئيسية';

  @override
  String get navBudget => 'الميزانية';

  @override
  String get navAccounts => 'الحسابات';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get budgetTitle => 'الميزانية';

  @override
  String get budgetStatusDraft => 'مسودة';

  @override
  String get budgetStatusActive => 'نشطة';

  @override
  String get budgetStatusClosed => 'مغلقة';

  @override
  String get budgetExpectedIncome => 'الدخل المتوقع';

  @override
  String get budgetActualIncome => 'الدخل الفعلي';

  @override
  String get budgetTotalAssigned => 'إجمالي المخصص';

  @override
  String get budgetAvailableToAssign => 'المتاح للتوزيع';

  @override
  String get budgetActualExpense => 'المصروف الفعلي';

  @override
  String get budgetTotalRemaining => 'إجمالي المتبقي';

  @override
  String get budgetOverspentCount => 'الفئات المتجاوزة';

  @override
  String get budgetSectionIncomePlan => 'خطة الدخل';

  @override
  String get budgetSectionExpense => 'المصروفات';

  @override
  String get budgetSectionSavings => 'المدخرات';

  @override
  String get budgetSectionDebt => 'سداد الالتزامات';

  @override
  String get budgetItemAssigned => 'المخصص';

  @override
  String get budgetItemActual => 'الفعلي';

  @override
  String get budgetItemRemaining => 'المتبقي';

  @override
  String get budgetItemOverspentBy => 'تجاوز بمقدار';

  @override
  String get budgetItemPlanned => 'المخطط';

  @override
  String get budgetItemVariance => 'الفرق';

  @override
  String get budgetItemRolloverIn => 'مُرحّل داخل';

  @override
  String get budgetItemRolloverOut => 'مُرحّل خارج';

  @override
  String budgetItemUsage(int percent) {
    return '$percent% مستخدَم';
  }

  @override
  String get budgetStatusNotStarted => 'لم يبدأ';

  @override
  String get budgetStatusOnTrack => 'ضمن الخطة';

  @override
  String get budgetStatusNearLimit => 'قريب من الحد';

  @override
  String get budgetStatusOverspent => 'متجاوز';

  @override
  String get budgetEmptyTitle => 'لا توجد ميزانية لهذا الشهر';

  @override
  String get budgetEmptyMessage => 'أنشئ ميزانية شهرية لتخطيط دخلك ومصروفاتك.';

  @override
  String get budgetCreateEmpty => 'إنشاء ميزانية فارغة';

  @override
  String get budgetCopyPrevious => 'نسخ الشهر السابق';

  @override
  String get budgetCreateTitle => 'إنشاء ميزانية';

  @override
  String budgetCopiedSkipped(int count) {
    return 'تم تجاوز $count بند لأن تصنيفه أو حسابه مؤرشف.';
  }

  @override
  String get budgetAddItem => 'إضافة بند';

  @override
  String get budgetItemTypeExpense => 'مصروف';

  @override
  String get budgetItemTypeSaving => 'ادخار';

  @override
  String get budgetItemTypeDebt => 'سداد التزام';

  @override
  String get budgetItemTypeIncome => 'خطة دخل';

  @override
  String get budgetItemName => 'الاسم';

  @override
  String get budgetAssignedAmount => 'المبلغ المخصص';

  @override
  String get budgetExpectedAmount => 'المبلغ المتوقع';

  @override
  String get budgetPlannedPayment => 'الدفعة المخططة';

  @override
  String get budgetRolloverEnabled => 'ترحيل المبلغ غير المستخدم';

  @override
  String get budgetItemNotes => 'ملاحظات';

  @override
  String get budgetSelectExpenseCategory => 'تصنيف مصروف';

  @override
  String get budgetSelectIncomeCategory => 'تصنيف دخل';

  @override
  String get budgetSelectLiability => 'حساب التزام';

  @override
  String get budgetItemDetailsTitle => 'بند الميزانية';

  @override
  String get budgetContributingTransactions => 'العمليات المساهمة';

  @override
  String get budgetNoContributions => 'لا توجد عمليات مساهمة بعد.';

  @override
  String get budgetCloseMonth => 'إغلاق الشهر';

  @override
  String get budgetCloseTitle => 'إغلاق هذا الشهر';

  @override
  String get budgetCloseReview => 'راجع الشهر ثم اختر الفوائض التي ستُرحّل.';

  @override
  String get budgetCloseSelectRollover => 'ترحيل';

  @override
  String get budgetCloseConfirm => 'إغلاق الشهر';

  @override
  String get budgetClosedBanner =>
      'هذا الشهر مغلق. نتائجه ما زالت تعكس أحدث العمليات.';

  @override
  String get budgetReopen => 'إعادة فتح الشهر';

  @override
  String get budgetReopenConfirm => 'إعادة فتح هذا الشهر المغلق للتعديل؟';

  @override
  String get budgetReadOnly => 'بنود الميزانية للقراءة فقط أثناء إغلاق الشهر.';

  @override
  String get budgetDeleteItem => 'حذف البند';

  @override
  String get budgetDeleteItemConfirm => 'حذف بند الميزانية هذا؟';

  @override
  String get budgetItemSaved => 'تم حفظ البند';

  @override
  String get budgetSummaryCardTitle => 'ميزانية هذا الشهر';

  @override
  String get budgetOpen => 'فتح الميزانية';

  @override
  String get budgetCreateCta => 'أنشئ ميزانية لهذا الشهر';

  @override
  String get budgetSavingPlanOnly =>
      'مخطط (تُعرض المدخرات كخطة فقط في هذا الإصدار).';

  @override
  String insightOverspent(String category) {
    return 'تجاوز الميزانية: $category';
  }

  @override
  String insightHighConsumption(String category) {
    return 'استهلاك ٨٠٪ فأكثر: $category';
  }

  @override
  String get insightNegativeAvailable => 'خصّصت أكثر من دخلك المتوقع.';

  @override
  String get insightIncomeBelowExpected => 'الدخل الفعلي أقل من المتوقع.';

  @override
  String get insightClosedMonthChanged => 'تغيّرت نتائج شهر مغلق بعد إغلاقه.';

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
  String get errorBudgetAssignedNegative =>
      'لا يمكن أن يكون المبلغ المخصص سالبًا.';

  @override
  String get errorBudgetCategoryRequired => 'من فضلك اختر تصنيفًا.';

  @override
  String get errorBudgetLiabilityRequired => 'من فضلك اختر حساب التزام.';

  @override
  String get errorBudgetNotLiability =>
      'يجب أن يستخدم سداد الالتزام حساب التزام.';

  @override
  String get errorBudgetDuplicateItem =>
      'يوجد بند ميزانية لهذا التصنيف أو الحساب مسبقًا.';

  @override
  String get errorBudgetHierarchyConflict =>
      'يوجد بند لتصنيف أب أو ابن مسبقًا.';

  @override
  String get errorBudgetExists => 'توجد ميزانية لهذا الشهر مسبقًا.';

  @override
  String get errorBudgetClosed => 'الشهر مغلق. أعد فتحه لإجراء تغييرات.';

  @override
  String get errorBudgetItemLinkedRollover =>
      'هذا البند مرتبط بترحيل ولا يمكن حذفه.';

  @override
  String get errorBudgetNotFound => 'الميزانية غير موجودة.';

  @override
  String get errorBudgetItemNotFound => 'بند الميزانية غير موجود.';

  @override
  String get errorDatabase => 'حدث خطأ في قاعدة البيانات.';

  @override
  String get errorUnexpected => 'حدث خطأ ما. حاول مرة أخرى.';
}
