import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:MediTrack/features/pharmacy/data/data_sources/local/hive_pharmacy_data_source.dart";
import "package:MediTrack/features/pharmacy/data/data_sources/remote/maps_api_data_source.dart";
import "package:MediTrack/features/pharmacy/data/repository/pharmacy_repository_impl.dart";
import "package:MediTrack/features/pharmacy/domain/entity/pharmacy.dart";
import "package:MediTrack/features/pharmacy/domain/useCase/get_pharmacies.dart";
import 'package:geolocator/geolocator.dart';

final pharmacyLocalDataSourceProvider = Provider<PharmacyLocalDataSource>(
  (ref) => HivePharmacyDataSource(),
);

final pharmacyRemoteDataSourceProvider = Provider<PharmacyRemoteDataSource>(
  (ref) => MapsApiDataSource(),
);

final pharmacyRepositoryProvider = Provider<PharmacyRepositoryImpl>(
  (ref) => PharmacyRepositoryImpl(
    localDataSource: ref.read(pharmacyLocalDataSourceProvider),
    remoteDataSource: ref.read(pharmacyRemoteDataSourceProvider),
  ),
);

final getPharmaciesUseCaseProvider = Provider<GetPharmacies>(
  (ref) => GetPharmacies(ref.read(pharmacyRepositoryProvider)),
);

final pharmacyListProvider =
    StateNotifierProvider<PharmacyNotifier, AsyncValue<List<Pharmacy>>>((ref) {
      return PharmacyNotifier(ref.read(pharmacyRepositoryProvider));
    });

class PharmacyNotifier extends StateNotifier<AsyncValue<List<Pharmacy>>> {
  final PharmacyRepositoryImpl _pharmacyRepository;

  PharmacyNotifier(this._pharmacyRepository)
    : super(const AsyncValue.loading()) {
    _fetchPharmacies();
  }

  Future<void> _fetchPharmacies() async {
    try {
      state = const AsyncValue.loading();
      Position position = await _determinePosition();
      final pharmacies = await _pharmacyRepository.getPharmacies(
        position.latitude,
        position.longitude,
        50000,
      ); // Example radius
      state = AsyncValue.data(pharmacies);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Location permissions are permanently denied, we cannot request permissions.",
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
