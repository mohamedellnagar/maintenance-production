/// Static definition of a system category shipped with the app.
class SeedCategory {
  const SeedCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    required this.icon,
  });

  /// Stable identifier — deliberately fixed (not random) so re-running the
  /// seed with an insert-or-ignore never creates duplicates.
  final String id;
  final String nameAr;
  final String nameEn;

  /// `'income'` or `'expense'`.
  final String type;
  final String icon;
}

/// The default localized category set. IDs are stable across releases.
const List<SeedCategory> kDefaultCategories = <SeedCategory>[
  // --- Expenses ---
  SeedCategory(
    id: 'sys_exp_housing',
    nameAr: 'السكن',
    nameEn: 'Housing',
    type: 'expense',
    icon: 'home',
  ),
  SeedCategory(
    id: 'sys_exp_food',
    nameAr: 'الطعام',
    nameEn: 'Food',
    type: 'expense',
    icon: 'restaurant',
  ),
  SeedCategory(
    id: 'sys_exp_transport',
    nameAr: 'المواصلات',
    nameEn: 'Transportation',
    type: 'expense',
    icon: 'directions_car',
  ),
  SeedCategory(
    id: 'sys_exp_bills',
    nameAr: 'الفواتير',
    nameEn: 'Bills',
    type: 'expense',
    icon: 'receipt_long',
  ),
  SeedCategory(
    id: 'sys_exp_shopping',
    nameAr: 'التسوق',
    nameEn: 'Shopping',
    type: 'expense',
    icon: 'shopping_bag',
  ),
  SeedCategory(
    id: 'sys_exp_health',
    nameAr: 'الصحة',
    nameEn: 'Health',
    type: 'expense',
    icon: 'favorite',
  ),
  SeedCategory(
    id: 'sys_exp_education',
    nameAr: 'التعليم',
    nameEn: 'Education',
    type: 'expense',
    icon: 'school',
  ),
  SeedCategory(
    id: 'sys_exp_entertainment',
    nameAr: 'الترفيه',
    nameEn: 'Entertainment',
    type: 'expense',
    icon: 'sports_esports',
  ),
  SeedCategory(
    id: 'sys_exp_family',
    nameAr: 'الأسرة',
    nameEn: 'Family',
    type: 'expense',
    icon: 'family_restroom',
  ),
  SeedCategory(
    id: 'sys_exp_other',
    nameAr: 'أخرى',
    nameEn: 'Other',
    type: 'expense',
    icon: 'category',
  ),
  // --- Income ---
  SeedCategory(
    id: 'sys_inc_salary',
    nameAr: 'الراتب',
    nameEn: 'Salary',
    type: 'income',
    icon: 'payments',
  ),
  SeedCategory(
    id: 'sys_inc_freelance',
    nameAr: 'عمل إضافي',
    nameEn: 'Freelance',
    type: 'income',
    icon: 'work',
  ),
  SeedCategory(
    id: 'sys_inc_investment',
    nameAr: 'استثمار',
    nameEn: 'Investment Income',
    type: 'income',
    icon: 'trending_up',
  ),
  SeedCategory(
    id: 'sys_inc_bonus',
    nameAr: 'مكافأة',
    nameEn: 'Bonus',
    type: 'income',
    icon: 'card_giftcard',
  ),
  SeedCategory(
    id: 'sys_inc_gift',
    nameAr: 'هدية',
    nameEn: 'Gift',
    type: 'income',
    icon: 'redeem',
  ),
  SeedCategory(
    id: 'sys_inc_other',
    nameAr: 'أخرى',
    nameEn: 'Other',
    type: 'income',
    icon: 'category',
  ),
];
