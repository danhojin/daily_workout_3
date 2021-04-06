import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:daily_workout_3/main.dart';
import 'package:daily_workout_3/models.dart';

class ChallengesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Challenge> items = context.watch<ItemsBoxState<Challenge>>().items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenges'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _ExerciseDescription(title: items[index].exercise.toString());
        },
      ),
    );
  }
}

class _ExerciseDescription extends StatelessWidget {
  final String title;

  const _ExerciseDescription({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
    );
  }
}
