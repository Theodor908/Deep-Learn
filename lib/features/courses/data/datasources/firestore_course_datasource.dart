import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';
import '../models/course_model.dart';
import '../models/exercise_model.dart';
import '../models/review_model.dart';
import '../models/section_model.dart';

class FirestoreCourseDatasource {
  final FirebaseFirestore _firestore;

  FirestoreCourseDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _coursesCollection =>
      _firestore.collection('courses');

  CollectionReference get _categoriesCollection =>
      _firestore.collection('categories');

  // ── Courses ──────────────────────────────────────────────

  Future<List<CourseModel>> getCourses({
    List<String>? categoryIds,
    int limit = 10,
    DocumentSnapshot? startAfterDocument,
  }) async {
    Query query = _coursesCollection.orderBy('createdAt', descending: true);

    if (categoryIds != null && categoryIds.isNotEmpty) {
      query = query.where('categoryIds', arrayContainsAny: categoryIds);
    }

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    query = query.limit(limit);

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList();
  }

  Future<CourseModel> getCourseById(String courseId) async {
    final doc = await _coursesCollection.doc(courseId).get();
    if (!doc.exists) {
      throw Exception('Course not found: $courseId');
    }
    return CourseModel.fromFirestore(doc);
  }

  Future<List<CourseModel>> getMostEnrolledCourses({int limit = 10}) async {
    final snapshot = await _coursesCollection
        .orderBy('enrollmentCount', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList();
  }

  Future<List<CourseModel>> getRecentCourses({int limit = 10}) async {
    final snapshot = await _coursesCollection
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList();
  }

  Future<List<CourseModel>> searchCourses(
    String query, {
    List<String>? categoryIds,
  }) async {
    // Firestore doesn't support full-text search natively.
    // Fetch all courses and filter client-side for substring matching.
    Query firestoreQuery = _coursesCollection.orderBy('createdAt', descending: true);

    if (categoryIds != null && categoryIds.isNotEmpty) {
      firestoreQuery =
          firestoreQuery.where('categoryIds', arrayContainsAny: categoryIds);
    }

    final snapshot = await firestoreQuery.get();
    final allCourses = snapshot.docs
        .map((doc) => CourseModel.fromFirestore(doc))
        .toList();

    final lowerQuery = query.toLowerCase();
    return allCourses.where((course) {
      final title = (course.title).toLowerCase();
      final description = (course.description).toLowerCase();
      return title.contains(lowerQuery) || description.contains(lowerQuery);
    }).toList();
  }

  Stream<List<CourseModel>> watchMostEnrolledCourses({int limit = 10}) {
    return _coursesCollection
        .orderBy('enrollmentCount', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourseModel.fromFirestore(doc))
            .toList());
  }

  /// Returns the last document snapshot for pagination cursor.
  Future<DocumentSnapshot?> getLastDocument({
    List<String>? categoryIds,
    int limit = 10,
    DocumentSnapshot? startAfterDocument,
  }) async {
    Query query = _coursesCollection.orderBy('createdAt', descending: true);

    if (categoryIds != null && categoryIds.isNotEmpty) {
      query = query.where('categoryIds', arrayContainsAny: categoryIds);
    }

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    query = query.limit(limit);
    final snapshot = await query.get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
  }

  Future<List<SectionModel>> searchSections(String query) async {
    // Fetch all sections and filter client-side for substring matching.
    final coursesSnapshot = await _coursesCollection.get();
    final results = <SectionModel>[];
    final lowerQuery = query.toLowerCase();

    for (final courseDoc in coursesSnapshot.docs) {
      final sectionsSnapshot =
          await courseDoc.reference.collection('sections').get();
      for (final doc in sectionsSnapshot.docs) {
        final model = SectionModel.fromFirestore(doc, courseDoc.id);
        if (model.title.toLowerCase().contains(lowerQuery) ||
            model.summary.toLowerCase().contains(lowerQuery)) {
          results.add(model);
        }
      }
    }

    return results.take(20).toList();
  }

  // ── Sections ─────────────────────────────────────────────

  Future<List<SectionModel>> getCourseSections(String courseId) async {
    final snapshot = await _coursesCollection
        .doc(courseId)
        .collection('sections')
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => SectionModel.fromFirestore(doc, courseId))
        .toList();
  }

  Future<SectionModel> getSectionById(
      String courseId, String sectionId) async {
    final doc = await _coursesCollection
        .doc(courseId)
        .collection('sections')
        .doc(sectionId)
        .get();
    if (!doc.exists) {
      throw Exception('Section not found: $sectionId');
    }
    return SectionModel.fromFirestore(doc, courseId);
  }

  // ── Exercises ────────────────────────────────────────────

  Future<List<ExerciseModel>> getSectionExercises(
      String courseId, String sectionId) async {
    final snapshot = await _coursesCollection
        .doc(courseId)
        .collection('sections')
        .doc(sectionId)
        .collection('exercises')
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => ExerciseModel.fromFirestore(doc, sectionId))
        .toList();
  }

  // ── Categories ───────────────────────────────────────────

  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _categoriesCollection.orderBy('name').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<CategoryModel>> watchCategories() {
    return _categoriesCollection
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc))
            .toList());
  }

  // ── Reviews ─────────────────────────────────────────────

  Future<List<ReviewModel>> getCourseReviews(String courseId) async {
    final snapshot = await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => ReviewModel.fromFirestore(doc))
        .toList();
  }

  Future<ReviewModel?> getUserReview(String courseId, String userId) async {
    final snapshot = await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return ReviewModel.fromFirestore(snapshot.docs.first);
  }

  Future<void> addReview(String courseId, ReviewModel review) async {
    await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .doc(review.id)
        .set(review.toFirestore());
  }

  Future<void> updateReview(
    String courseId,
    String reviewId,
    String text,
    int rating,
  ) async {
    await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .doc(reviewId)
        .update({
      'text': text,
      'rating': rating,
      'updatedAt': Timestamp.now(),
    });
  }
}
