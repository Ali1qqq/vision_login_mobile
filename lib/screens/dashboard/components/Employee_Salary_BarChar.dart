
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/models/account_management_model.dart';

import '../../../controller/account_management_view_model.dart';

class EmployeeSalaryBarChart extends StatefulWidget {
  EmployeeSalaryBarChart({super.key,required this.selectedMonth});

  final Color dark = Colors.black.withBlue(100);
  final Color normal = primaryColor.withAlpha(1);
  final Color light = primaryColor;
  final String selectedMonth;

  @override
  State<StatefulWidget> createState() => EmployeeSalaryBarChartState();
}

class EmployeeSalaryBarChartState extends State<EmployeeSalaryBarChart> {

  AccountManagementViewModel accountManageVM =
  Get.find<AccountManagementViewModel>();

  Widget bottomTitles(double value, TitleMeta meta) {
    final style = Styles.headLineStyle4;
    String text;

    if (value < accountManageVM.allAccountManagement.length) {
      text = accountManageVM.allAccountManagement.values.elementAt(value.toInt()).fullName!.split(" ")[0];
    } else {
      text = 's';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    final style = Styles.headLineStyle4;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      physics: ClampingScrollPhysics(),
      child: SizedBox(
        // aspectRatio: 1.66,
        width:max(1200,Get.width),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 24.0 * constraints.maxWidth / 400;
            final barsWidth = 8.0 * constraints.maxWidth / 400;
            return BarChart(
              BarChartData(

                maxY: 3500,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${accountManageVM.allAccountManagement.values.elementAt(group.x.toInt()).fullName}: ',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: rod.rodStackItems[0].toY.toString(),
                            style: const TextStyle(
                              color: blueColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(

                  show: true,
                  bottomTitles: AxisTitles(

                    sideTitles: SideTitles(
                      showTitles: true,

                      reservedSize: 40,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.5),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: getData(barsWidth, barsSpace),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {

    List<BarChartGroupData> getBarChartData() {

      List<BarChartGroupData> data = List.generate(accountManageVM.allAccountManagement.length, (index) {
        AccountManagementModel account=accountManageVM.allAccountManagement.values.elementAt(index);
        return   BarChartGroupData(
          x: index,
          barsSpace: barsSpace,

          barRods: [
            BarChartRodData(
              toY:account.salary!*1.0,
              rodStackItems: [

                  BarChartRodStackItem(0, accountManageVM.getUserSalariesAtMonth(widget.selectedMonth, account.id), widget.dark,),
                  BarChartRodStackItem(accountManageVM.getUserSalariesAtMonth(widget.selectedMonth, account.id),account.salary!*1.0, widget.light),

              ],
              borderRadius: BorderRadius.circular(4),
              width: barsWidth,
            ),
          ],
        );
      },);

/*      for (int i = 0; i <= accountManageVM.allAccountManagement.length+20; i++) {

        data.add(

        );
      }*/

      return data;
    }
   return getBarChartData();
  }

}