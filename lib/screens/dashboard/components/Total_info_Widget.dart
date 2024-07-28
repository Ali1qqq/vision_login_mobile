

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/dashboard/components/Total_Chart.dart';

import '../../../constants.dart';

class TotalBarChartWidget extends StatefulWidget {
  TotalBarChartWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<TotalBarChartWidget> createState() => _TotalBarChartWidgetState();
  int index = 2;
}

class _TotalBarChartWidgetState extends State<TotalBarChartWidget> {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: defaultPadding,
          ),
          SizedBox(
              height: 400,
              // width:max(1200,Get.width),
              child: TotalBarChart(
                index: widget.index,
              )),
          SizedBox(
            width: Get.width,
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 10,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.index = 2;
                    setState(() {});
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black.withOpacity(0.2)),
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "الاجمالي".tr,
                        // style: Styles.headLineStyle3,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.index = 1;
                    setState(() {});
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black.withOpacity(0.2)),
                            color: Colors.cyan,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "الايرادات".tr,
                        // style: Styles.headLineStyle3,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.index = 0;
                    setState(() {});
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black.withOpacity(0.2)),
                            color: Colors.black.withBlue(100),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "المصروف".tr,
                        // style: Styles.headLineStyle3,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
