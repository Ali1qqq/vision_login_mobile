import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vision_dashboard/constants.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 0,
    maxX: 12,
    maxY: 7,
    minY: 0,
  );

  LineChartData get sampleData2 => LineChartData(
    lineTouchData: lineTouchData2,
    gridData: gridData,
    titlesData: titlesData2,
    borderData: borderData,
    lineBarsData: lineBarsData2,
    minX: 0,
    maxX: 12,
    maxY: 7,
    minY: 0,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
// /*    lineChartBarData1_1,
//     lineChartBarData1_2,
    // lineChartBarData1_3,
  ];

  LineTouchData get lineTouchData2 => const LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(

      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData2 => [
   /* lineChartBarData2_1,
    lineChartBarData2_2,*/
    lineChartBarData2_3,
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {

    case 1:
    text = '100';
    break;
    case 2:
    text = '120';
    break;
    case 3:
    text = '130';
    break;
    case 4:
    text = '140';
    break;
    case 5:
    text = '150';
    break;
    case 6:
    text ='160';
    break;
    case 7:
    text = '170';
    break;
    default:
    return Container();

    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 2:
        text = const Text('Feb', style: style);
        break;
      case 4:
        text = const Text('Mar', style: style);
        break;

      case 6:
        text = const Text('Ape', style: style);
        break;

      case 8:
        text = const Text('May', style: style);
        break;
      case 10:
        text = const Text('Jun', style: style);
        break;


      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom:
      BorderSide(color: Colors.blue.withOpacity(0.2), width: 4),
      left: const BorderSide(color: Colors.transparent),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );

  /*LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: Colors.green,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots:  [
      FlSpot(1, 1),
FlSpot(2, Random().nextDouble()*7),
FlSpot(5, Random().nextDouble()*7),
FlSpot(7, Random().nextDouble()*7),
FlSpot(9, Random().nextDouble()*7),
FlSpot(10, Random().nextDouble()*7),
FlSpot(11.5, Random().nextDouble()*7),

    ],
  );*/

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Colors.pink,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
      color: Colors.pink.withOpacity(0),
    ),
    spots:  [
      FlSpot(0.1,  Random().nextDouble()*7),
      FlSpot(2, Random().nextDouble()*7),
      FlSpot(5, Random().nextDouble()*7),
      FlSpot(7, Random().nextDouble()*7),
      FlSpot(9, Random().nextDouble()*7),
      FlSpot(10, Random().nextDouble()*7),
      FlSpot(11.5, Random().nextDouble()*7),
     FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(10, 2.6),
      FlSpot(10, 3.9),

    ],
  );

 /* LineChartBarData get lineChartBarData1_3 => LineChartBarData(
    isCurved: true,
    color: Colors.cyan,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots:  [
      FlSpot(1, 1),
      FlSpot(2, Random().nextDouble()*7),
      FlSpot(5, Random().nextDouble()*7),
      FlSpot(7, Random().nextDouble()*7),
      FlSpot(9, Random().nextDouble()*7),
      FlSpot(10, Random().nextDouble()*7),
      FlSpot(11.5, Random().nextDouble()*7),
     *//* FlSpot(1, 2.8),
      FlSpot(3, 1.9),
      FlSpot(6, 3),
      FlSpot(10, 1.3),
      FlSpot(13, 2.5),*//*
    ],
  );
*/
/*  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
    isCurved: true,

    color: Colors.green.withOpacity(0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Colors.green.withOpacity(0.2),
    ),
    spots:  [
      FlSpot(0.1,  Random().nextDouble()*7),
      FlSpot(2, Random().nextDouble()*7),
      FlSpot(5, Random().nextDouble()*7),
      FlSpot(7, Random().nextDouble()*7),
      FlSpot(9, Random().nextDouble()*7),
      FlSpot(10, Random().nextDouble()*7),
      FlSpot(11.5, Random().nextDouble()*7),
    ],
  );*/

/*
  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
    isCurved: true,
    color: Colors.pink.withOpacity(0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Colors.pink.withOpacity(0.2),
    ),
    spots:  [
      FlSpot(0.1,  Random().nextDouble()*7),
      FlSpot(2, Random().nextDouble()*7),
      FlSpot(5, Random().nextDouble()*7),
      FlSpot(7, Random().nextDouble()*7),
      FlSpot(9, Random().nextDouble()*7),
      FlSpot(10, Random().nextDouble()*7),
      FlSpot(11.5, Random().nextDouble()*7),
    ],
  );
*/

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
    isCurved: true,

    color:Colors.pink.withOpacity(0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: primaryColor.withOpacity(0.2),
    ),
    spots:  [
      FlSpot(0.01,  Random().nextDouble()*7),
      FlSpot(2, Random().nextDouble()*7),
      FlSpot(5, Random().nextDouble()*7),
      FlSpot(7, Random().nextDouble()*7),
      FlSpot(9, Random().nextDouble()*7),
      FlSpot(10, Random().nextDouble()*7),
      FlSpot(12, Random().nextDouble()*7),
    ],
  );
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1();

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = false;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Vehicles analysis',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  child: _LineChart(isShowingMainData: isShowingMainData),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Color(0xff00308F).withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}