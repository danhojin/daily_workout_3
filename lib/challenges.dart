import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
