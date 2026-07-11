import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/category.dart';

/// Reads categories. Category creation by users is out of scope for this phase;
/// only the seeded system set is exposed.
class CategoriesRepository {
  CategoriesRepository(this._db);

  final AppDatabase _db;

  Future<List<Category>> getByType(CategoryType type) async {
    final rows =
        await (_db.select(_db.categoriesTable)
              ..where((t) => t.categoryType.equals(type.name))
              ..where((t) => t.isArchived.equals(false))
              ..orderBy([(t) => OrderingTerm(expression: t.nameEn)]))
            .get();
    return rows.map(_toDomain).toList();
  }

  Stream<List<Category>> watchByType(CategoryType type) {
    return (_db.select(_db.categoriesTable)
          ..where((t) => t.categoryType.equals(type.name))
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.nameEn)]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  Future<Category?> getById(String id) async {
    final row = await (_db.select(
      _db.categoriesTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Category _toDomain(CategoriesTableData row) => Category(
    id: row.id,
    nameAr: row.nameAr,
    nameEn: row.nameEn,
    type: CategoryType.fromName(row.categoryType),
    parentId: row.parentId,
    icon: row.icon,
    isSystem: row.isSystem,
    isArchived: row.isArchived,
  );
}
