import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../domain/category.dart';

/// Live categories of a given type (income/expense).
final categoriesByTypeProvider =
    StreamProvider.family<List<Category>, CategoryType>(
      (ref, type) => ref.watch(categoriesRepositoryProvider).watchByType(type),
    );
