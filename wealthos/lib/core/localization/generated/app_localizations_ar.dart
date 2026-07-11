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
  String get navRecurring => 'المتكررات';

  @override
  String get navAccounts => 'الحسابات';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get recurringTitle => 'المتكررات';

  @override
  String get recurringDueToday => 'مستحق اليوم';

  @override
  String get recurringOverdue => 'متأخر';

  @override
  String get recurringUpcoming7 => 'خلال ٧ أيام';

  @override
  String get recurringUpcoming30 => 'خلال ٣٠ يومًا';

  @override
  String get recurringActiveRules => 'القواعد النشطة';

  @override
  String get recurringPlannedIncome => 'الدخل المتوقع القادم';

  @override
  String get recurringPlannedExpenses => 'المصروفات والمدفوعات القادمة';

  @override
  String get recurringPlannedNote => 'مجدول — وليس تدفقًا نقديًا فعليًا.';

  @override
  String get recurringEmptyTitle => 'لا توجد متكررات بعد';

  @override
  String get recurringEmptyMessage =>
      'أضف قاعدة للرواتب أو الإيجار أو الاشتراكات أو أقساط القروض.';

  @override
  String get recurringAddRule => 'إضافة متكرر';

  @override
  String get recurringNoOccurrences => 'لا شيء مجدول هنا.';

  @override
  String get recurringTypeIncome => 'دخل';

  @override
  String get recurringTypeExpense => 'مصروف';

  @override
  String get recurringTypeTransfer => 'تحويل';

  @override
  String get recurringTypeLiabilityPayment => 'سداد التزام';

  @override
  String get recurringFreqDaily => 'يومي';

  @override
  String get recurringFreqWeekly => 'أسبوعي';

  @override
  String get recurringFreqMonthly => 'شهري';

  @override
  String get recurringFreqYearly => 'سنوي';

  @override
  String get recurringFreqCustomInterval => 'كل N أيام';

  @override
  String get occStatusScheduled => 'مجدول';

  @override
  String get occStatusDue => 'مستحق';

  @override
  String get occStatusOverdue => 'متأخر';

  @override
  String get occStatusPaid => 'مدفوع';

  @override
  String get occStatusSkipped => 'متخطى';

  @override
  String get occStatusCancelled => 'ملغى';

  @override
  String get recurringName => 'الاسم';

  @override
  String get recurringAmount => 'المبلغ';

  @override
  String get recurringType => 'النوع';

  @override
  String get recurringSourceAccount => 'من حساب';

  @override
  String get recurringDestinationAccount => 'إلى حساب';

  @override
  String get recurringCategory => 'التصنيف';

  @override
  String get recurringFrequency => 'التكرار';

  @override
  String get recurringInterval => 'الفاصل';

  @override
  String get recurringWeekdays => 'أيام الأسبوع';

  @override
  String get recurringMonthlyMode => 'شهريًا حسب';

  @override
  String get recurringMonthlyByDay => 'يوم من الشهر';

  @override
  String get recurringMonthlyByWeekday => 'يوم في الأسبوع';

  @override
  String get recurringMonthlyDay => 'يوم الشهر';

  @override
  String get recurringOrdinal => 'الترتيب';

  @override
  String get recurringWeekday => 'اليوم';

  @override
  String get recurringYearlyMonth => 'الشهر';

  @override
  String get recurringYearlyDay => 'اليوم';

  @override
  String get recurringStartDate => 'تاريخ البداية';

  @override
  String get recurringEndDate => 'تاريخ النهاية';

  @override
  String get recurringMaxOccurrences => 'أقصى عدد استحقاقات';

  @override
  String get recurringReminderDays => 'تذكير قبل بأيام';

  @override
  String get recurringAutoCreate => 'الإنشاء تلقائيًا عند الاستحقاق';

  @override
  String get recurringNotes => 'ملاحظات';

  @override
  String get recurringSelectAsset => 'اختر حساب أصل';

  @override
  String get recurringSelectLiability => 'اختر حساب التزام';

  @override
  String get recurringSaved => 'تم حفظ القاعدة المتكررة';

  @override
  String get recurringRuleDetails => 'القاعدة المتكررة';

  @override
  String get recurringNextDue => 'الاستحقاق القادم';

  @override
  String get recurringCompletedCount => 'المنفذة';

  @override
  String get recurringOverdueCount => 'المتأخرة';

  @override
  String get recurringRecentTransactions => 'آخر العمليات';

  @override
  String get recurringPause => 'إيقاف مؤقت';

  @override
  String get recurringResume => 'استئناف';

  @override
  String get recurringEnd => 'إنهاء القاعدة';

  @override
  String get recurringEndConfirm =>
      'إنهاء هذه القاعدة؟ تتوقف الاستحقاقات القادمة ويُحتفظ بالسجل.';

  @override
  String get recurringDeleteConfirm =>
      'حذف هذه القاعدة؟ ممكن فقط إذا لم يُنفَّذ أي استحقاق.';

  @override
  String get recurringPaused => 'متوقفة';

  @override
  String get recurringActive => 'نشطة';

  @override
  String get recurringEnded => 'منتهية';

  @override
  String get recurringArchivedWarning =>
      'تستخدم هذه القاعدة حسابًا أو تصنيفًا مؤرشفًا.';

  @override
  String get ordinalFirst => 'الأول';

  @override
  String get ordinalSecond => 'الثاني';

  @override
  String get ordinalThird => 'الثالث';

  @override
  String get ordinalFourth => 'الرابع';

  @override
  String get ordinalLast => 'الأخير';

  @override
  String get occurrenceDetails => 'الاستحقاق';

  @override
  String get occExpectedAmount => 'المبلغ المتوقع';

  @override
  String get occOriginalDate => 'التاريخ الأصلي';

  @override
  String get occSnoozedDate => 'مؤجل إلى';

  @override
  String get occMarkPaid => 'تسجيل كمدفوع';

  @override
  String get occMarkReceived => 'تسجيل كمستلم';

  @override
  String get occSnooze => 'تأجيل';

  @override
  String get occSnooze1Week => 'تأجيل أسبوع';

  @override
  String get occSkip => 'تخطي';

  @override
  String get occSkipConfirm => 'تخطي هذا الاستحقاق فقط؟ يستمر الجدول.';

  @override
  String get occSkipReason => 'السبب (اختياري)';

  @override
  String get occLinkedTransaction => 'العملية المرتبطة';

  @override
  String get occPosted => 'مسجّل كعملية';

  @override
  String get occSnoozed => 'تم تأجيل الاستحقاق';

  @override
  String get occSkippedMsg => 'تم تخطي الاستحقاق';

  @override
  String get occEditBeforePosting => 'تعديل قبل التنفيذ';

  @override
  String get recurrenceDaily => 'كل يوم';

  @override
  String recurrenceEveryNDays(int count) {
    return 'كل $count أيام';
  }

  @override
  String recurrenceWeeklyOn(String days) {
    return 'أسبوعيًا يوم $days';
  }

  @override
  String recurrenceEveryNWeeksOn(int count, String days) {
    return 'كل $count أسابيع يوم $days';
  }

  @override
  String recurrenceMonthlyDayText(int day) {
    return 'شهريًا في يوم $day';
  }

  @override
  String recurrenceMonthlyOrdinalText(String ordinal, String weekday) {
    return 'شهريًا في $ordinal $weekday';
  }

  @override
  String recurrenceYearlyText(String date) {
    return 'سنويًا في $date';
  }

  @override
  String get dashboardUpcomingBills => 'الفواتير القادمة';

  @override
  String get recurringViewAll => 'عرض الكل';

  @override
  String get recurringNoUpcoming => 'لا توجد فواتير قادمة.';

  @override
  String get budgetUpcomingRecurring => 'المتكررات القادمة';

  @override
  String get budgetUpcomingRecurringNote =>
      'مخططة ولم تُسجَّل بعد. لا تؤثر على الإنفاق الفعلي أو الأرصدة.';

  @override
  String get settingsAutoCreateRecurring => 'إنشاء المتكررات تلقائيًا';

  @override
  String get settingsAutoCreateRecurringSubtitle =>
      'عند استحقاق قاعدة، سجّلها تلقائيًا. متوقف افتراضيًا.';

  @override
  String get insightBillOverdue => 'لديك فاتورة متأخرة.';

  @override
  String get insightMultipleDueToday => 'أكثر من فاتورة مستحقة اليوم.';

  @override
  String get insightIncomeUpcoming => 'دخل متوقع قريبًا.';

  @override
  String get insightAutoCreateFailed => 'تعذّر إنشاء عملية متكررة تلقائيًا.';

  @override
  String get insightRecurringArchived =>
      'قاعدة متكررة تستخدم حسابًا أو تصنيفًا مؤرشفًا.';

  @override
  String get insightManyUnpaid => 'عدة استحقاقات متكررة غير مسددة.';

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
  String get errorRecurringWeekdayRequired => 'اختر يومًا واحدًا على الأقل.';

  @override
  String get errorRecurringInvalidSchedule => 'الجدول غير مكتمل أو غير صالح.';

  @override
  String get errorRecurringEndBeforeStart =>
      'لا يمكن أن يسبق تاريخ النهاية تاريخ البداية.';

  @override
  String get errorRecurringMaxInvalid =>
      'يجب أن يكون أقصى عدد استحقاقات أكبر من صفر.';

  @override
  String get errorRecurringReminderInvalid =>
      'لا يمكن أن تكون أيام التذكير سالبة.';

  @override
  String get errorRecurringIntervalInvalid => 'يجب أن يكون الفاصل ١ على الأقل.';

  @override
  String get errorRecurringNotLiability =>
      'يجب أن يكون سداد الالتزام من حساب أصل إلى حساب التزام.';

  @override
  String get errorOccurrenceAlreadyPosted => 'هذا الاستحقاق مسجّل بالفعل.';

  @override
  String get errorOccurrenceNotOpen => 'لا يمكن تسجيل هذا الاستحقاق.';

  @override
  String get errorRuleNotFound => 'القاعدة المتكررة غير موجودة.';

  @override
  String get errorOccurrenceNotFound => 'الاستحقاق غير موجود.';

  @override
  String get errorDatabase => 'حدث خطأ في قاعدة البيانات.';

  @override
  String get errorUnexpected => 'حدث خطأ ما. حاول مرة أخرى.';
}
