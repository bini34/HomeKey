import "package:MediTrack/features/pharmacy/data/data_sources/local/hive_pharmacy_data_source.dart";
import "package:MediTrack/features/pharmacy/data/data_sources/remote/maps_api_data_source.dart";
import "package:MediTrack/features/pharmacy/data/models/pharmacy_model.dart";
import "package:MediTrack/features/pharmacy/domain/entity/pharmacy.dart";
import "package:MediTrack/features/pharmacy/domain/repositories/pharmacy_repository.dart";

class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyLocalDataSource localDataSource;
  final PharmacyRemoteDataSource remoteDataSource;

  PharmacyRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Pharmacy>> getPharmacies(
    double latitude,
    double longitude,
    double radius,
  ) async {
    // For simplicity, we will always fetch from remote for now.
    // In a real application, you might cache these results locally.
    final remotePharmacies = await remoteDataSource.getPharmacies(
      latitude,
      longitude,
      radius,
    );
    for (var pharmacy in remotePharmacies) {
      await localDataSource.savePharmacy(pharmacy);
    }
    return remotePharmacies;
  }
}
