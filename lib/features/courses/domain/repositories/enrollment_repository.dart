import '../entities/enrollment.dart';
import '../entities/section_result.dart';
import '../entities/course.dart';

abstract class EnrollmentRepository {
  Future<void> enrollInCourse(String userId, String courseId);
  Future<Enrollment?> getEnrollment(String userId, String courseId);
  Future<List<Enrollment>> getUserEnrollments(String userId);
  Future<void> updateEnrollmentProgress(
    String userId,
    String courseId, {
    int? currentSectionOrder,
    List<int>? completedSections,
    double? completionPercentage,
  });
  Future<void> saveSectionResult(
      String userId, String courseId, SectionResult result);
  Future<SectionResult?> getSectionResult(
      String userId, String courseId, String sectionId);
  Future<List<Course>> getRecommendedCourses(String userId, {int limit = 10});
  Future<void> updateLastAccessed(String userId, String courseId);
  Future<void> rateCourse(String userId, String courseId, int rating);
  Future<List<Enrollment>> getCourseEnrollments(String courseId);
}
