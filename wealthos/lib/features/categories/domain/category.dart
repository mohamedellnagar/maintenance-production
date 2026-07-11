enum CategoryType {
  income,
  expense;

  static CategoryType fromName(String value) =>
      CategoryType.values.firstWhere((e) => e.name == value);
}

/// Immutable domain representation of an income/expense category.
class Category {
  const Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    required this.isSystem,
    required this.isArchived,
    this.parentId,
    this.icon,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final CategoryType type;
  final String? parentId;
  final String? icon;
  final bool isSystem;
  final bool isArchived;

  /// Localized display name for [languageCode] (`ar` falls back to Arabic,
  /// everything else to English).
  String localizedName(String languageCode) =>
      languageCode.startsWith('ar') ? nameAr : nameEn;
}
