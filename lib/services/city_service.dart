import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/city_model.dart';

class CityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a new city with a single image URL
  Future<void> addCity({
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    try {
      await _firestore.collection('cities').add({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error in addCity: $e');
    }
  }

  /// Fetch all cities as a stream of CityModel objects
  Stream<List<CityModel>> getCitiesStream() {
    return _firestore
        .collection('cities')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CityModel(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
    });
  }

  /// Update a city using its document ID (cityId)
  Future<void> updateCity({
    required String cityId,
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    try {
      final docRef = _firestore.collection('cities').doc(cityId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception('City with ID $cityId not found.');
      }

      await docRef.update({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error in updateCity: $e');
    }
  }

  /// Delete a city by its Firestore document ID
  Future<void> deleteCity(String cityId) async {
    try {
      await _firestore.collection('cities').doc(cityId).delete();
    } catch (e) {
      throw Exception('Error deleting city: $e');
    }
  }
}
