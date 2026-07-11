import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens the on-device SQLite database, stored in the app documents directory.
///
/// Work happens on a background isolate so large queries never jank the UI.
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'wealthos.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
