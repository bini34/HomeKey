import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:MediTrack/features/pharmacy/presentation/providers/pharmacy_provider.dart';

class PharmacyMapScreen extends ConsumerWidget {
  const PharmacyMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmaciesAsyncValue = ref.watch(pharmacyListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pharmacy Map')),
      body: pharmaciesAsyncValue.when(
        data: (pharmacies) {
          final Set<Marker> markers =
              pharmacies
                  .map(
                    (pharmacy) => Marker(
                      markerId: MarkerId(pharmacy.pharmacyId),
                      position: LatLng(pharmacy.latitude, pharmacy.longitude),
                      infoWindow: InfoWindow(
                        title: pharmacy.name,
                        snippet: pharmacy.address,
                      ),
                    ),
                  )
                  .toSet();

          return Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(
                      34.052235,
                      -118.243683,
                    ), // Default to Los Angeles
                    zoom: 10,
                  ),
                  markers: markers,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: pharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = pharmacies[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(pharmacy.name),
                        subtitle: Text(pharmacy.address),
                        trailing: Text('${pharmacy.rating} ★'),
                        onTap: () {
                          // TODO: Show pharmacy details or navigate to a detail screen
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
