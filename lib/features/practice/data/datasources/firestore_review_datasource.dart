import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review_item_model.dart';

class FirestoreReviewDatasource {
  final FirebaseFirestore _firestore;

  FirestoreReviewDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _reviewItemsCollection =>
      _firestore.collection('reviewSchedule');

  Future<void> createReviewItem(ReviewItemModel item) async {
    await _reviewItemsCollection.doc(item.documentId).set(item.toFirestore());
  }

  Future<List<ReviewItemModel>> getDueReviewItems(String userId) async {
    final now = Timestamp.now();
    final snapshot = await _reviewItemsCollection
        .where('userId', isEqualTo: userId)
        .where('nextReviewAt', isLessThanOrEqualTo: now)
        .orderBy('nextReviewAt')
        .get();
    return snapshot.docs
        .map((doc) => ReviewItemModel.fromFirestore(doc))
        .toList();
  }

  Future<void> updateReviewItem(ReviewItemModel item) async {
    await _reviewItemsCollection
        .doc(item.documentId)
        .update(item.toFirestore());
  }

  Future<List<ReviewItemModel>> getUserReviewItems(String userId) async {
    final snapshot = await _reviewItemsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('nextReviewAt')
        .get();
    return snapshot.docs
        .map((doc) => ReviewItemModel.fromFirestore(doc))
        .toList();
  }
}
