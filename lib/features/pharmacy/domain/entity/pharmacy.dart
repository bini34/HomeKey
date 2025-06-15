import 'package:equatable/equatable.dart';

class Pharmacy extends Equatable {
  final String pharmacyId;
  final String name;
  final String address;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String>? stockList;

  const Pharmacy({
    required this.pharmacyId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.stockList,
  });

  @override
  List<Object?> get props => [
        pharmacyId,
        name,
        address,
        phoneNumber,
        latitude,
        longitude,
        rating,
        stockList,
      ];

  Pharmacy copyWith({
    String? pharmacyId,
    String? name,
    String? address,
    String? phoneNumber,
    double? latitude,
    double? longitude,
    double? rating,
    List<String>? stockList,
  }) {
    return Pharmacy(
      pharmacyId: pharmacyId ?? this.pharmacyId,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      stockList: stockList ?? this.stockList,
    );
  }
}


