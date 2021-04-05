import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'models.g.dart';

class ItemsBoxState<T> with ChangeNotifier {
  final String name;
  List<T> items = [];

  ItemsBoxState({required this.name}) {
    var box = Hive.box<T>(name);
    items = box.values.toList().cast<T>();
    box.watch().listen((event) {
      items = box.values.toList().cast<T>(); // no problem with box scope?
      notifyListeners();
    });
  }
}

@HiveType(typeId: 1)
enum Exercise {
  @HiveField(0)
  squats,
  @HiveField(1)
  pushUps,
  @HiveField(2)
  pullUps,
  @HiveField(3)
  burpees,
  @HiveField(4)
  sitUps,
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

extension ExerciseExtension on Exercise {
  String get name => this.toString().split('.').last.capitalize();
}

class DurationAdapter extends TypeAdapter<Duration> {
  // https://github.com/hivedb/hive/issues/212
  @override
  final typeId = 2;

  @override
  void write(BinaryWriter writer, Duration value) =>
      writer.writeInt(value.inMicroseconds);

  @override
  Duration read(BinaryReader reader) =>
      Duration(microseconds: reader.readInt());
}

const exerciseString = <Exercise, String>{
  Exercise.squats: 'Squats',
  Exercise.pushUps: 'Push-ups',
  Exercise.pullUps: 'Pull-ups',
  Exercise.burpees: 'Burpees',
  Exercise.sitUps: 'Sit-ups',
};

@HiveType(typeId: 0)
class Challenge extends HiveObject {
  @HiveField(0)
  DateTime created = DateTime(1900);
  @HiveField(1)
  Exercise exercise = Exercise.pushUps;
  @HiveField(2)
  Duration rest = Duration(seconds: 60);
  @HiveField(3)
  List<Duration> durations = [];
  @HiveField(4)
  List<int> repetitions = [];
}

@HiveType(typeId: 3)
class BodyRecord extends HiveObject {
  @HiveField(0)
  DateTime created = DateTime(1900);
  @HiveField(1)
  double weight = 10.0;
}
