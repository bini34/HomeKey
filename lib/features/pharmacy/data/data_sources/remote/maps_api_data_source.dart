
import "../../models/pharmacy_model.dart";

abstract class PharmacyRemoteDataSource {
  Future<List<PharmacyModel>> getPharmacies(double latitude, double longitude, double radius);
}

class MapsApiDataSource implements PharmacyRemoteDataSource {
  @override
  Future<List<PharmacyModel>> getPharmacies(double latitude, double longitude, double radius) async {
    // For now, return static data as a placeholder for a real API call
    return [
      const PharmacyModel(
        pharmacyId: "1",
        name: "Central Pharmacy",
        address: "123 Main St",
        phoneNumber: "555-1111",
        latitude: 34.052235,
        longitude: -118.243683,
        rating: 4.5,
        stockList: ["Medication A", "Medication B"],
      ),
      const PharmacyModel(
        pharmacyId: "2",
        name: "Downtown Drugs",
        address: "456 Oak Ave",
        phoneNumber: "555-2222",
        latitude: 34.055000,
        longitude: -118.250000,
        rating: 4.0,
        stockList: ["Medication C", "Medication D"],
      ),
    ];
  }
}


