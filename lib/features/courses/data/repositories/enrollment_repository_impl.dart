import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/entities/section_result.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/firestore_course_datasource.dart';
import '../datasources/firestore_enrollment_datasource.dart';
import '../models/enrollment_model.dart';
import '../models/section_result_model.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final FirestoreEnrollmentDatasource _enrollmentDatasource;
  final FirestoreCourseDatasource _courseDatasource;

  EnrollmentRepositoryImpl(
    this._enrollmentDatasource,
    this._courseDatasource,
  );

  @override
  Future<void> enrollInCourse(String userId, String courseId) async {
    final now = DateTime.now();
    final enrollment = EnrollmentModel(
      userId: userId,
      courseId: courseId,
      enrolledAt: now,
      lastAccessedAt: now,
    );
    await _enrollmentDatasource.createEnrollment(enrollment);
  }

  @override
  Future<Enrollment?> getEnrollment(String userId, String courseId) async {
    final model = await _enrollmentDatasource.getEnrollment(userId, courseId);
    return model?.toEntity();
  }

  @override
  Future<List<Enrollment>> getUserEnrollments(String userId) async {
    final models = await _enrollmentDatasource.getUserEnrollments(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateEnrollmentProgress(
    String userId,
    String courseId, {
    int? currentSectionOrder,
    List<int>? completedSections,
    double? completionPercentage,
  }) async {
    await _enrollmentDatasource.updateEnrollmentProgress(
      userId,
      courseId,
      currentSectionOrder: currentSectionOrder,
      completedSections: completedSections,
      completionPercentage: completionPercentage,
    );
  }

  @override
  Future<void> saveSectionResult(
    String userId,
    String courseId,
    SectionResult result,
  ) async {
    final model = SectionResultModel.fromEntity(result);
    await _enrollmentDatasource.saveSectionResult(userId, courseId, model);
  }

  @override
  Future<SectionResult?> getSectionResult(
    String userId,
    String courseId,
    String sectionId,
  ) async {
    final model = await _enrollmentDatasource.getSectionResult(
      userId,
      courseId,
      sectionId,
    );
    return model?.toEntity();
  }

  @override
  Future<void> updateLastAccessed(String userId, String courseId) async {
    await _enrollmentDatasource.updateLastAccessed(userId, courseId);
  }

  @override
  Future<void> rateCourse(String userId, String courseId, int rating) async {
    await _enrollmentDatasource.rateCourse(userId, courseId, rating);
  }

  @override
  Future<List<Enrollment>> getCourseEnrollments(String courseId) async {
    final models = await _enrollmentDatasource.getCourseEnrollments(courseId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Course>> getRecommendedCourses(
    String userId, {
    int limit = 10,
  }) async {
    // Try collaborative filtering if enough data exists
    final totalEnrollments =
        await _enrollmentDatasource.getTotalEnrollmentCount();

    if (totalEnrollments >=
        AppConstants.collaborativeFilteringMinEnrollments) {
      return _getCollaborativeRecommendations(userId, limit: limit);
    }

    return _getFallbackRecommendations(userId, limit: limit);
  }

  Future<List<Course>> _getCollaborativeRecommendations(
    String userId, {
    required int limit,
  }) async {
    final userEnrollments =
        await _enrollmentDatasource.getUserEnrollments(userId);
    final enrolledCourseIds =
        userEnrollments.map((e) => e.courseId).toSet();

    if (enrolledCourseIds.isEmpty) {
      return _getFallbackRecommendations(userId, limit: limit);
    }

    final courseScores = <String, int>{};

    for (final courseId in enrolledCourseIds) {
      final pairs = await _enrollmentDatasource.getEnrollmentPairs(courseId);
      for (final pair in pairs) {
        final pairedCourseId = pair['courseId'] as String;
        if (!enrolledCourseIds.contains(pairedCourseId)) {
          courseScores[pairedCourseId] =
              (courseScores[pairedCourseId] ?? 0) +
                  (pair['coEnrollmentCount'] as int);
        }
      }
    }

    if (courseScores.isEmpty) {
      return _getFallbackRecommendations(userId, limit: limit);
    }

    final sortedCourseIds = courseScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final recommendedIds =
        sortedCourseIds.take(limit).map((e) => e.key).toList();

    final courses = <Course>[];
    for (final id in recommendedIds) {
      final model = await _courseDatasource.getCourseById(id);
      courses.add(model.toEntity());
    }

    return courses;
  }

  Future<List<Course>> _getFallbackRecommendations(
    String userId, {
    required int limit,
  }) async {
    final userEnrollments =
        await _enrollmentDatasource.getUserEnrollments(userId);
    final enrolledCourseIds =
        userEnrollments.map((e) => e.courseId).toSet();

    final userCategoryIds = <String>{};
    for (final enrollment in userEnrollments) {
      final course =
          await _courseDatasource.getCourseById(enrollment.courseId);
      userCategoryIds.addAll(course.categoryIds);
    }

    final recommendedCourses = <Course>[];

    if (userCategoryIds.isNotEmpty) {
      final tagMatches = await _courseDatasource.getCourses(
        categoryIds: userCategoryIds.toList(),
        limit: limit,
      );
      for (final model in tagMatches) {
        if (!enrolledCourseIds.contains(model.id)) {
          recommendedCourses.add(model.toEntity());
        }
      }
    }

    // Fill rest with trending
    if (recommendedCourses.length < limit) {
      final remaining = limit - recommendedCourses.length;
      final trending =
          await _courseDatasource.getMostEnrolledCourses(limit: remaining + enrolledCourseIds.length);
      final existingIds =
          recommendedCourses.map((c) => c.id).toSet();

      for (final model in trending) {
        if (!enrolledCourseIds.contains(model.id) &&
            !existingIds.contains(model.id)) {
          recommendedCourses.add(model.toEntity());
          if (recommendedCourses.length >= limit) break;
        }
      }
    }

    return recommendedCourses;
  }
}
