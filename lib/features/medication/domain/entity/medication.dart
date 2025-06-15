import 'package:equatable/equatable.dart';

class Medication extends Equatable {
  final String medicationId;
  final String userId;
  final String name;
  final String dosage;
  final String frequency;
  final List<DateTime> timeOfDay;
  final DateTime startDate;
  final DateTime? endDate;
  final int stockCount;
  final String? notes;

  const Medication({
    required this.medicationId,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.timeOfDay,
    required this.startDate,
    this.endDate,
    required this.stockCount,
    this.notes,
  });

  @override
  List<Object?> get props => [
        medicationId,
        userId,
        name,
        dosage,
        frequency,
        timeOfDay,
        startDate,
        endDate,
        stockCount,
        notes,
      ];

  Medication copyWith({
    String? medicationId,
    String? userId,
    String? name,
    String? dosage,
    String? frequency,
    List<DateTime>? timeOfDay,
    DateTime? startDate,
    DateTime? endDate,
    int? stockCount,
    String? notes,
  }) {
    return Medication(
      medicationId: medicationId ?? this.medicationId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      stockCount: stockCount ?? this.stockCount,
      notes: notes ?? this.notes,
    );
  }
}


