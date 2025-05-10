// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodModelAdapter extends TypeAdapter<FoodModel> {
  @override
  final int typeId = 0;

  @override
  FoodModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodModel(
      id: fields[0] as String,
      title: fields[1] as String,
      calories: fields[2] as double,
      protein: fields[3] as double,
      carbohydrates: fields[4] as double,
      fat: fields[5] as double,
      category: fields[6] as String,
      prepTime: fields[7] as int?,
      cookTime: fields[8] as int?,
      totalTime: fields[9] as int?,
      servingSize: fields[10] as String?,
      imageUrl: fields[11] as String?,
      dietaryFiber: fields[12] as double?,
      amount: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FoodModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.protein)
      ..writeByte(4)
      ..write(obj.carbohydrates)
      ..writeByte(5)
      ..write(obj.fat)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.prepTime)
      ..writeByte(8)
      ..write(obj.cookTime)
      ..writeByte(9)
      ..write(obj.totalTime)
      ..writeByte(10)
      ..write(obj.servingSize)
      ..writeByte(11)
      ..write(obj.imageUrl)
      ..writeByte(12)
      ..write(obj.dietaryFiber)
      ..writeByte(13)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
