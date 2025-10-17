import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/review_provider.dart';

class ManageReviewsPage extends ConsumerWidget {
  const ManageReviewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewService = ref.watch(reviewServiceProvider);

    Stream<QuerySnapshot>? reviewStream;
    try {
      reviewStream = FirebaseFirestore.instance
          .collectionGroup('reviews')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      // Firestore throws if the index doesn't exist
      return Scaffold(
        appBar: AppBar(title: Text('Manage Reviews')),
        body: Center(
          child: Text(
            'Unable to load reviews. Please create the required Firestore index.\n\nError: $e',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Manage Reviews')),
      body: StreamBuilder<QuerySnapshot>(
        stream: reviewStream,
        builder: (context, snapshot) {
          // Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          //Error State
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          //  No Reviews
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reviews found.'));
          }

          // Map reviews safely
          final reviews = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>? ?? {};
            final createdAt = data['createdAt'];
            final safeCreatedAt = (createdAt is Timestamp)
                ? createdAt.toDate()
                : DateTime.now(); // fallback if missing

            return {
              'docId': doc.id,
              'path': doc.reference.path,
              'userName': data['userName'] ?? 'Anonymous',
              'comment': data['comment'] ?? '',
              'rating': data['rating'] ?? 0,
              'approved': data['approved'] ?? false,
              'createdAt': safeCreatedAt,
            };
          }).toList();

          //  Review List
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final pathParts = review['path'].split('/');
              final cityId = pathParts.length > 1 ? pathParts[1] : '';
              final attractionId = pathParts.length > 3 ? pathParts[3] : '';
              final reviewId = pathParts.length > 5 ? pathParts[5] : '';

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(review['userName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review['comment']),
                      SizedBox(height: 5),
                      Row(
                        children: List.generate(
                          5,
                              (i) => Icon(
                            i < review['rating']
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        review['approved']
                            ? '✅ Approved'
                            : '⏳ Pending Approval',
                        style: TextStyle(
                          color: review['approved']
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      try {
                        if (value == 'approve') {
                          await reviewService.approveReview(
                              cityId, attractionId, reviewId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Review approved!')),
                          );
                        } else if (value == 'delete') {
                          await reviewService.deleteReview(
                              cityId, attractionId, reviewId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Review deleted!')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      if (!review['approved'])
                        PopupMenuItem(
                          value: 'approve',
                          child: Text('Approve Review'),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Review'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
