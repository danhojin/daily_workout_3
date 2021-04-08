import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:im_stepper/stepper.dart';
import 'package:quiver/async.dart';

import 'package:daily_workout_3/models.dart';

class ChallengesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Challenge> items = context.watch<ItemsBoxState<Challenge>>().items;
    items.sort((b, a) => a.created.compareTo(b.created));
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenges'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _ExerciseDescription(item: items[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class Challenges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Container(
            child: Text(
              'Push-Ups: 27 hours ago',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SetsSummaryChart(),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChallengeFormPage(
                  title: 'New Challenge',
                ),
              ),
            );
          },
          child: Text(
            'New Challenge',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }
}

class SetsSummaryChart extends StatefulWidget {
  @override
  _SetsSummaryChartState createState() => _SetsSummaryChartState();
}

class _SetsSummaryChartState extends State<SetsSummaryChart> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 20;

  late List<BarChartGroupData> countSets;

  @override
  void initState() {
    super.initState();
    countSets = <BarChartGroupData>[
      makeGroupData(0, 30.0, 36.0),
      makeGroupData(1, 25.0, 27.0),
      makeGroupData(2, 15.0, 12.0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 20),
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  margin: 20.0,
                  getTextStyles: (value) => const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Set 1';
                      case 1:
                        return 'Set 2';
                      case 2:
                        return 'Set 3';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: const EdgeInsets.all(0),
                    tooltipMargin: 5.0,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                    ) {
                      return BarTooltipItem(
                        rod.y.round().toString(),
                        TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  )),
              barGroups: countSets,
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          y: y1,
          colors: [leftBarColor],
          width: width,
        ),
        BarChartRodData(
          y: y2,
          colors: [rightBarColor],
          width: width,
        ),
      ],
      showingTooltipIndicators: [0, 1],
    );
  }
}

class NewExercisePage extends StatefulWidget {
  @override
  _NewExercisePageState createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {
  int currentStep = 0;
  bool complete = false;
  Exercises dropdownValue = Exercises.burpees;
  late List<Step> steps;

  @override
  void initState() {
    super.initState();
    steps = [
      Step(
        title: const Text('Exercise'),
        isActive: true,
        state: StepState.editing,
        content: Column(
          children: [
            DropdownButton<Exercises>(
              icon: Icon(Icons.arrow_back),
              iconSize: 24,
              value: dropdownValue,
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (Exercises? newValue) {
                print(newValue?.name);
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: Exercises.values
                  .map<DropdownMenuItem<Exercises>>(
                    (el) => DropdownMenuItem(
                      value: el,
                      child: Text(el.name),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Rest duration'),
        isActive: true,
        state: StepState.complete,
        content: Column(
          children: [Text('1')],
        ),
      ),
      Step(
        title: const Text('And...'),
        subtitle: const Text('Error!'),
        state: StepState.error,
        content: Column(
          children: [Text('1')],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Exercise'),
      ),
      body: Stepper(
        steps: steps,
      ),
    );
  }
}

class _ExerciseDescription extends StatelessWidget {
  final Challenge item;

  const _ExerciseDescription({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = item.repetitions.map((el) => el.toString()).join('/');
    String subtitle = DateFormat.yMMMMEEEEd().format(item.created);
    subtitle = subtitle + ' (12 min 56 sec)';
    return ListTile(
      leading: Icon(
        Icons.explore,
        size: 40.0,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class ChallengeFormPage extends StatefulWidget {
  final String title;
  final Challenge? challenge;

  const ChallengeFormPage({
    Key? key,
    required this.title,
    this.challenge,
  }) : super(key: key);

  @override
  _ChallengeFormPageState createState() => _ChallengeFormPageState();
}

class _ChallengeFormPageState extends State<ChallengeFormPage> {
  late final form;
  late final Stopwatch _stopwatch;
  late final CountdownTimer _countdownTimer;
  String _minsec = '0:00:00';

  int _set1Value = 20;
  int _set2Value = 15;
  int _set3Value = 15;
  int _activeStep = 0;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'exercise': FormControl<Exercises>(
        validators: [
          Validators.required,
        ],
      ),
      'rest': FormControl<Duration>(
        validators: [
          Validators.required,
        ],
      ),
    });
    _stopwatch = Stopwatch();
    _countdownTimer = CountdownTimer(
      anHour,
      aSecond,
      stopwatch: _stopwatch,
    );
    _stopwatch.stop();
    _countdownTimer.listen((timer) {
      setState(() {
        _minsec = timer.elapsed.toString().split('.').first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              ReactiveDropdownField<Exercises>(
                formControlName: 'exercise',
                decoration: InputDecoration(
                  labelText: 'Exercise',
                ),
                items: Exercises.values
                    .map<DropdownMenuItem<Exercises>>(
                      (el) => DropdownMenuItem(
                        value: el,
                        child: Text(el.name),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(
                height: 20,
              ),
              ReactiveDropdownField<Duration>(
                formControlName: 'rest',
                decoration: InputDecoration(labelText: 'Rest (min)'),
                items: List.generate(
                  5,
                  (index) => Duration(minutes: index + 1),
                )
                    .map<DropdownMenuItem<Duration>>(
                      (el) => DropdownMenuItem(
                        value: el,
                        child: Text(
                          el.inMinutes.toString(),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var width =
                        min(constraints.maxHeight, constraints.maxWidth);
                    return SizedBox(
                      width: width - 40.0,
                      child: ReactiveFormConsumer(
                        builder: (context, form, child) {
                          return ElevatedButton(
                            onPressed: form.valid
                                ? () {
                                    if (_stopwatch.isRunning) {
                                      _stopwatch.stop();
                                    } else {
                                      _stopwatch.start();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  form.valid ? Icons.play_arrow : Icons.pause,
                                  size: 80,
                                ),
                                form.valid
                                    ? Text(
                                        _minsec,
                                        style: TextStyle(fontSize: 20),
                                      )
                                    : Container(),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              DotStepper(
                dotCount: 3,
                dotRadius: 8.0,
                shape: Shape.stadium,
                spacing: 20,
                activeStep: _activeStep,
                indicator: Indicator.shift,
                indicatorDecoration: IndicatorDecoration(
                  strokeColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColor,
                ),
                onDotTapped: (index) {
                  setState(() {
                    _activeStep = index;
                  });
                },
                tappingEnabled: false,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Set 1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      NumberPicker(
                        value: _set1Value,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (value) {
                          setState(() {
                            _set1Value = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Set 2',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      NumberPicker(
                        value: _set2Value,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (value) {
                          setState(() {
                            _set2Value = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Set 3',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      NumberPicker(
                        value: _set3Value,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (value) {
                          setState(() {
                            _set3Value = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
