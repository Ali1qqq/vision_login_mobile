import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class InfoBarChart extends StatefulWidget {
   InfoBarChart({
    Key? key,
     required this.touchedIndex, required,required this.paiChartSelectionData, required this.title,required this.subtitle
  }) : super(key: key);

  @override
  State<InfoBarChart> createState() => _InfoBarChartState();
final  int touchedIndex ;
final String title,subtitle;
final List<PieChartSectionData> paiChartSelectionData;
}

class _InfoBarChartState extends State<InfoBarChart> {
int localTouch=-1;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    localTouch=widget.touchedIndex;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      localTouch = -1;
                      return;
                    }

localTouch = pieTouchResponse
                        .touchedSection!.touchedSectionIndex;
                  });

                },
              ),
              sectionsSpace: 1,
              centerSpaceRadius: min(100, max(50, (Get.width/1000)*60)),
              startDegreeOffset: 0,
              sections: widget.paiChartSelectionData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  widget.subtitle,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(
                    color: Color(0xff00308F),
                    fontWeight: FontWeight.w600,
                    height: 0.5,
                  ),
                ),
                SizedBox(height: 10,),
                Text(widget.title)
              ],
            ),
          ),
        ],
      ),
    );
  }

}