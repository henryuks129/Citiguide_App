import 'package:cloud_firestore/cloud_firestore.dart';

class AttractionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add new attraction
  Future<void> addAttraction({
    required String cityId,
    required String name,
    required String description,
    String? phone,
    String? imageUrl,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    final attractionRef = _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc();

    final attractionData = {
      'id': attractionRef.id,
      'name': name,
      'description': description,
      if (phone != null) 'phone': phone,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await attractionRef.set(attractionData);
  }

  /// Stream all attractions in a city
  Stream<List<Map<String, dynamic>>> getAllAttractions(String cityId) {
    return _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Update attraction
  Future<void> updateAttraction({
    required String cityId,
    required String attractionId,
    required String name,
    required String description,
    String? phone,
    String? imageUrl,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    final ref = _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId);

    final updateData = <String, dynamic>{
      'name': name,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Only update optional fields if they’re not null
    if (phone != null) updateData['phone'] = phone;
    if (imageUrl != null) updateData['imageUrl'] = imageUrl;
    if (address != null) updateData['address'] = address;
    if (latitude != null) updateData['latitude'] = latitude;
    if (longitude != null) updateData['longitude'] = longitude;

    await ref.update(updateData);
  }

  /// Delete attraction
  Future<void> deleteAttraction(String cityId, String attractionId) async {
    await _firestore
        .collection('cities')
        .doc(cityId)
        .collection('attractions')
        .doc(attractionId)
        .delete();
  }
}
