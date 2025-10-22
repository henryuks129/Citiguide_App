import 'package:flutter/material.dart';
import '../../services/attraction_service.dart';

class CityAttractionsPage extends StatefulWidget {
  final String cityId;
  final String cityName;

  const CityAttractionsPage({
    super.key,
    required this.cityId,
    required this.cityName,
  });

  @override
  State<CityAttractionsPage> createState() => _CityAttractionsPageState();
}

class _CityAttractionsPageState extends State<CityAttractionsPage> {
  final attractionService = AttractionService();

  //Delete attraction
  Future<void> _deleteAttraction(String attractionId) async {
    try {
      await attractionService.deleteAttraction(widget.cityId, attractionId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attraction deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete attraction: $e')),
      );
    }
  }

  // Edit attraction dialog
  Future<void> _editAttraction(Map<String, dynamic> attraction) async {
    final nameController = TextEditingController(text: attraction['name']);
    final descController =
    TextEditingController(text: attraction['description']);
    final phoneController = TextEditingController(text: attraction['phone'] ?? '');
    final imageController = TextEditingController(text: attraction['imageUrl'] ?? '');
    final addressController = TextEditingController(text: attraction['address'] ?? '');
    final latController = TextEditingController(
        text: attraction['latitude']?.toString() ?? '');
    final lngController = TextEditingController(
        text: attraction['longitude']?.toString() ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Attraction'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: latController,
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lngController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await attractionService.updateAttraction(
                  cityId: widget.cityId,
                  attractionId: attraction['id'],
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                  phone: phoneController.text.trim().isEmpty
                      ? null
                      : phoneController.text.trim(),
                  imageUrl: imageController.text.trim().isEmpty
                      ? null
                      : imageController.text.trim(),
                  address: addressController.text.trim().isEmpty
                      ? null
                      : addressController.text.trim(),
                  latitude: latController.text.trim().isEmpty
                      ? null
                      : double.tryParse(latController.text.trim()),
                  longitude: lngController.text.trim().isEmpty
                      ? null
                      : double.tryParse(lngController.text.trim()),
                );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Attraction updated successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Update failed: $e')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.cityName} Attractions')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: attractionService.getAllAttractions(widget.cityId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          }

          final attractions = snapshot.data ?? [];

          if (attractions.isEmpty) {
            return Center(child: Text('No attractions yet.'));
          }

          return ListView.builder(
            itemCount: attractions.length,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final attr = attractions[index];

              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: attr['imageUrl'] != null && attr['imageUrl'].isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      attr['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported),
                    ),
                  )
                      : Icon(Icons.location_city, size: 40, color: Colors.teal),
                  title: Text(attr['name'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (attr['description'] != null)
                        Text(attr['description'], maxLines: 2, overflow: TextOverflow.ellipsis),
                      if (attr['address'] != null)
                        Text('📍 ${attr['address']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      if (attr['phone'] != null)
                        Text('📞 ${attr['phone']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:  Icon(Icons.edit, color: Colors.teal),
                        onPressed: () => _editAttraction(attr),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAttraction(attr['id']),
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
