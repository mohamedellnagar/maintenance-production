/// أنواع البيانات المشتركة عبر التطبيق (Enums).
///
/// كل enum يوفّر `key` ثابت للتخزين في قاعدة البيانات، و`label` عربي للعرض.
library;

enum AssetType {
  cash,
  bankAccount,
  property,
  land,
  vehicle,
  gold,
  stocks,
  crypto,
  businessInvestment,
  other;

  static AssetType fromKey(String key) =>
      AssetType.values.firstWhere((e) => e.name == key, orElse: () => AssetType.other);

  String get label => switch (this) {
        AssetType.cash => 'نقد',
        AssetType.bankAccount => 'حساب بنكي',
        AssetType.property => 'عقار',
        AssetType.land => 'أرض',
        AssetType.vehicle => 'سيارة',
        AssetType.gold => 'ذهب',
        AssetType.stocks => 'أسهم',
        AssetType.crypto => 'عملات رقمية',
        AssetType.businessInvestment => 'استثمار تجاري',
        AssetType.other => 'أخرى',
      };

  /// الأصول التي تُحتسب ضمن السيولة (Cash).
  bool get isLiquid => this == AssetType.cash || this == AssetType.bankAccount;
}

enum LiabilityType {
  loan,
  creditCard,
  installment,
  propertyRemaining,
  personalDebt;

  static LiabilityType fromKey(String key) => LiabilityType.values
      .firstWhere((e) => e.name == key, orElse: () => LiabilityType.personalDebt);

  String get label => switch (this) {
        LiabilityType.loan => 'قرض',
        LiabilityType.creditCard => 'بطاقة ائتمان',
        LiabilityType.installment => 'قسط',
        LiabilityType.propertyRemaining => 'متبقي عقار',
        LiabilityType.personalDebt => 'دين شخصي',
      };
}

enum IncomeType {
  salary,
  freelance,
  business,
  rental,
  dividends,
  other;

  static IncomeType fromKey(String key) =>
      IncomeType.values.firstWhere((e) => e.name == key, orElse: () => IncomeType.other);

  String get label => switch (this) {
        IncomeType.salary => 'راتب',
        IncomeType.freelance => 'عمل حر',
        IncomeType.business => 'دخل تجاري',
        IncomeType.rental => 'دخل إيجاري',
        IncomeType.dividends => 'أرباح أسهم',
        IncomeType.other => 'أخرى',
      };
}

enum ExpenseType {
  living,
  rent,
  familySupport,
  travel,
  education,
  health,
  food,
  transport,
  other;

  static ExpenseType fromKey(String key) =>
      ExpenseType.values.firstWhere((e) => e.name == key, orElse: () => ExpenseType.other);

  String get label => switch (this) {
        ExpenseType.living => 'معيشة شهرية',
        ExpenseType.rent => 'إيجار',
        ExpenseType.familySupport => 'مصروف عائلي',
        ExpenseType.travel => 'سفر',
        ExpenseType.education => 'تعليم',
        ExpenseType.health => 'صحة',
        ExpenseType.food => 'طعام',
        ExpenseType.transport => 'مواصلات',
        ExpenseType.other => 'أخرى',
      };
}

enum OwnershipStatus {
  owned,
  financed,
  shared;

  static OwnershipStatus fromKey(String key) => OwnershipStatus.values
      .firstWhere((e) => e.name == key, orElse: () => OwnershipStatus.owned);

  String get label => switch (this) {
        OwnershipStatus.owned => 'مملوك بالكامل',
        OwnershipStatus.financed => 'مموّل',
        OwnershipStatus.shared => 'مشترك',
      };
}

enum LiabilityStatus {
  active,
  paidOff,
  defaulted;

  static LiabilityStatus fromKey(String key) => LiabilityStatus.values
      .firstWhere((e) => e.name == key, orElse: () => LiabilityStatus.active);

  String get label => switch (this) {
        LiabilityStatus.active => 'نشط',
        LiabilityStatus.paidOff => 'مسدّد',
        LiabilityStatus.defaulted => 'متعثّر',
      };
}

enum GoalStatus {
  active,
  achieved,
  paused;

  static GoalStatus fromKey(String key) =>
      GoalStatus.values.firstWhere((e) => e.name == key, orElse: () => GoalStatus.active);

  String get label => switch (this) {
        GoalStatus.active => 'قيد التنفيذ',
        GoalStatus.achieved => 'تحقّق',
        GoalStatus.paused => 'متوقّف',
      };
}

enum TimelineEventType {
  salaryChanged,
  assetPurchased,
  assetSold,
  assetValueUpdated,
  liabilityAdded,
  paymentMade,
  investmentAdded,
  expenseChanged,
  contributionMade,
  goalCreated,
  goalAchieved;

  static TimelineEventType fromKey(String key) => TimelineEventType.values
      .firstWhere((e) => e.name == key, orElse: () => TimelineEventType.assetValueUpdated);

  String get label => switch (this) {
        TimelineEventType.salaryChanged => 'تغيّر الراتب',
        TimelineEventType.assetPurchased => 'شراء أصل',
        TimelineEventType.assetSold => 'بيع أصل',
        TimelineEventType.assetValueUpdated => 'تحديث قيمة أصل',
        TimelineEventType.liabilityAdded => 'إضافة التزام',
        TimelineEventType.paymentMade => 'سداد دفعة',
        TimelineEventType.investmentAdded => 'إضافة استثمار',
        TimelineEventType.expenseChanged => 'تغيّر المصروف',
        TimelineEventType.contributionMade => 'مساهمة عائلية',
        TimelineEventType.goalCreated => 'إنشاء هدف',
        TimelineEventType.goalAchieved => 'تحقيق هدف',
      };

  String get icon => switch (this) {
        TimelineEventType.salaryChanged => '💵',
        TimelineEventType.assetPurchased => '🏷️',
        TimelineEventType.assetSold => '💰',
        TimelineEventType.assetValueUpdated => '📈',
        TimelineEventType.liabilityAdded => '📉',
        TimelineEventType.paymentMade => '✅',
        TimelineEventType.investmentAdded => '📊',
        TimelineEventType.expenseChanged => '🧾',
        TimelineEventType.contributionMade => '🤝',
        TimelineEventType.goalCreated => '🎯',
        TimelineEventType.goalAchieved => '🏆',
      };
}

enum AuditAction {
  create,
  update,
  delete;

  static AuditAction fromKey(String key) =>
      AuditAction.values.firstWhere((e) => e.name == key, orElse: () => AuditAction.update);
}

enum AuditSource {
  manual,
  chat,
  wizard;

  static AuditSource fromKey(String key) =>
      AuditSource.values.firstWhere((e) => e.name == key, orElse: () => AuditSource.manual);
}

enum ReminderType {
  upcomingPayment,
  monthlyReview,
  assetValuation,
  salaryEntry,
  expenseReview;

  static ReminderType fromKey(String key) => ReminderType.values
      .firstWhere((e) => e.name == key, orElse: () => ReminderType.monthlyReview);

  String get label => switch (this) {
        ReminderType.upcomingPayment => 'قسط قادم',
        ReminderType.monthlyReview => 'مراجعة شهرية',
        ReminderType.assetValuation => 'تحديث قيمة أصل',
        ReminderType.salaryEntry => 'إدخال الراتب',
        ReminderType.expenseReview => 'مراجعة المصروفات',
      };
}
