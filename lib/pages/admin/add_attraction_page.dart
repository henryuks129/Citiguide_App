import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attraction_provider.dart';
import '../../services/city_service.dart';
import '../../models/city_model.dart';

class AddAttractionPage extends ConsumerStatefulWidget {
  const AddAttractionPage({super.key});

  @override
  ConsumerState<AddAttractionPage> createState() => _AddAttractionPageState();
}

class _AddAttractionPageState extends ConsumerState<AddAttractionPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imageController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  String? _selectedCityId;
  bool _isLoading = false;

  /// Fetch all cities
  Future<List<CityModel>> _fetchCities() async {
    final cityService = CityService();
    return await cityService.getCitiesStream().first;
  }

  /// Submit new attraction
  Future<void> _submitAttraction() async {
    if (!_formKey.currentState!.validate() || _selectedCityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(attractionServiceProvider);

      await service.addAttraction(
        cityId: _selectedCityId!,
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        phone: _phoneController.text.trim(),
        imageUrl: _imageController.text.trim(),
        address: _addressController.text.trim(),
        latitude: double.tryParse(_latController.text.trim()) ?? 0.0,
        longitude: double.tryParse(_lngController.text.trim()) ?? 0.0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attraction added successfully!')),
      );

      _nameController.clear();
      _descController.clear();
      _phoneController.clear();
      _imageController.clear();
      _addressController.clear();
      _latController.clear();
      _lngController.clear();
      setState(() => _selectedCityId = null);

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding attraction: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CityModel>>(
      future: _fetchCities(),
      builder: (context, snapshot) {
        final cities = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(title: const Text('Add Attraction')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      value: _selectedCityId,
                      decoration: const InputDecoration(
                        labelText: 'Select City',
                        border: OutlineInputBorder(),
                      ),
                      items: cities.map((city) {
                        return DropdownMenuItem<String>(
                          value: city.id,
                          child: Text(city.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCityId = value);
                      },
                      validator: (value) =>
                      value == null ? 'Select a city' : null,
                    ),
                    const SizedBox(height: 20),

                    /// Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Attraction Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Enter attraction name' : null,
                    ),
                    const SizedBox(height: 15),

                    /// Description
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter description' : null,
                    ),
                    const SizedBox(height: 15),

                    /// Phone
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter phone number' : null,
                    ),
                    const SizedBox(height: 15),

                    /// Image URL
                    TextFormField(
                      controller: _imageController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter image URL' : null,
                    ),
                    const SizedBox(height: 15),

                    /// Address
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Enter address' : null,
                    ),
                    const SizedBox(height: 15),

                    /// Latitude
                    TextFormField(
                      controller: _latController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter latitude' : null,
                    ),
                    const SizedBox(height: 15),

                    /// Longitude
                    TextFormField(
                      controller: _lngController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter longitude' : null,
                    ),
                    const SizedBox(height: 25),

                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                      icon: const Icon(Icons.add_location_alt),
                      label: const Text('Add Attraction'),
                      style: ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _submitAttraction,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
