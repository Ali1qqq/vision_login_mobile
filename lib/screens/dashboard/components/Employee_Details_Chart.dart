import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../Employee/Controller/Employee_view_model.dart';
import 'InfoBarchart.dart';
import 'info_card.dart';

class EmployeeDetailsChart extends StatefulWidget {
  const EmployeeDetailsChart({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeDetailsChart> createState() => _EmployeeDetailsChartState();
}

class _EmployeeDetailsChartState extends State<EmployeeDetailsChart> {
  int touchedIndex = -1;
  EmployeeViewModel _accountManagementViewModel = Get.find<EmployeeViewModel>();

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
            "الموظفين".tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          InfoBarChart(
            touchedIndex: touchedIndex,
            paiChartSelectionData: paiChartSelectionData(),
            title: "موظف".tr,
            subtitle: _accountManagementViewModel.allAccountManagement.length.toString(),
          ),
          InfoCard(
            onTap: () {
              touchedIndex == 1 ? touchedIndex = -1 : touchedIndex = 1;
              setState(() {});
            },
            title: "اداري".tr,
            amountOfEmployee: _accountManagementViewModel.allAccountManagement.values
                .where(
                  (element) => element.jobTitle == 'مدير' || (element.jobTitle?.startsWith("عامل") ?? false),
                )
                .length
                .toString(),
            color: Colors.redAccent,
          ),
          InfoCard(
            onTap: () {
              touchedIndex == 0 ? touchedIndex = -1 : touchedIndex = 0;
              setState(() {});
            },
            title: "استاذ".tr,
            amountOfEmployee: _accountManagementViewModel.allAccountManagement.values
                .where(
                  (element) => element.jobTitle?.startsWith("مدرس") ?? false,
                )
                .length
                .toString(),
            color: primaryColor,
          ),
          InfoCard(
            onTap: () {
              touchedIndex == 2 ? touchedIndex = -1 : touchedIndex = 2;
              setState(() {});
            },
            title: "سائق".tr,
            amountOfEmployee: _accountManagementViewModel.allAccountManagement.values
                .where(
                  (element) => element.jobTitle == 'سائق',
                )
                .length
                .toString(),
            color: Colors.cyan,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> paiChartSelectionData() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      double radius = isTouched ? 50.0 : 30;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: primaryColor,
            value: _accountManagementViewModel.allAccountManagement.values
                    .where(
                      (element) => element.jobTitle?.startsWith("مدرس") ?? false,
                    )
                    .length *
                1.0,
            title: _accountManagementViewModel.allAccountManagement.isEmpty ? '' : '${((_accountManagementViewModel.allAccountManagement.values.where((element) => element.jobTitle?.startsWith("مدرس") ?? false).length / _accountManagementViewModel.allAccountManagement.length) * 100).round()}%',
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
            color: blueColor,
            value: _accountManagementViewModel.allAccountManagement.values
                    .where(
                      (element) => element.jobTitle == 'مدير' || (element.jobTitle?.startsWith("عامل") ?? false),
                    )
                    .length *
                1.0,
            title: _accountManagementViewModel.allAccountManagement.isEmpty
                ? ''
                : '${((_accountManagementViewModel.allAccountManagement.values.where(
                      (element) => element.jobTitle == 'مدير' || (element.jobTitle?.startsWith("عامل") ?? false),
                    ).length / _accountManagementViewModel.allAccountManagement.length) * 100).round()}%',
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
            color: Colors.cyan,
            value: _accountManagementViewModel.allAccountManagement.values
                    .where(
                      (element) => element.jobTitle == 'سائق',
                    )
                    .length *
                1.0,
            title: _accountManagementViewModel.allAccountManagement.isEmpty
                ? ''
                : '${((_accountManagementViewModel.allAccountManagement.values.where(
                      (element) => element.jobTitle == 'سائق',
                    ).length / _accountManagementViewModel.allAccountManagement.length) * 100).round()}%',
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
