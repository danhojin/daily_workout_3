// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 1;

  @override
  Exercise read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Exercise.squats;
      case 1:
        return Exercise.pushUps;
      case 2:
        return Exercise.pullUps;
      case 3:
        return Exercise.burpees;
      case 4:
        return Exercise.sitUps;
      default:
        return Exercise.squats;
    }
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    switch (obj) {
      case Exercise.squats:
        writer.writeByte(0);
        break;
      case Exercise.pushUps:
        writer.writeByte(1);
        break;
      case Exercise.pullUps:
        writer.writeByte(2);
        break;
      case Exercise.burpees:
        writer.writeByte(3);
        break;
      case Exercise.sitUps:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
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
      ..exercise = fields[1] as Exercise
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
