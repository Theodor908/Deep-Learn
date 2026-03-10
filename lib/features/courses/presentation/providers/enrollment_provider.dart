import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/firestore_course_datasource.dart';
import '../../data/datasources/firestore_enrollment_datasource.dart';
import '../../data/repositories/enrollment_repository_impl.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../providers/course_provider.dart';

part 'enrollment_provider.g.dart';

@riverpod
EnrollmentRepository enrollmentRepository(EnrollmentRepositoryRef ref) {
  return EnrollmentRepositoryImpl(
    FirestoreEnrollmentDatasource(),
    FirestoreCourseDatasource(),
  );
}

@riverpod
Future<Enrollment?> enrollment(
    EnrollmentRef ref, String courseId) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return null;

  final repo = ref.watch(enrollmentRepositoryProvider);
  return repo.getEnrollment(user.uid, courseId);
}

@riverpod
Future<List<Enrollment>> userEnrollments(UserEnrollmentsRef ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return [];

  final repo = ref.watch(enrollmentRepositoryProvider);
  return repo.getUserEnrollments(user.uid);
}

@riverpod
Future<List<Course>> recommendedCourses(RecommendedCoursesRef ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return [];

  final repo = ref.watch(enrollmentRepositoryProvider);
  return repo.getRecommendedCourses(user.uid);
}

@riverpod
class EnrollmentNotifier extends _$EnrollmentNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> enroll(String courseId) async {
    final authState = ref.read(authStateProvider);
    final user = authState.valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(enrollmentRepositoryProvider);
      await repo.enrollInCourse(user.uid, courseId);
    });

    // Refresh
    ref.invalidate(enrollmentProvider);
    ref.invalidate(userEnrollmentsProvider);
    ref.invalidate(courseDetailProvider);
    ref.invalidate(mostEnrolledCoursesProvider);
  }

  Future<void> updateProgress(
    String courseId, {
    int? currentSectionOrder,
    List<int>? completedSections,
    double? completionPercentage,
  }) async {
    final authState = ref.read(authStateProvider);
    final user = authState.valueOrNull;
    if (user == null) return;

    state = await AsyncValue.guard(() async {
      final repo = ref.read(enrollmentRepositoryProvider);
      await repo.updateEnrollmentProgress(
        user.uid,
        courseId,
        currentSectionOrder: currentSectionOrder,
        completedSections: completedSections,
        completionPercentage: completionPercentage,
      );
    });

    ref.invalidate(enrollmentProvider);
  }

  Future<void> rateCourse(String courseId, int rating) async {
    final authState = ref.read(authStateProvider);
    final user = authState.valueOrNull;
    if (user == null) return;

    state = await AsyncValue.guard(() async {
      final repo = ref.read(enrollmentRepositoryProvider);
      await repo.rateCourse(user.uid, courseId, rating);
    });

    ref.invalidate(enrollmentProvider);
    ref.invalidate(courseDetailProvider);
  }
}
