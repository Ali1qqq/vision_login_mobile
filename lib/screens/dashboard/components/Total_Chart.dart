import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/core/constant/constants.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';

import '../../../core/Styling/app_style.dart';

class TotalBarChart extends StatefulWidget {
  TotalBarChart({super.key, required this.index,required this.selectedYear});

  final Color dark = blueColor;
  final Color normal = primaryColor.withAlpha(1);
  final Color light = primaryColor;
  final int index;
  final String selectedYear;

  @override
  State<StatefulWidget> createState() => TotalBarChartState();
}

class TotalBarChartState extends State<TotalBarChart> {
  ExpensesViewModel expensesViewModel = Get.find<ExpensesViewModel>();
  ParentsViewModel parentViewModel = Get.find<ParentsViewModel>();
  EmployeeViewModel managementViewModel = Get.find<EmployeeViewModel>();

  Widget bottomTitles(double value, TitleMeta meta) {
    final style = AppStyles.headLineStyle4;
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
    if (value == meta.max||value == meta.min) {
      return Container();
    }
    final style = AppStyles.headLineStyle4;
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
          width: max(1200, Get.width),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barsSpace = 24.0 * constraints.maxWidth / 400;
                final barsWidth = 8.0 * constraints.maxWidth / 400;
                return BarChart(
                  BarChartData(
                    minY:  widget.index == 2
                        ? -parentViewModel.getAllReceiveMaxPay()/2
                        : 0,
                    maxY: widget.index == 0
                        ? expensesViewModel.getMaxExpenses()
                        : widget.index == 1
                            ? parentViewModel.getAllReceiveMaxPay()
                            : parentViewModel.getAllReceiveMaxPay(),
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
                          reservedSize: 60,
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
                        color: secondaryColor.withOpacity(0.5)/*Colors.white.withOpacity(0.5)*/,
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
                ? expensesViewModel.getExpensesAtMonth("1",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("01",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("01",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("1",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("1",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("01",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("01",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("1",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("1",widget.selectedYear),
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
      /*BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("2")
                : widget.index == 1
                ? parentViewModel.getAllReceivePayAtMonth("02")
                : parentViewModel.getAllReceivePayAtMonth("02") - managementViewModel.getAllSalariesAtMonth("2") - expensesViewModel.getExpensesAtMonth("2"),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("2")
                      : widget.index == 1
                      ? parentViewModel.getAllReceivePayAtMonth("02")
                      : parentViewModel.getAllReceivePayAtMonth("02") - managementViewModel.getAllSalariesAtMonth("2") - expensesViewModel.getExpensesAtMonth("2"),
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
      ),*/
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.index == 0
                ? expensesViewModel.getExpensesAtMonth("3",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("03",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("03",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("3",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("3",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("3",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("03",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("03",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("3",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("3",widget.selectedYear),
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
                ? expensesViewModel.getExpensesAtMonth("4",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("04",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("04",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("4",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("4",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("4",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("04",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("04",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("4",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("4",widget.selectedYear),
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
                ? expensesViewModel.getExpensesAtMonth("5",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("05",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("05",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("5",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("5",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("5",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("05",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("05",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("5",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("5",widget.selectedYear),
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
                ? expensesViewModel.getExpensesAtMonth("6",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("06",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("06",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("6",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("6",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("6",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("06",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("06",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("6",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("6",widget.selectedYear),
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
                ? expensesViewModel.getExpensesAtMonth("7",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("07",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("07",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("7",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("7",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("7",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("07",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("07",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("7",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("7",widget.selectedYear),
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
                ? expensesViewModel.getExpensesAtMonth("8",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("08",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("08",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("8",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("8",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("8",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("08",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("08",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("8",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("8",widget.selectedYear),
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
                ? expensesViewModel.getExpensesAtMonth("9",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("09",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("09",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("9",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("9",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("9",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("09",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("09",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("9",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("9",widget.selectedYear),
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
                ? expensesViewModel.getExpensesAtMonth("10",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("10",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("10",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("10",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("10",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("10",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("10",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("10",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("10",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("10",widget.selectedYear),
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
                ? expensesViewModel.getExpensesAtMonth("11",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("11",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("11",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("11",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("11",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("11",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("11",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("11",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("11",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("11",widget.selectedYear),
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
                ? expensesViewModel.getExpensesAtMonth("12",widget.selectedYear)
                : widget.index == 1
                    ? parentViewModel.getAllReceivePayAtMonth("12",widget.selectedYear)
                    : parentViewModel.getAllReceivePayAtMonth("12",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("12",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("12",widget.selectedYear),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  widget.index == 0
                      ? expensesViewModel.getExpensesAtMonth("12",widget.selectedYear)
                      : widget.index == 1
                          ? parentViewModel.getAllReceivePayAtMonth("12",widget.selectedYear)
                          : parentViewModel.getAllReceivePayAtMonth("12",widget.selectedYear) - managementViewModel.getAllSalariesAtMonth("12",widget.selectedYear) - expensesViewModel.getExpensesAtMonth("12",widget.selectedYear),
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
