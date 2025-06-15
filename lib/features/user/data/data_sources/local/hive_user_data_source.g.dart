// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_user_data_source.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveUserDataSourceImplAdapter
    extends TypeAdapter<HiveUserDataSourceImpl> {
  @override
  final int typeId = 1;

  @override
  HiveUserDataSourceImpl read(BinaryReader reader) {
    return HiveUserDataSourceImpl();
  }

  @override
  void write(BinaryWriter writer, HiveUserDataSourceImpl obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveUserDataSourceImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
