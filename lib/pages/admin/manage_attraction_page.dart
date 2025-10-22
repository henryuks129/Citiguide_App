import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/city_service.dart';
import '../../models/city_model.dart';
import 'admin_city_attraction_page.dart';

class ManageAttractionsPage extends ConsumerStatefulWidget {
  const ManageAttractionsPage({super.key});

  @override
  ConsumerState<ManageAttractionsPage> createState() => _ManageAttractionsPageState();
}

class _ManageAttractionsPageState extends ConsumerState<ManageAttractionsPage> {
  final cityService = CityService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CityModel>>(
      stream: cityService.getCitiesStream(),
      builder: (context, citySnapshot) {
        if (citySnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final cities = citySnapshot.data ?? [];

        if (cities.isEmpty) {
          return Scaffold(
            body: Center(child: Text('No cities found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text('Manage Attractions')),
          body: ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return Card(
                child: ListTile(
                  title: Text(city.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(city.description),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityAttractionsPage(
                          cityId: city.id,
                          cityName: city.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
