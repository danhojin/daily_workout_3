import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models.dart';

class BodyRecordsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var items = context.watch<ItemsBoxState<BodyRecord>>().items;
    items.sort((a, b) => b.created.compareTo(a.created));

    return Scaffold(
      appBar: AppBar(
        title: Text('Body weight tracker'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].weight.toStringAsFixed(1)),
            subtitle: Text(items[index].created.toString()),
          );
        },
      ),
    );
  }
}
