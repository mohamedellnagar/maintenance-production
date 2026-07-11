import 'package:drift/drift.dart';

import 'connection/connection.dart' as impl;
import 'seed/default_categories.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [AppSettingsTable, AccountsTable, CategoriesTable, TransactionsTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.openConnection());

  /// In-memory database for tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await seedDefaultCategories();
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Safety net for databases created before seeding existed or partially
      // wiped: seeding is idempotent (insert-or-ignore on stable ids).
      if (!details.wasCreated) {
        await seedDefaultCategories();
      }
    },
  );

  /// Inserts the default categories. Idempotent: stable ids + insert-or-ignore
  /// mean running it any number of times never produces duplicates.
  Future<void> seedDefaultCategories({DateTime? now}) async {
    final timestamp = now ?? _clock();
    await batch((Batch batch) {
      for (final category in kDefaultCategories) {
        batch.insert(
          categoriesTable,
          CategoriesTableCompanion.insert(
            id: category.id,
            nameAr: category.nameAr,
            nameEn: category.nameEn,
            categoryType: category.type,
            icon: Value(category.icon),
            isSystem: const Value(true),
            createdAt: timestamp,
            updatedAt: timestamp,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  DateTime _clock() => DateTime.now();
}
