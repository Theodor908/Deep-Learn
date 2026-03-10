import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/firestore_course_datasource.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/section.dart';
import '../../domain/repositories/course_repository.dart';

part 'course_provider.g.dart';

@riverpod
CourseRepository courseRepository(CourseRepositoryRef ref) {
  return CourseRepositoryImpl(FirestoreCourseDatasource());
}

@riverpod
class CoursesNotifier extends _$CoursesNotifier {
  List<String>? _categoryFilter;
  String? _lastCourseId;
  bool _hasMore = true;

  @override
  FutureOr<List<Course>> build() async {
    _categoryFilter = null;
    _lastCourseId = null;
    _hasMore = true;
    final repo = ref.watch(courseRepositoryProvider);
    return repo.getCourses();
  }

  Future<void> filterByCategories(List<String>? categoryIds) async {
    _categoryFilter = categoryIds;
    _lastCourseId = null;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(courseRepositoryProvider);
      final courses = await repo.getCourses(categoryIds: _categoryFilter);
      _lastCourseId = courses.isNotEmpty ? courses.last.id : null;
      _hasMore = courses.length >= 10;
      return courses;
    });
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final currentCourses = state.valueOrNull ?? [];
    state = await AsyncValue.guard(() async {
      final repo = ref.read(courseRepositoryProvider);
      final nextPage = await repo.getCourses(
        categoryIds: _categoryFilter,
        startAfterId: _lastCourseId,
      );
      _lastCourseId = nextPage.isNotEmpty ? nextPage.last.id : null;
      _hasMore = nextPage.length >= 10;
      return [...currentCourses, ...nextPage];
    });
  }

  bool get hasMore => _hasMore;
}

@riverpod
Future<Course> courseDetail(CourseDetailRef ref, String courseId) async {
  ref.keepAlive();
  final repo = ref.watch(courseRepositoryProvider);
  return repo.getCourseById(courseId);
}

@riverpod
Future<List<Section>> courseSections(
    CourseSectionsRef ref, String courseId) async {
  ref.keepAlive();
  final repo = ref.watch(courseRepositoryProvider);
  return repo.getCourseSections(courseId);
}

@riverpod
Future<List<Exercise>> sectionExercises(
    SectionExercisesRef ref, String courseId, String sectionId) async {
  ref.keepAlive();
  final repo = ref.watch(courseRepositoryProvider);
  return repo.getSectionExercises(courseId, sectionId);
}

@riverpod
Future<List<Course>> mostEnrolledCourses(MostEnrolledCoursesRef ref) async {
  ref.keepAlive();
  final repo = ref.watch(courseRepositoryProvider);
  return repo.getMostEnrolledCourses();
}

@riverpod
Future<List<Course>> recentCourses(RecentCoursesRef ref) async {
  final repo = ref.watch(courseRepositoryProvider);
  return repo.getRecentCourses();
}

@riverpod
Stream<List<Course>> watchMostEnrolledCourses(
    WatchMostEnrolledCoursesRef ref) {
  final repo = ref.watch(courseRepositoryProvider);
  return repo.watchMostEnrolledCourses();
}
