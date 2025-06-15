import "package:MediTrack/features/pharmacy/domain/entity/pharmacy.dart";
import "package:MediTrack/features/pharmacy/domain/repositories/pharmacy_repository.dart";

class GetPharmacies {
  final PharmacyRepository repository;

  GetPharmacies(this.repository);

  Future<List<Pharmacy>> call(
    double latitude,
    double longitude,
    double radius,
  ) async {
    return await repository.getPharmacies(latitude, longitude, radius);
  }
}
