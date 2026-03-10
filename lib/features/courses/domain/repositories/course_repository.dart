import '../entities/course.dart';
import '../entities/section.dart';
import '../entities/exercise.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses({
    List<String>? categoryIds,
    int limit = 10,
    String? startAfterId,
  });
  Future<Course> getCourseById(String courseId);
  Future<List<Course>> getMostEnrolledCourses({int limit = 10});
  Future<List<Course>> getRecentCourses({int limit = 10});
  Future<List<Course>> searchCourses(String query, {List<String>? categoryIds});
  Future<List<Section>> searchSections(String query);
  Future<List<Section>> getCourseSections(String courseId);
  Future<Section> getSectionById(String courseId, String sectionId);
  Future<List<Exercise>> getSectionExercises(String courseId, String sectionId);
  Stream<List<Course>> watchMostEnrolledCourses({int limit = 10});
}
