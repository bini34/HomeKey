
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/pharmacy.dart';

// part 'pharmacy_model.g.dart';

@HiveType(typeId: 5) // Use a different typeId for PharmacyModel
@JsonSerializable()
class PharmacyModel extends Pharmacy {
  const PharmacyModel({
    @HiveField(0) required String pharmacyId,
    @HiveField(1) required String name,
    @HiveField(2) required String address,
    @HiveField(3) required String phoneNumber,
    @HiveField(4) required double latitude,
    @HiveField(5) required double longitude,
    @HiveField(6) required double rating,
    @HiveField(7) List<String>? stockList,
  }) : super(
          pharmacyId: pharmacyId,
          name: name,
          address: address,
          phoneNumber: phoneNumber,
          latitude: latitude,
          longitude: longitude,
          rating: rating,
          stockList: stockList,
        );

  factory PharmacyModel.fromJson(Map<String, dynamic> json) =>
      _$PharmacyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyModelToJson(this);

  factory PharmacyModel.fromEntity(Pharmacy pharmacy) {
    return PharmacyModel(
      pharmacyId: pharmacy.pharmacyId,
      name: pharmacy.name,
      address: pharmacy.address,
      phoneNumber: pharmacy.phoneNumber,
      latitude: pharmacy.latitude,
      longitude: pharmacy.longitude,
      rating: pharmacy.rating,
      stockList: pharmacy.stockList,
    );
  }
}


