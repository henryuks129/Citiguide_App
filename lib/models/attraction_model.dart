class AttractionModel {
  final String id;
  final String cityId;
  final String name;
  final String description;
  final String? phone;
  final String? imageUrl;
  final String? address;
  final double? latitude;
  final double? longitude;

  AttractionModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.description,
    this.phone,
    this.imageUrl,
    this.address,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cityId': cityId,
      'name': name,
      'description': description,
      'phone': phone,
      'imageUrl': imageUrl,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory AttractionModel.fromMap(Map<String, dynamic> map) {
    return AttractionModel(
      id: map['id'] ?? '',
      cityId: map['cityId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      phone: map['phone'],
      imageUrl: map['imageUrl'],
      address: map['address'],
      latitude: (map['latitude'] != null)
          ? (map['latitude'] as num).toDouble()
          : null,
      longitude: (map['longitude'] != null)
          ? (map['longitude'] as num).toDouble()
          : null,
    );
  }
}
