import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudents/theme/colors.dart';

class AttendanceGraph extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
    const Color(0xffFFFFFF),
  ];
  final List<Color> gradientColorsLine = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: LineChart(
            mainData(),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
              const TextStyle(color: kGrey, fontFamily: 'Averta'),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'Aug';
              case 5:
                return 'Sep';
              case 8:
                return 'Oct';
            }
            return '';
          },
          margin: 10,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
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
          colors: gradientColorsLine,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradientTo: Offset(0, 1),
            gradientColorStops: [0, 0.3, 1],
            colors:
                gradientColors.map((color) => color.withOpacity(0.8)).toList(),
          ),
        ),
      ],
    );
  }
}
