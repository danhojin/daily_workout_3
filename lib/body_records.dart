import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class BodyRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeightChart(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 200.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
            child: Center(
              child: Text('BMI'),
            ),
          ),
        ),
      ],
    );
  }
}

class WeightChart extends StatefulWidget {
  static const List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  _WeightChartState createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  double minX = 5.0;
  double maxX = 11.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: GestureDetector(
          onHorizontalDragUpdate: (DragUpdateDetails detail) {
            setState(() {
              var dx = -detail.delta.dx;
              if (dx > 0) {
                dx = min(11, maxX + 0.05 * dx) - maxX;
              } else {
                dx = max(0, minX + 0.05 * dx) - minX;
              }
              maxX = maxX + dx;
              minX = minX + dx;
            });
          },
          child: LineChart(
            _weightData(),
          ),
        ),
      ),
    );
  }

  LineChartData _weightData() {
    return LineChartData(
      clipData: FlClipData.all(),
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
      minX: minX,
      maxX: maxX,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          show: true,
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
            colors: WeightChart.gradientColors
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
