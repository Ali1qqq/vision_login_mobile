import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/Student_Model.dart';

import '../../../constants.dart';
import 'InfoBarchart.dart';
import 'info_card.dart';

class StudentsDetailsChart extends StatefulWidget {
  const StudentsDetailsChart({
    Key? key,required this.students
  }) : super(key: key);


  final Map<String,StudentModel> students;
  @override
  State<StudentsDetailsChart> createState() => _StudentsDetailsChartState();
}

class _StudentsDetailsChartState extends State<StudentsDetailsChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الطلاب".tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          InfoBarChart(touchedIndex: touchedIndex,paiChartSelectionData:paiChartSelectionData(),title:"طالب".tr,subtitle:widget.students.length.toString()),
          InfoCard(
            onTap: (){
              touchedIndex==0?touchedIndex=-1:touchedIndex=0;

              setState(() {

              });
            },
            title: "ذكر".tr,
            amountOfEmployee: widget.students.values.where((element) => element.gender=='ذكر',).length.toString(),
            color: Colors.blue,
          ),
          InfoCard(
            onTap: (){
              touchedIndex==1?touchedIndex=-1:touchedIndex=1;

              setState(() {

              });
            },
            title: "انثى".tr,
            amountOfEmployee: widget.students.values.where((element) => element.gender=='انثى',).length.toString(),
            color: Colors.pink,
          ),
          InfoCard(
            onTap: (){
              touchedIndex==2?touchedIndex=-1:touchedIndex=2;

              setState(() {

              });
            },
            title: "ذوي الهمم".tr,
            amountOfEmployee: "0",
            color: Colors.blueGrey,
          ),


        ],
      ),
    );
  }
  List<PieChartSectionData> paiChartSelectionData() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 50.0 : 30.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: widget.students.values.where((element) => element.gender=='ذكر',).length*1.0,
            title: widget.students.isEmpty?'':'${((widget.students.values.where((element) => element.gender=='ذكر',).length / widget.students.length)*100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.pink,
            value: widget.students.values.where((element) => element.gender=='انثى',).length*1.0,
            title:  widget.students.isEmpty?'':'${((widget.students.values.where((element) => element.gender=='انثى',).length / widget.students.length)*100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blueGrey,
            value: 0,
            title: '${((0 / 1925)*100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
