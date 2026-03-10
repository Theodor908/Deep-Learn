import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../courses/domain/entities/enrollment.dart';
import '../../../courses/presentation/providers/course_provider.dart';
import '../../../courses/presentation/providers/enrollment_provider.dart';

part 'admin_provider.g.dart';

@riverpod
Future<List<Enrollment>> courseEnrollments(
    CourseEnrollmentsRef ref, String courseId) async {
  final repo = ref.watch(enrollmentRepositoryProvider);
  return repo.getCourseEnrollments(courseId);
}

@riverpod
Future<AppUser?> userById(UserByIdRef ref, String userId) async {
  final firestore = FirebaseFirestore.instance;
  final doc = await firestore.collection('users').doc(userId).get();
  if (!doc.exists) return null;
  return UserModel.fromFirestore(doc).toEntity();
}

@riverpod
class AdminCourseNotifier extends _$AdminCourseNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> createCourse({
    required String title,
    required String description,
    required String imageUrl,
    required List<String> categoryIds,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final firestore = FirebaseFirestore.instance;
      final now = DateTime.now();
      await firestore.collection('courses').add({
        'title': title,
        'titleLower': title.toLowerCase(),
        'description': description,
        'imageUrl': imageUrl,
        'categoryIds': categoryIds,
        'totalSections': 0,
        'enrollmentCount': 0,
        'averageRating': 0.0,
        'ratingCount': 0,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });
    });
    ref.invalidate(mostEnrolledCoursesProvider);
    ref.invalidate(recentCoursesProvider);
  }

  Future<void> updateCourse({
    required String courseId,
    required String title,
    required String description,
    required String imageUrl,
    required List<String> categoryIds,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('courses').doc(courseId).update({
        'title': title,
        'titleLower': title.toLowerCase(),
        'description': description,
        'imageUrl': imageUrl,
        'categoryIds': categoryIds,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    });
    ref.invalidate(courseDetailProvider);
  }

  Future<void> deleteCourse(String courseId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('courses').doc(courseId).delete();
    });
    ref.invalidate(mostEnrolledCoursesProvider);
    ref.invalidate(recentCoursesProvider);
  }

  Future<void> addSection({
    required String courseId,
    required String title,
    required String summary,
    required String content,
    required int order,
    List<String> imageUrls = const [],
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .add({
        'title': title,
        'titleLower': title.toLowerCase(),
        'summary': summary,
        'content': content,
        'order': order,
        'imageUrls': imageUrls,
        'isFreePreview': order == 1,
      });
      // Update totalSections count
      final sections = await firestore
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .get();
      await firestore.collection('courses').doc(courseId).update({
        'totalSections': sections.docs.length,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    });
    ref.invalidate(courseSectionsProvider);
    ref.invalidate(courseDetailProvider);
  }

  Future<void> updateSection({
    required String courseId,
    required String sectionId,
    required String title,
    required String summary,
    required String content,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .doc(sectionId)
          .update({
        'title': title,
        'titleLower': title.toLowerCase(),
        'summary': summary,
        'content': content,
      });
    });
    ref.invalidate(courseSectionsProvider);
  }

  Future<void> updateExercise({
    required String courseId,
    required String sectionId,
    required String exerciseId,
    required String type,
    required String question,
    required List<String> options,
    required String correctAnswer,
    String? explanation,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .doc(sectionId)
          .collection('exercises')
          .doc(exerciseId)
          .update({
        'type': type,
        'question': question,
        'options': options,
        'correctAnswer': correctAnswer,
        'explanation': explanation,
      });
    });
    ref.invalidate(sectionExercisesProvider);
  }

  Future<void> addExercise({
    required String courseId,
    required String sectionId,
    required String type,
    required String question,
    required List<String> options,
    required String correctAnswer,
    required int order,
    String? explanation,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .doc(sectionId)
          .collection('exercises')
          .add({
        'type': type,
        'question': question,
        'options': options,
        'correctAnswer': correctAnswer,
        'order': order,
        'explanation': explanation,
      });
    });
    ref.invalidate(sectionExercisesProvider);
  }
}
