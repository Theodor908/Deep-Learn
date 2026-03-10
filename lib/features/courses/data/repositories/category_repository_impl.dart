import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/firestore_course_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final FirestoreCourseDatasource _datasource;

  CategoryRepositoryImpl(this._datasource);

  @override
  Future<List<Category>> getCategories() async {
    final models = await _datasource.getCategories();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<Category>> watchCategories() {
    return _datasource
        .watchCategories()
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}
