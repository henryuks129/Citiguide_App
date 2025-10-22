import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'attraction_details_page.dart';

class CityAttractionsPage extends StatelessWidget {
  final String cityId;
  final String cityName;

  const CityAttractionsPage({
    super.key,
    required this.cityId,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    final cityRef = FirebaseFirestore.instance.collection('cities').doc(cityId);

    return Scaffold(
      appBar: AppBar(title: Text('$cityName Attractions')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: cityRef.snapshots(),
        builder: (context, citySnapshot) {
          if (citySnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (citySnapshot.hasError) {
            return Center(child: Text('Error loading city: ${citySnapshot.error}'));
          }

          if (!citySnapshot.hasData || !citySnapshot.data!.exists) {
            return Center(child: Text('City not found.'));
          }

          final cityData = citySnapshot.data!.data() as Map<String, dynamic>;
          final cityImage = cityData['imageUrl'] ?? '';
          final cityDescription = cityData['description'] ?? '';

          return StreamBuilder<QuerySnapshot>(
            stream: cityRef
                .collection('attractions')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, attractionSnapshot) {
              if (attractionSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (attractionSnapshot.hasError) {
                return Center(
                    child: Text('Error loading attractions: ${attractionSnapshot.error}'));
              }

              final attractions = attractionSnapshot.data?.docs ?? [];

              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  // City image
                  // City image at the top
                  if (cityImage.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        cityImage,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        // show loading indicator while image loads
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 220,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        // fallback if image fails to load
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 220,
                            color: Colors.grey[300],
                            child: Icon(Icons.location_city, size: 80, color: Colors.white70),
                          );
                        },
                      ),
                    ),

                  SizedBox(height: 12),

                  // City description
                  Text(
                    cityDescription,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),

                  SizedBox(height: 24),
                  Divider(),

                  // Attractions title
                  Text(
                    'City Attractions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Attractions list
                  if (attractions.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text('No attractions available.')),
                    )
                  else
                    ...attractions.map((doc) {
                      final attraction = doc.data() as Map<String, dynamic>;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AttractionDetailsPage(
                                  cityId: cityId,
                                  attractionId: doc.id,
                                ),
                              ),
                            );
                          },
                          leading: attraction['imageUrl'] != null &&
                              attraction['imageUrl'].toString().isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              attraction['imageUrl'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.place_outlined, size: 30),
                                );
                              },
                            ),
                          )
                              : Icon(Icons.place_outlined, size: 40),

                          title: Text(
                            attraction['name'] ?? 'Unknown Attraction',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            attraction['description'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18),
                        ),
                      );
                    }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
