

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controller/account_management_view_model.dart';
import '../../../utils/Dialogs.dart';
import '../../Widgets/Custom_Text_Filed.dart';

class EmployeeTimeChart extends StatefulWidget {
  EmployeeTimeChart({
    super.key,
    Color? lineColor,
    Color? indicatorLineColor,
    Color? indicatorTouchedLineColor,
    Color? indicatorSpotStrokeColor,
    Color? indicatorTouchedSpotStrokeColor,
    Color? bottomTextColor,
    Color? bottomTouchedTextColor,
    Color? averageLineColor,
    Color? tooltipBgColor,
    Color? tooltipTextColor,
  })  : lineColor = lineColor ?? primaryColor,
        indicatorLineColor =
            indicatorLineColor ?? primaryColor.withOpacity(0.2),
        indicatorTouchedLineColor = indicatorTouchedLineColor ?? primaryColor,
        indicatorSpotStrokeColor =
            indicatorSpotStrokeColor ?? primaryColor.withOpacity(0.5),
        indicatorTouchedSpotStrokeColor =
            indicatorTouchedSpotStrokeColor ?? primaryColor,
        bottomTextColor = bottomTextColor ?? primaryColor.withOpacity(0.2),
        bottomTouchedTextColor = bottomTouchedTextColor ?? primaryColor,
        averageLineColor = averageLineColor ?? primaryColor.withOpacity(0.8),
        tooltipBgColor = tooltipBgColor ?? primaryColor,
        tooltipTextColor = tooltipTextColor ?? Colors.black;

  final Color lineColor;
  final Color indicatorLineColor;
  final Color indicatorTouchedLineColor;
  final Color indicatorSpotStrokeColor;
  final Color indicatorTouchedSpotStrokeColor;
  final Color bottomTextColor;
  final Color bottomTouchedTextColor;
  final Color averageLineColor;
  final Color tooltipBgColor;
  final Color tooltipTextColor;

 /* List<double> get yValues => [
        6.0,
        8.0,
        7.9,
        8.0,
        7.4,
        8.0,
        8.0,
        7.7,
        8.0,
        8.0,
        7.9,
        7.9,
        7.1,
        8.0,
        8.0,
        8.0,
        8.0,
        8.0,
        7.0,
        8.0,
        8.0,
        8.0,
        6.0,
        8.0
      ];*/

  @override
  State createState() => _EmployeeTimeChartState();
}

class _EmployeeTimeChartState extends State<EmployeeTimeChart> {
  late double touchedValue;

  bool fitInsideBottomTitle = true;
  bool fitInsideLeftTitle = false;

