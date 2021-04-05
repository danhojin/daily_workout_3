import 'package:fl_chart/fl_chart.dart';
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
      body: Column(
        children: [
          WeightChart(),
          // ListView.builder(
          //   itemCount: items.length,
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Text(items[index].weight.toStringAsFixed(1)),
          //       subtitle: Text(items[index].created.toString()),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}

class WeightChart extends StatelessWidget {
  static const List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: LineChart(
          _weightData(),
        ),
      ),
    );
  }

  LineChartData _weightData() {
    return LineChartData(
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
        ),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          barWidth: 5,
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors
                .map(
                  (color) => color.withOpacity(0.3),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
