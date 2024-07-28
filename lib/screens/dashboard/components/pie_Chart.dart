import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vision_dashboard/screens/Widgets/Filled_Container_Color.dart';

import '../../../constants.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  @override
  Widget build(BuildContext context) {
    return     Container(

      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: secondaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("عدد الطلاب",style: Styles.headLineStyle2.copyWith(color: Colors.white),),
                Spacer(),
                Expanded(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FilledContainerColor(color: blueColor),
                          SizedBox(width: 5,),

                          Text(
                            "ذكور",
                            textAlign: TextAlign.center,
                            style: Styles.headLineStyle3.copyWith(color: Colors.white),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "٩٧٨",
                            style: Styles.headLineStyle3.copyWith(color: Colors.white),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          FilledContainerColor(color: Colors.pink),
                          SizedBox(width: 5,),
                          Text(
                            "اناث",
                            textAlign: TextAlign.center,
                            style: Styles.headLineStyle3.copyWith(color: Colors.white),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "٨٩١",
                            style: Styles.headLineStyle3.copyWith(color: Colors.white),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
SizedBox(height: 15,),
          Container(
            // padding: const EdgeInsets.all(15.0),
            alignment: Alignment.center,
            child: SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      startDegreeOffset: -90,
                      sections: paiChartSelectionData,
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "١٧٦٨",
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 0.5,
                          ),
                        ),
                        SizedBox(height: defaultPadding,),
                        Text(
                          "طالب",
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 0.5,
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
        ],
      ),
    );
  }

  List<PieChartSectionData> paiChartSelectionData = [
    PieChartSectionData(
      color: Colors.pink,
      value: 978,
      showTitle: false,
      radius: 20,
    ),
    PieChartSectionData(
      color: blueColor,
      value: 891,
      showTitle: false,
      radius: 20,
    ),

  ];
}
