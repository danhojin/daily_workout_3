import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:daily_workout_3/models.dart';

class Boxes {
  static const challenges = 'challenges';
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(ChallengeAdapter());
  var box = await Hive.openBox<Challenge>(Boxes.challenges);
  await box.clear();
  var data = mockChallenges(10);
  print(data.length);
  print(data[0].repetitions);
  box.addAll(data);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ItemsBoxState<Challenge>(
        name: Boxes.challenges,
      ),
    ),
  ], child: MyApp()));
}

List<Challenge> mockChallenges(int length) {
  var rng = Random();

  return List.generate(
    length,
    (index) => Challenge()
      ..created = DateTime.now().subtract(
        Duration(days: rng.nextInt(21)),
      )
      ..exercise = Exercise.values[rng.nextInt(Exercise.values.length)]
      ..rest = Duration(seconds: 60)
      ..durations = List.generate(
        3,
        (index) => Duration(
          seconds: 60 + 30 * rng.nextInt(6),
        ),
      ).toList()
      ..repetitions = List.generate(
        3,
        (index) => 10 + rng.nextInt(20),
      ).toList(),
  ).toList();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Challenge> items = context.watch<ItemsBoxState<Challenge>>().items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Challenges'),
      ),
      body: Center(
        child: Text(items.length.toString()),
      ),
    );
  }
}