  @override
  void initState() {
    touchedValue = -1;
    super.initState();
    getTime().then(
          (value) {
        if (value != null) {
          // selectedDay = value.formattedTime;
          selectedDayController.text = value.formattedTime;
        }
      },
    );
  }
TextEditingController selectedDayController=TextEditingController();
// String selectedDay='';
  AccountManagementViewModel accountManagementViewModel =
  Get.find<AccountManagementViewModel>();
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    String text;
    switch (value) {
      case 0:
        text = '';
      case 1:
        text = '1';
      case 2:
        text = '2';
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      case 6:
        text = '6';
        break;
      case 7:
        text = '7';
        break;
      case 8:
        text = '8';
        break;
      case 9.0:
        text = '9';
        break;
   case 10.0:
        text = '';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      fitInside: fitInsideLeftTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta)
          : SideTitleFitInsideData.disable(),
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {

    final isTouched = double.parse(meta.formattedValue).toInt() == touchedValue;
    final style = TextStyle(
      color: isTouched
          ? widget.bottomTouchedTextColor
          : Colors.white.withOpacity(0.6),
      fontWeight: FontWeight.bold,
    );
  if (double.parse(meta.formattedValue)% 1 != 0||double.parse(meta.formattedValue)== 0) {
    return Container(/*height: 10,width: 10,color: Colors.red,*/);
    }
else if(double.parse(meta.formattedValue).toInt()> accountManagementViewModel.allAccountManagement.length)

      return Container(/*color: Colors.green,height: 10,width: 10,*/);

else {
      return SideTitleWidget(
        space: 8,
        axisSide: meta.axisSide,
        fitInside: fitInsideBottomTitle
            ? SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 0)
            : SideTitleFitInsideData.disable(),
        child: Text(
          accountManagementViewModel.allAccountManagement.values
              .elementAt(double.parse(meta.formattedValue).toInt()-1 )
              .fullName
              .toString()
              .split(" ")[0],
          style: style,
        ),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Center(
          child: Text(
            'دوام الموظفين'.tr,
            style: TextStyle(
              color: widget.averageLineColor.withOpacity(1),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        InkWell(
          onTap: () {
            showDatePicker(
              context: context,
              firstDate: DateTime(2010),
              lastDate: DateTime(2100),
            ).then((date) {
              if (date != null) {

                selectedDayController  .text = date
                    .toString()
                    .split(" ")[0];
                setState(() {});
              }
            });
          },
          child: CustomTextField(
            controller: selectedDayController,
            title: 'تاريخ العرض'.tr,
            enable: false,
            keyboardType:
            TextInputType.datetime,
            icon: Icon(
              Icons.date_range_outlined,
              color: primaryColor,
            ),
          ),
        ),
        SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          reverse: true,
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.all(15),
            height: 500,
            width:max(1200,Get.width),
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      final spot = barData.spots[spotIndex];
                      if (spot.x == 0 || spot.x == accountManagementViewModel.allAccountManagement.length+1) {
                        return null;
                      }
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: widget.indicatorTouchedLineColor,
                          strokeWidth: 4,
                        ),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            if (spot.y >= 8.0) {
                              return FlDotCirclePainter(
                                radius: 8,
                                color: Colors.white,
                                strokeWidth: 5,
                                strokeColor:
                                    widget.indicatorTouchedSpotStrokeColor,
                              );
                            } else {
                              return FlDotCirclePainter(
                                // size: 16,
                                color: Colors.redAccent.withOpacity(0.2),
                                strokeWidth: 5,
                                strokeColor:
                                    widget.indicatorTouchedSpotStrokeColor,
                              );
                            }
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => touchedSpot.y < 8.0
                        ? Colors.redAccent.withOpacity(0.2)
                        : widget.tooltipBgColor,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {

                        final flSpot = barSpot;
                        if (flSpot.x == 0 || flSpot.x == accountManagementViewModel.allAccountManagement.length+1) {
                          return null;
                        }
                        return LineTooltipItem(
                          "${accountManagementViewModel.allAccountManagement.values.elementAt(flSpot.x.toInt()-1).fullName} ".toString(),
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            if (flSpot.y >= 8)
                              TextSpan(
                                text: " على الوقت المحدد",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            if (flSpot.y < 8)
                              TextSpan(
                                text: "داوم ${flSpot.y} ساعة",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                          ],
                          textAlign: TextAlign.center,
                        );
                      }).toList();
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? lineTouch) {
                    if (!event.isInterestedForInteractions ||
                        lineTouch == null ||
                        lineTouch.lineBarSpots == null) {
                      setState(() {
                        touchedValue = -1;
                      });
                      return;
                    }
                    final value = lineTouch.lineBarSpots![0].x;

                    if (value == 0 || value == accountManagementViewModel.allAccountManagement.length+1) {
                      setState(() {
                        touchedValue = -1;
                      });
                      return;
                    }

                    setState(() {
                      touchedValue = value;
                    });
                  },
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 8.0,
                      color: widget.averageLineColor,
                      strokeWidth: 3,
                      dashArray: [20, 10],
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    isStepLineChart: true,
                    spots: List.generate(
                      accountManagementViewModel.getUserTimeToday(selectedDayController.text).length,
                          (index) => accountManagementViewModel.getUserTimeToday(selectedDayController.text).asMap().entries.map((e) {
                        return FlSpot(index*1.0, e.value);
                      }).toList()[index],
                    ),

                /*    accountManagementViewModel.getUserTimeToday().asMap().entries.map((e) {
          

                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),*/
                    isCurved: false,
                    barWidth: 4,
                    color: widget.lineColor,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          widget.lineColor.withOpacity(0.5),
                          widget.lineColor.withOpacity(0),
                        ],
                        stops: const [0.15, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      spotsLine: BarAreaSpotsLine(
                        show: true,
                        flLineStyle: FlLine(
                          color: widget.indicatorLineColor,
                          strokeWidth: 2,
                        ),
                        checkToShowSpotLine: (spot) {
                          if (spot.x == 0 || spot.x == accountManagementViewModel.allAccountManagement.length+1) {
                            return false;
                          }

                          return true;
                        },
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        if (spot.y >= 8) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: widget.indicatorSpotStrokeColor,
                          );
                        } else {
                          return FlDotSquarePainter(
                            size: 12,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: widget.indicatorSpotStrokeColor,
                          );
                        }
                      },
                      checkToShowDot: (spot, barData) {
                        return spot.x != 0 &&  spot.x != accountManagementViewModel.allAccountManagement.length+1;
                      },
                    ),
                  ),
                ],
                minY: 0,
                maxY: 10,
                minX: 0,
                maxX: accountManagementViewModel.allAccountManagement.length+1,
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: primaryColor,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  checkToShowHorizontalLine: (value) => value % 0.5 == 0,
                  checkToShowVerticalLine: (value) => value % 0 == 0,
                  getDrawingHorizontalLine: (value) {
                    if (value % 0.15 == 0) {
                      // تغيير القيمة هنا لتكون 0.15 بدلاً من 0.5
                      return const FlLine(
                        color: primaryColor,
                        strokeWidth: 2,
                      );
                    } else {
                      return const FlLine(
                        color: primaryColor,
                        strokeWidth: 0.5,
                      );
                    }
                  },
                  getDrawingVerticalLine: (value) {
                    if (value == 0) {
                      return const FlLine(
                        color: Colors.white,
                        strokeWidth: 10,
                      );
                    } else {
                      return const FlLine(
                        color: primaryColor,
                        strokeWidth: 0.5,
                      );
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 46,
                      getTitlesWidget: leftTitleWidgets,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
