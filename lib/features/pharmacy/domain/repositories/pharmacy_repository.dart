
import "../../domain/entity/pharmacy.dart";

abstract class PharmacyRepository {
  Future<List<Pharmacy>> getPharmacies(double latitude, double longitude, double radius);
}


