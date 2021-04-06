import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:daily_workout_3/body_records.dart';
import 'package:daily_workout_3/challenges.dart';
import 'package:daily_workout_3/models.dart';

class Boxes {
  static const challenges = 'challenges';
  static const bodyRecodes = 'bodyRecords';
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(ChallengeAdapter());
  Hive.registerAdapter(BodyRecordAdapter());
  var box = await Hive.openBox<Challenge>(Boxes.challenges);
  await box.clear();
  var data = mockChallenges(10);
  box.addAll(data);
  await Hive.openBox<BodyRecord>(Boxes.bodyRecodes).then(
    (box) async {
      await box.clear();
      box.addAll(
        List.generate(
          10,
          (index) => BodyRecord()
            ..created = DateTime.now().subtract(
              Duration(days: Random().nextInt(20)),
            )
            ..weight = 70.0 + Random().nextDouble() * 10.0,
        ).toList(),
      );
    },
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ItemsBoxState<Challenge>(
        name: Boxes.challenges,
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => ItemsBoxState<BodyRecord>(
        name: Boxes.bodyRecodes,
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ListQueue<int> _navQueue = ListQueue.from([0, 0]);
  int _selectedNav = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _bodies = [
      Container(),
      WeightChart(),
      Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BodyRecordsPage(),
                  ),
                );
              },
              child: Text("Body Weight Tracker"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengesPage(),
                  ),
                );
              },
              child: Text("Challenges"),
            ),
          ],
        ),
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        // Goodbyd message
        if (_navQueue.isEmpty) {
          return true;
        } else {
          _navQueue.removeLast();
          if (_navQueue.isNotEmpty) {
            setState(() {
              _selectedNav = _navQueue.last;
            });
            return false;
          }
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Challenges'),
        ),
        body: _bodies[_selectedNav],
        floatingActionButton: _selectedNav == 1
            ? FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedNav,
          onTap: (index) {
            setState(() {
              _navQueue.addLast(index);
              _selectedNav = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Ionicons.barbell_outline),
              label: 'Challenge',
            ),
            BottomNavigationBarItem(
              icon: const FaIcon(FontAwesomeIcons.balanceScaleRight),
              label: 'Metrics',
            ),
            BottomNavigationBarItem(
              icon: const FaIcon(FontAwesomeIcons.chartLine),
              label: 'Stats',
            ),
          ],
        ),
      ),
    );
  }
}

class FormPage extends StatelessWidget {
  final Widget title;
  final Widget body;

  const FormPage({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: body,
        ),
      ),
    );
  }
}
