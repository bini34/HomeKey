
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/medication.dart';

part 'medication_model.g.dart';

@HiveType(typeId: 1) // Use a different typeId for MedicationModel
@JsonSerializable()
class MedicationModel extends Medication {
  const MedicationModel({
    @HiveField(0) required String medicationId,
    @HiveField(1) required String userId,
    @HiveField(2) required String name,
    @HiveField(3) required String dosage,
    @HiveField(4) required String frequency,
    @HiveField(5) required List<DateTime> timeOfDay,
    @HiveField(6) required DateTime startDate,
    @HiveField(7) DateTime? endDate,
    @HiveField(8) required int stockCount,
    @HiveField(9) String? notes,
  }) : super(
          medicationId: medicationId,
          userId: userId,
          name: name,
          dosage: dosage,
          frequency: frequency,
          timeOfDay: timeOfDay,
          startDate: startDate,
          endDate: endDate,
          stockCount: stockCount,
          notes: notes,
        );

  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      _$MedicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationModelToJson(this);

  factory MedicationModel.fromEntity(Medication medication) {
    return MedicationModel(
      medicationId: medication.medicationId,
      userId: medication.userId,
      name: medication.name,
      dosage: medication.dosage,
      frequency: medication.frequency,
      timeOfDay: medication.timeOfDay,
      startDate: medication.startDate,
      endDate: medication.endDate,
      stockCount: medication.stockCount,
      notes: medication.notes,
    );
  }
}


