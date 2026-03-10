import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/section.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/firestore_course_datasource.dart';

class CourseRepositoryImpl implements CourseRepository {
  final FirestoreCourseDatasource _datasource;

  final Map<String, DocumentSnapshot> _paginationCursors = {};

  CourseRepositoryImpl(this._datasource);

  @override
  Future<List<Course>> getCourses({
    List<String>? categoryIds,
    int limit = 10,
    String? startAfterId,
  }) async {
    final cursorKey = _buildCursorKey(categoryIds);
    final cursor = startAfterId != null ? _paginationCursors[cursorKey] : null;

    final models = await _datasource.getCourses(
      categoryIds: categoryIds,
      limit: limit,
      startAfterDocument: cursor,
    );

    // Save cursor for next page
    final lastDoc = await _datasource.getLastDocument(
      categoryIds: categoryIds,
      limit: limit,
      startAfterDocument: cursor,
    );
    if (lastDoc != null) {
      _paginationCursors[cursorKey] = lastDoc;
    }

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Course> getCourseById(String courseId) async {
    final model = await _datasource.getCourseById(courseId);
    return model.toEntity();
  }

  @override
  Future<List<Course>> getMostEnrolledCourses({int limit = 10}) async {
    final models = await _datasource.getMostEnrolledCourses(limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Course>> getRecentCourses({int limit = 10}) async {
    final models = await _datasource.getRecentCourses(limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Course>> searchCourses(String query,
      {List<String>? categoryIds}) async {
    final models =
        await _datasource.searchCourses(query, categoryIds: categoryIds);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Section>> searchSections(String query) async {
    final models = await _datasource.searchSections(query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Section>> getCourseSections(String courseId) async {
    final models = await _datasource.getCourseSections(courseId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Section> getSectionById(String courseId, String sectionId) async {
    final model = await _datasource.getSectionById(courseId, sectionId);
    return model.toEntity();
  }

  @override
  Future<List<Exercise>> getSectionExercises(
      String courseId, String sectionId) async {
    final models =
        await _datasource.getSectionExercises(courseId, sectionId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<Course>> watchMostEnrolledCourses({int limit = 10}) {
    return _datasource
        .watchMostEnrolledCourses(limit: limit)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  String _buildCursorKey(List<String>? categoryIds) {
    if (categoryIds == null || categoryIds.isEmpty) return '_all';
    final sorted = List<String>.from(categoryIds)..sort();
    return sorted.join(',');
  }
}
