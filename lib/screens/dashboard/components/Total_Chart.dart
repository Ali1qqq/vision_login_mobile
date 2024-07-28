import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';
import 'package:vision_dashboard/controller/expenses_view_model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';

class TotalBarChart extends StatefulWidget {
  TotalBarChart({super.key, required this.index});

  final Color dark = blueColor;
  final Color normal = primaryColor.withAlpha(1);
  final Color light = primaryColor;
  final int index;

  @override
  State<StatefulWidget> createState() => TotalBarChartState();
}

class TotalBarChartState extends State<TotalBarChart> {
  ExpensesViewModel expensesViewModel = Get.find<ExpensesViewModel>();
  StudentViewModel studentViewModel = Get.find<StudentViewModel>();
  AccountManagementViewModel managementViewModel =
      Get.find<AccountManagementViewModel>();

  Widget bottomTitles(double value, TitleMeta meta) {
    final style = Styles.headLineStyle4;
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'يناير'.tr;
        break;
      case 1:
        text = 'فبراير'.tr;
        break;
      case 2:
        text = 'مارس'.tr;
        break;
      case 3:
        text = 'أبريل'.tr;
        break;
      case 4:
        text = 'مايو'.tr;
        break;
      case 5:
        text = 'يونيو'.tr;
        break;
      case 6:
        text = 'يوليو'.tr;
        break;
      case 7:
        text = 'أغسطس'.tr;
        break;
      case 8:
        text = 'سبتمبر'.tr;
        break;
      case 9:
        text = 'أكتوبر'.tr;
        break;
      case 10:
        text = 'نوفمبر'.tr;
        break;
      case 11:
        text = 'ديسمبر'.tr;
        break;
      default:
        text = '';
        break;
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
        physics: ClampingScrollPhysics(),
        reverse: true,
        child: SizedBox(
          width:max(1200,Get.width),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barsSpace = 24.0 * constraints.maxWidth / 400;
              final barsWidth = 8.0 * constraints.maxWidth / 400;
              return BarChart(
                BarChartData(
                  maxY: widget.index == 0
                      ? expensesViewModel.getMaxExpenses()
                      : widget.index == 1
                          ? studentViewModel.getAllReceiveMaxPay()
                          : studentViewModel.getAllReceiveMaxPay(),
                  alignment: BarChartAlignment.center,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.rodStackItems[0].toY.toString()} درهم',
                          const TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.w500,
                          ),
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
        ));
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        showingTooltipIndicators: List.generate(
          11,
          (index) => index + 1,
        ),
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("1")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("01")
                    : studentViewModel.getAllReceivePayAtMonth("01") -
                        expensesViewModel.getExpensesAtMonth("1"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("1")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("01")
                          : studentViewModel.getAllReceivePayAtMonth("01") -
                              managementViewModel.getAllSalariesAtMonth("1") -
                              expensesViewModel.getExpensesAtMonth("1"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("2")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("02")
                    : studentViewModel.getAllReceivePayAtMonth("02") -
                        managementViewModel.getAllSalariesAtMonth("2") -
                        expensesViewModel.getExpensesAtMonth("2"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("2")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("02")
                          : studentViewModel.getAllReceivePayAtMonth("02") -
                              managementViewModel.getAllSalariesAtMonth("2") -
                              expensesViewModel.getExpensesAtMonth("2"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("3")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("03")
                    : studentViewModel.getAllReceivePayAtMonth("03") -
                        managementViewModel.getAllSalariesAtMonth("3") -
                        expensesViewModel.getExpensesAtMonth("3"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("3")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("03")
                          : studentViewModel.getAllReceivePayAtMonth("03") -
                              managementViewModel.getAllSalariesAtMonth("3") -
                              expensesViewModel.getExpensesAtMonth("3"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("4")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("04")
                    : studentViewModel.getAllReceivePayAtMonth("04") -
                        managementViewModel.getAllSalariesAtMonth("4") -
                        expensesViewModel.getExpensesAtMonth("4"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("4")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("04")
                          : studentViewModel.getAllReceivePayAtMonth("04") -
                              managementViewModel.getAllSalariesAtMonth("4") -
                              expensesViewModel.getExpensesAtMonth("4"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("5")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("05")
                    : studentViewModel.getAllReceivePayAtMonth("05") -
                        managementViewModel.getAllSalariesAtMonth("5") -
                        expensesViewModel.getExpensesAtMonth("5"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("5")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("05")
                          : studentViewModel.getAllReceivePayAtMonth("05") -
                              managementViewModel.getAllSalariesAtMonth("5") -
                              expensesViewModel.getExpensesAtMonth("5"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("6")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("06")
                    : studentViewModel.getAllReceivePayAtMonth("06") -
                        managementViewModel.getAllSalariesAtMonth("6") -
                        expensesViewModel.getExpensesAtMonth("6"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("6")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("06")
                          : studentViewModel.getAllReceivePayAtMonth("06") -
                              managementViewModel.getAllSalariesAtMonth("6") -
                              expensesViewModel.getExpensesAtMonth("6"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("7")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("07")
                    : studentViewModel.getAllReceivePayAtMonth("07") -
                        managementViewModel.getAllSalariesAtMonth("7") -
                        expensesViewModel.getExpensesAtMonth("7"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("7")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("07")
                          : studentViewModel.getAllReceivePayAtMonth("07") -
                              managementViewModel.getAllSalariesAtMonth("7") -
                              expensesViewModel.getExpensesAtMonth("7"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 7,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("8")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("08")
                    : studentViewModel.getAllReceivePayAtMonth("08") -
                        managementViewModel.getAllSalariesAtMonth("8") -
                        expensesViewModel.getExpensesAtMonth("8"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("8")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("08")
                          : studentViewModel.getAllReceivePayAtMonth("08") -
                              managementViewModel.getAllSalariesAtMonth("8") -
                              expensesViewModel.getExpensesAtMonth("8"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 8,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("9")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("09")
                    : studentViewModel.getAllReceivePayAtMonth("09") -
                        managementViewModel.getAllSalariesAtMonth("9") -
                        expensesViewModel.getExpensesAtMonth("9"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("9")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("09")
                          : studentViewModel.getAllReceivePayAtMonth("09") -
                              managementViewModel.getAllSalariesAtMonth("9") -
                              expensesViewModel.getExpensesAtMonth("9"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 9,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("10")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("10")
                    : studentViewModel.getAllReceivePayAtMonth("10") -
                        managementViewModel.getAllSalariesAtMonth("10") -
                        expensesViewModel.getExpensesAtMonth("10"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("10")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("10")
                          : studentViewModel.getAllReceivePayAtMonth("10") -
                              managementViewModel.getAllSalariesAtMonth("10") -
                              expensesViewModel.getExpensesAtMonth("10"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 10,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("11")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("11")
                    : studentViewModel.getAllReceivePayAtMonth("11") -
                        managementViewModel.getAllSalariesAtMonth("11") -
                        expensesViewModel.getExpensesAtMonth("11"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("11")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("11")
                          : studentViewModel.getAllReceivePayAtMonth("11") -
                              managementViewModel.getAllSalariesAtMonth("11") -
                              expensesViewModel.getExpensesAtMonth("11"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 11,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("12")
                : widget.index == 1
                    ? studentViewModel.getAllReceivePayAtMonth("12")
                    : studentViewModel.getAllReceivePayAtMonth("12") -
                        managementViewModel.getAllSalariesAtMonth("12") -
                        expensesViewModel.getExpensesAtMonth("12"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("12")
                      : widget.index == 1
                          ? studentViewModel.getAllReceivePayAtMonth("12")
                          : studentViewModel.getAllReceivePayAtMonth("12") -
                              managementViewModel.getAllSalariesAtMonth("12") -
                              expensesViewModel.getExpensesAtMonth("12"),
                  widget.index == 0
                      ? widget.dark
                      : widget.index == 1
                          ? widget.normal
                          : widget.light),
            ],
            borderRadius: BorderRadius.circular(4),
            width: barsWidth,
          ),
        ],
      ),
    ];
  }
}
