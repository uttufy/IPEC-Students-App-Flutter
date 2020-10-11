import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudents/data/repo/session.dart';
import 'package:ipecstudents/theme/colors.dart';
import 'package:provider/provider.dart';

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
    return Consumer<Session>(
      builder: (context, session, child) {
        return Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.70,
              child: LineChart(
                mainData(session),
              ),
            ),
          ],
        );
      },
    );
  }

  LineChartData mainData(Session session) {
    return LineChartData(
      lineTouchData: LineTouchData(
          enabled: true,
          fullHeightTouchLine: false,
          touchTooltipData: LineTouchTooltipData(tooltipBgColor: kLighterGrey)),
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
            if (value.toInt() != 0 && value.toInt() != 10)
              return session.graphDays[value.toInt()].split('-')[0] +
                  "\n" +
                  session.graphDays[value.toInt()]
                      .split('(')[1]
                      .toString()
                      .substring(0, 3);
            else
              return '';
            // switch (value.toInt()) {
            //   case 0:
            //     return ;
            //   case 5:
            //     return 'Last 10 Days';
            //   case 9:
            //     return '';
            // }
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
      maxX: 10,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, session.graph.elementAt(session.graph.length - 11)),
            FlSpot(1, session.graph.elementAt(session.graph.length - 10)),
            FlSpot(2, session.graph.elementAt(session.graph.length - 9)),
            FlSpot(3, session.graph.elementAt(session.graph.length - 8)),
            FlSpot(4, session.graph.elementAt(session.graph.length - 7)),
            FlSpot(5, session.graph.elementAt(session.graph.length - 6)),
            FlSpot(6, session.graph.elementAt(session.graph.length - 5)),
            FlSpot(7, session.graph.elementAt(session.graph.length - 4)),
            FlSpot(8, session.graph.elementAt(session.graph.length - 3)),
            FlSpot(9, session.graph.elementAt(session.graph.length - 2)),
            FlSpot(10, session.graph.elementAt(session.graph.length - 1))
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
