import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/review_service.dart';
import '../../models/review_model.dart';
import 'add_review_widget.dart';

class AttractionDetailsPage extends StatefulWidget {
  final String cityId;
  final String attractionId;

  const AttractionDetailsPage({
    super.key,
    required this.cityId,
    required this.attractionId,
  });

  @override
  State<AttractionDetailsPage> createState() => _AttractionDetailsPageState();
}

class _AttractionDetailsPageState extends State<AttractionDetailsPage> {
  final user = FirebaseAuth.instance.currentUser;
  bool _isFavorite = false;
  bool _loadingFavorite = true;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    if (user == null) return;

    final favDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.attractionId)
        .get();

    setState(() {
      _isFavorite = favDoc.exists;
      _loadingFavorite = false;
    });
  }

  Future<void> _toggleFavorite(Map<String, dynamic> attractionData) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add favorites')),
      );
      return;
    }

    setState(() => _loadingFavorite = true);

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.attractionId);

    if (_isFavorite) {
      await favRef.delete();
      setState(() => _isFavorite = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites')),
      );
    } else {
      await favRef.set({
        'cityId': widget.cityId,
        'cityName': attractionData['cityName'] ?? 'Unknown City',
        'attractionName': attractionData['name'] ?? 'Unnamed Attraction',
        'imageUrl': attractionData['imageUrl'] ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() => _isFavorite = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favorites')),
      );
    }

    setState(() => _loadingFavorite = false);
  }

  void _launchPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _openInMap(double lat, double lng) async {
    final Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final attractionRef = FirebaseFirestore.instance
        .collection('cities')
        .doc(widget.cityId)
        .collection('attractions')
        .doc(widget.attractionId);

    return Scaffold(
      appBar: AppBar(title: const Text('Attraction Details')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: attractionRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Attraction not found.'));
          }

          final attraction = snapshot.data!.data() as Map<String, dynamic>;
          final name = attraction['name'] ?? 'Unknown Attraction';
          final description = attraction['description'] ?? '';
          final imageUrl = attraction['imageUrl'] ?? '';
          final phone = attraction['phone'] ?? '';
          final address = attraction['address'] ?? '';
          final latitude = (attraction['latitude'] ?? 0).toString();
          final longitude = (attraction['longitude'] ?? 0).toString();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with favorite
                if (imageUrl.isNotEmpty)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: double.infinity,
                            height: 220,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 80, color: Colors.white70),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _loadingFavorite
                            ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : GestureDetector(
                          onTap: () => _toggleFavorite(attraction),
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // Name
                Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // Description
                Text(description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 20),

                // Address
                if (address.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.home_outlined, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(child: Text(address, style: const TextStyle(fontSize: 15))),
                    ],
                  ),
                const SizedBox(height: 12),

                // Phone
                if (phone.isNotEmpty)
                  InkWell(
                    onTap: () => _launchPhone(phone),
                    child: Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          phone,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueAccent, decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Coordinates
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('Lat: $latitude, Lng: $longitude'),
                  ],
                ),
                const SizedBox(height: 12),

                // Open in Google Maps
                ElevatedButton.icon(
                  onPressed: () {
                    final lat = double.tryParse(latitude);
                    final lng = double.tryParse(longitude);
                    if (lat != null && lng != null) _openInMap(lat, lng);
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('Open in Google Maps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),

                // Reviews
                StreamBuilder<List<ReviewModel>>(
                  stream: ReviewService().getApprovedReviews(widget.cityId, widget.attractionId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'Error loading reviews: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No approved reviews yet.');
                    }

                    final reviews = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: reviews.map((r) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(r.userName),
                            subtitle: Text(r.comment),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                5,
                                    (i) => Icon(
                                  i < r.rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),


                SizedBox(height: 20),
                AddReviewWidget(cityId: widget.cityId, attractionId: widget.attractionId),
              ],
            ),
          );
        },
      ),
    );
  }
}
