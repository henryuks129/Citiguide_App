import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add new review (default: approved = false)
  Future<void> addReview({
    required String cityId,
    required String attractionId,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    final reviewRef = _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .doc();

    await reviewRef.set({
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'approved': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream of approved reviews for a specific attraction
  Stream<List<ReviewModel>> getApprovedReviews(String cityId, String attractionId) {
    return _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .where('approved', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList());
  }

  /// Stream for admin – get all reviews (including unapproved)
  Stream<List<ReviewModel>> getAllReviewsForAdmin(String cityId, String attractionId) {
    return _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList());
  }

  /// Approve review
  Future<void> approveReview(String cityId, String attractionId, String reviewId) async {
    await _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .doc(reviewId)
        .update({'approved': true});
  }

  /// Delete review
  Future<void> deleteReview(String cityId, String attractionId, String reviewId) async {
    await _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId)
        .collection('reviews')
        .doc(reviewId)
        .delete();
  }
}
