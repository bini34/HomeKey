
import 'package:hive/hive.dart';
import '../../models/pharmacy_model.dart';

abstract class PharmacyLocalDataSource {
  Future<void> savePharmacy(PharmacyModel pharmacy);
  Future<PharmacyModel?> getPharmacy(String pharmacyId);
  Future<List<PharmacyModel>> getAllPharmacies();
  Future<void> deletePharmacy(String pharmacyId);
}

class HivePharmacyDataSource implements PharmacyLocalDataSource {
  static const String _pharmacyBoxName = 'pharmacyBox';

  @override
  Future<void> savePharmacy(PharmacyModel pharmacy) async {
    final box = await Hive.openBox<PharmacyModel>(_pharmacyBoxName);
    await box.put(pharmacy.pharmacyId, pharmacy);
  }

  @override
  Future<PharmacyModel?> getPharmacy(String pharmacyId) async {
    final box = await Hive.openBox<PharmacyModel>(_pharmacyBoxName);
    return box.get(pharmacyId);
  }

  @override
  Future<List<PharmacyModel>> getAllPharmacies() async {
    final box = await Hive.openBox<PharmacyModel>(_pharmacyBoxName);
    return box.values.toList();
  }

  @override
  Future<void> deletePharmacy(String pharmacyId) async {
    final box = await Hive.openBox<PharmacyModel>(_pharmacyBoxName);
    await box.delete(pharmacyId);
  }
}


