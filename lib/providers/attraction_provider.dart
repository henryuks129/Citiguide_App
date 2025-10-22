import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/attraction_service.dart';

/// Provides an instance of AttractionService
final attractionServiceProvider = Provider<AttractionService>((ref) {
  return AttractionService();
});

/// Provides a stream of attractions for a specific city
final cityAttractionsProvider =
StreamProvider.family<List<Map<String, dynamic>>, String>((ref, cityId) {
  final service = ref.watch(attractionServiceProvider);
  return service.getAllAttractions(cityId);
});

/// State provider for the selected city ID (useful for dropdown or filtering)
// final selectedCityProvider = StateProvider<String?>((ref) => null);

/// Future provider for adding a new attraction
final addAttractionProvider = FutureProvider.autoDispose
    .family<void, Map<String, String>>((ref, data) async {
  final service = ref.watch(attractionServiceProvider);
  await service.addAttraction(
    cityId: data['cityId']!,
    name: data['name']!,
    description: data['description']!,
  );
});
