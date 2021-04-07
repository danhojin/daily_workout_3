// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExercisesAdapter extends TypeAdapter<Exercises> {
  @override
  final int typeId = 1;

  @override
  Exercises read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Exercises.squats;
      case 1:
        return Exercises.pushUps;
      case 2:
        return Exercises.pullUps;
      case 3:
        return Exercises.burpees;
      case 4:
        return Exercises.sitUps;
      default:
        return Exercises.squats;
    }
  }

  @override
  void write(BinaryWriter writer, Exercises obj) {
    switch (obj) {
      case Exercises.squats:
        writer.writeByte(0);
        break;
      case Exercises.pushUps:
        writer.writeByte(1);
        break;
      case Exercises.pullUps:
        writer.writeByte(2);
        break;
      case Exercises.burpees:
        writer.writeByte(3);
        break;
      case Exercises.sitUps:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExercisesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeAdapter extends TypeAdapter<Challenge> {
  @override
  final int typeId = 0;

  @override
  Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Challenge()
      ..created = fields[0] as DateTime
      ..exercise = fields[1] as Exercises
      ..rest = fields[2] as Duration
      ..durations = (fields[3] as List).cast<Duration>()
      ..repetitions = (fields[4] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, Challenge obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.created)
      ..writeByte(1)
      ..write(obj.exercise)
      ..writeByte(2)
      ..write(obj.rest)
      ..writeByte(3)
      ..write(obj.durations)
      ..writeByte(4)
      ..write(obj.repetitions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BodyRecordAdapter extends TypeAdapter<BodyRecord> {
  @override
  final int typeId = 3;

  @override
  BodyRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BodyRecord()
      ..created = fields[0] as DateTime
      ..weight = fields[1] as double;
  }

  @override
  void write(BinaryWriter writer, BodyRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.created)
      ..writeByte(1)
      ..write(obj.weight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
