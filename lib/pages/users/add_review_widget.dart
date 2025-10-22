import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/review_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddReviewWidget extends ConsumerStatefulWidget {
  final String cityId;
  final String attractionId;

  const AddReviewWidget({
    super.key,
    required this.cityId,
    required this.attractionId,
  });

  @override
  ConsumerState<AddReviewWidget> createState() => _AddReviewWidgetState();
}

class _AddReviewWidgetState extends ConsumerState<AddReviewWidget> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _rating = 3;

  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final service = ref.read(reviewServiceProvider);
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to post a review.')),
        );
        return;
      }

      await service.addReview(
        cityId: widget.cityId,
        attractionId: widget.attractionId,
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous',
        rating: _rating,
        comment: _commentController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted! Waiting for admin approval.'),
        ),
      );

      _commentController.clear();
      setState(() => _rating = 3);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Leave a Review',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      starIndex <= _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => _rating = starIndex.toDouble()),
                  );
                }),
              ),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Write your comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (val) =>
                val == null || val.isEmpty ? 'Please write something' : null,
              ),
              SizedBox(height: 10),
              _isSubmitting
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: _submitReview,
                icon: Icon(Icons.send),
                label: Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
