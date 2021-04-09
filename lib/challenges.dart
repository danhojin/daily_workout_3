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
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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

  final Stopwatch _stopwatch = Stopwatch();
  late CountdownTimer _countdownTimer;
  String _topLabel = 'Set 1';
  String _timeLabel = '00:00';
  String _bottomLabel = 'Start';
  int _remaining = 0;
  int _timerActionStep = 0;
  Random rng = Random();

  List<int> _repititions = [20, 15, 12];
  List<Duration> _durations = List.generate(3, (index) => Duration());
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

    _countdownTimer = CountdownTimer(
      anHour,
      aSecond,
      stopwatch: _stopwatch,
    );
  }

  String _formatMinsec(Duration d) {
    var minsec = d.toString().split('.').first.split(':');
    return minsec.sublist(1).join(':');
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
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
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Rest (min)',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
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
                child: ReactiveFormConsumer(
                  builder: (BuildContext context, FormGroup formGroup,
                      Widget? child) {
                    return GestureDetector(
                      onTap: formGroup.valid
                          ? () =>
                              _buildTimerState(formGroup.control('rest').value)
                          : null,
                      child: SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          infoProperties: InfoProperties(
                            topLabelText: _topLabel,
                            modifier: (value) => _timeLabel,
                            mainLabelStyle: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color:
                                  formGroup.valid ? Colors.black : Colors.grey,
                            ),
                            bottomLabelText: _bottomLabel,
                          ),
                          startAngle: -90.0,
                          angleRange: 360.0,
                          customColors: formGroup.valid
                              ? null
                              : CustomSliderColors(
                                  progressBarColor: Colors.grey,
                                ),
                        ),
                        min: 0.0,
                        max: 1.0,
                        initialValue: formGroup.valid
                            ? _timerActionStep % 2 == 0
                                ? min(
                                    _remaining.toDouble() /
                                        formGroup
                                            .control('rest')
                                            .value
                                            .inSeconds
                                            .toDouble(),
                                    1.0)
                                : rng.nextDouble()
                            : 1.0,
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
                children: List.generate(
                  3,
                  (index) => Column(
                    children: [
                      Text(
                        'Set ${index + 1}:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Lap: ' + _formatMinsec(_durations[index]),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      NumberPicker(
                        value: _repititions[index],
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (value) {
                          setState(() {
                            _repititions[index] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buildTimerState(Duration rest) {
    switch (_timerActionStep) {
      case 0: // count up
        _topLabel = 'Set ${_activeStep + 1}';
        _bottomLabel = 'Stop';
        _countdownTimer.cancel();
        _stopwatch
          ..stop()
          ..reset();
        _countdownTimer = CountdownTimer(
          anHour,
          aSecond,
          stopwatch: _stopwatch,
        )..listen((event) {
            setState(() {
              _timeLabel = event.elapsed
                  .toString()
                  .split('.')
                  .first
                  .split(':')
                  .sublist(1)
                  .join(':');
              _remaining = event.remaining.inSeconds;
            });
          });
        break;
      case 1:
        _topLabel = 'Set ${_activeStep + 1}';
        _bottomLabel = 'Cool down';
        _countdownTimer.cancel();
        _stopwatch
          ..stop()
          ..reset();
        _countdownTimer = CountdownTimer(
          rest,
          aSecond,
          stopwatch: _stopwatch,
        )..listen((event) {
            setState(() {
              _timeLabel = event.remaining
                  .toString()
                  .split('.')
                  .first
                  .split(':')
                  .sublist(1)
                  .join(':');
              _remaining = event.remaining.inSeconds;
            });
          });
        _activeStep = (_activeStep + 1) % 3;
        break;
    }

    _timerActionStep = (_timerActionStep + 1) % 2;
  }
}
