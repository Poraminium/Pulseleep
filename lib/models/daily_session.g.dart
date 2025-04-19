// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailySessionAdapter extends TypeAdapter<DailySession> {
  @override
  final int typeId = 1;

  @override
  DailySession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySession(
      date: fields[0] as DateTime,
      pulses: (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailySession obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.pulses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
