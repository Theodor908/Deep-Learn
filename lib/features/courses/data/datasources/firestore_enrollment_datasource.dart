import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/enrollment_model.dart';
import '../models/section_result_model.dart';

class FirestoreEnrollmentDatasource {
  final FirebaseFirestore _firestore;

  FirestoreEnrollmentDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _enrollmentsCollection =>
      _firestore.collection('enrollments');

  CollectionReference get _enrollmentPairsCollection =>
      _firestore.collection('enrollmentPairs');

  // ── Enrollment CRUD ────────────────────────────────────

  Future<void> createEnrollment(EnrollmentModel enrollment) async {
    final docId = enrollment.documentId;
    await _enrollmentsCollection.doc(docId).set(enrollment.toFirestore());

    await _firestore
        .collection('courses')
        .doc(enrollment.courseId)
        .update({'enrollmentCount': FieldValue.increment(1)});

    try {
      await _updateEnrollmentPairs(enrollment.userId, enrollment.courseId);
    } catch (_) {}
  }

  Future<EnrollmentModel?> getEnrollment(
      String userId, String courseId) async {
    final docId = '${userId}_$courseId';
    final doc = await _enrollmentsCollection.doc(docId).get();
    if (!doc.exists) return null;
    return EnrollmentModel.fromFirestore(doc);
  }

  Future<List<EnrollmentModel>> getUserEnrollments(String userId) async {
    final snapshot = await _enrollmentsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('lastAccessedAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => EnrollmentModel.fromFirestore(doc))
        .toList();
  }

  Future<void> updateEnrollmentProgress(
    String userId,
    String courseId, {
    int? currentSectionOrder,
    List<int>? completedSections,
    double? completionPercentage,
  }) async {
    final docId = '${userId}_$courseId';
    final updates = <String, dynamic>{};

    if (currentSectionOrder != null) {
      updates['currentSectionOrder'] = currentSectionOrder;
    }
    if (completedSections != null) {
      updates['completedSections'] =
          FieldValue.arrayUnion(completedSections);
    }
    if (completionPercentage != null) {
      updates['completionPercentage'] = completionPercentage;
    }

    if (updates.isNotEmpty) {
      await _enrollmentsCollection.doc(docId).update(updates);
    }
  }

  Future<void> updateLastAccessed(String userId, String courseId) async {
    final docId = '${userId}_$courseId';
    await _enrollmentsCollection.doc(docId).update({
      'lastAccessedAt': Timestamp.now(),
    });
  }

  // ── Ratings ───────────────────────────────────────────

  Future<void> rateCourse(
    String userId,
    String courseId,
    int rating,
  ) async {
    final docId = '${userId}_$courseId';
    await _enrollmentsCollection.doc(docId).update({'rating': rating});

    final enrollments = await _enrollmentsCollection
        .where('courseId', isEqualTo: courseId)
        .where('rating', isGreaterThan: 0)
        .get();

    if (enrollments.docs.isNotEmpty) {
      double total = 0;
      for (final doc in enrollments.docs) {
        total += (doc['rating'] as num).toDouble();
      }
      final average = total / enrollments.docs.length;
      await _firestore.collection('courses').doc(courseId).update({
        'averageRating': average,
        'ratingCount': enrollments.docs.length,
      });
    }
  }

  Future<List<EnrollmentModel>> getCourseEnrollments(String courseId) async {
    final snapshot = await _enrollmentsCollection
        .where('courseId', isEqualTo: courseId)
        .orderBy('enrolledAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => EnrollmentModel.fromFirestore(doc))
        .toList();
  }

  // ── Section Results ────────────────────────────────────

  Future<void> saveSectionResult(
    String userId,
    String courseId,
    SectionResultModel result,
  ) async {
    final enrollmentDocId = '${userId}_$courseId';
    await _enrollmentsCollection
        .doc(enrollmentDocId)
        .collection('sectionResults')
        .doc(result.sectionId)
        .set(result.toFirestore(), SetOptions(merge: true));
  }

  Future<SectionResultModel?> getSectionResult(
    String userId,
    String courseId,
    String sectionId,
  ) async {
    final enrollmentDocId = '${userId}_$courseId';
    final doc = await _enrollmentsCollection
        .doc(enrollmentDocId)
        .collection('sectionResults')
        .doc(sectionId)
        .get();
    if (!doc.exists) return null;
    return SectionResultModel.fromFirestore(doc);
  }

  // ── Collaborative Filtering Pairs ──────────────────────

  Future<void> _updateEnrollmentPairs(
    String userId,
    String newCourseId,
  ) async {
    final existingEnrollments = await _enrollmentsCollection
        .where('userId', isEqualTo: userId)
        .get();

    final batch = _firestore.batch();

    for (final doc in existingEnrollments.docs) {
      final otherCourseId = doc['courseId'] as String;
      if (otherCourseId == newCourseId) continue;

      final pairId = _buildPairId(newCourseId, otherCourseId);

      batch.set(
        _enrollmentPairsCollection.doc(pairId),
        {
          'courseIds': [newCourseId, otherCourseId]..sort(),
          'coEnrollmentCount': FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
    }

    if (existingEnrollments.docs.length > 1 ||
        (existingEnrollments.docs.length == 1 &&
            existingEnrollments.docs.first['courseId'] != newCourseId)) {
      await batch.commit();
    }
  }

  String _buildPairId(String courseIdA, String courseIdB) {
    final sorted = [courseIdA, courseIdB]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // ── Recommendation Queries ─────────────────────────────

  Future<List<Map<String, dynamic>>> getEnrollmentPairs(
    String courseId, {
    int limit = 20,
  }) async {
    final snapshot = await _enrollmentPairsCollection
        .where('courseIds', arrayContains: courseId)
        .orderBy('coEnrollmentCount', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final courseIds = List<String>.from(data['courseIds']);
      final pairedCourseId =
          courseIds.firstWhere((id) => id != courseId);
      return {
        'courseId': pairedCourseId,
        'coEnrollmentCount': data['coEnrollmentCount'] as int,
      };
    }).toList();
  }

  Future<int> getTotalEnrollmentCount() async {
    final snapshot = await _enrollmentsCollection.count().get();
    return snapshot.count ?? 0;
  }
}
