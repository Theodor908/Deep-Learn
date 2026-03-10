import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/firestore_course_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

part 'category_provider.g.dart';

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return CategoryRepositoryImpl(FirestoreCourseDatasource());
}

@riverpod
Future<List<Category>> categories(CategoriesRef ref) async {
  ref.keepAlive();
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getCategories();
}

@riverpod
Stream<List<Category>> watchCategories(WatchCategoriesRef ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchCategories();
}
