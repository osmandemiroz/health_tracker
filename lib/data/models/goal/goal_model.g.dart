// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalModelAdapter extends TypeAdapter<GoalModel> {
  @override
  final int typeId = 30;

  @override
  GoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalModel(
      gid: fields[0] as String,
      userId: fields[1] as String,
      goalType: fields[2] as String,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      targetCalories: fields[5] as int,
      targetProtein: fields[6] as int?,
      targetCarbs: fields[7] as int?,
      targetFat: fields[8] as int?,
      currentProgress: fields[9] as double,
      lastUpdatedDate: fields[10] as DateTime?,
      notes: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GoalModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.gid)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.goalType)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.targetCalories)
      ..writeByte(6)
      ..write(obj.targetProtein)
      ..writeByte(7)
      ..write(obj.targetCarbs)
      ..writeByte(8)
      ..write(obj.targetFat)
      ..writeByte(9)
      ..write(obj.currentProgress)
      ..writeByte(10)
      ..write(obj.lastUpdatedDate)
      ..writeByte(11)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
