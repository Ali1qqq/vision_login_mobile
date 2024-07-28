import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controller/account_management_view_model.dart';
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
  AccountManagementViewModel _accountManagementViewModel =
      Get.find<AccountManagementViewModel>();

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
            subtitle: _accountManagementViewModel.allAccountManagement.length
                .toString(),
          ),
          InfoCard(
            onTap: () {
              touchedIndex == 0 ? touchedIndex = -1 : touchedIndex = 0;
              setState(() {});
            },
            title: "اداري".tr,
            amountOfEmployee:
                _accountManagementViewModel.allAccountManagement.values
                    .where(
                      (element) => element.jobTitle == 'مدير/ه',
                    )
                    .length
                    .toString(),
            color: Colors.redAccent,
          ),
          InfoCard(
            onTap: () {
              touchedIndex == 1 ? touchedIndex = -1 : touchedIndex = 1;
              setState(() {});
            },
            title: "استاذ".tr,
            amountOfEmployee:
                _accountManagementViewModel.allAccountManagement.values
                    .where(
                      (element) => element.jobTitle == 'مدرس/ه',
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
            title: "موظف مكتبي".tr,
            amountOfEmployee:
                _accountManagementViewModel.allAccountManagement.values
                    .where(
                      (element) => element.jobTitle == 'موظف/ه اداري/ه',
                    )
                    .length
                    .toString(),
            color: blueColor,
          ),
          InfoCard(
            onTap: () {
              touchedIndex == 3 ? touchedIndex = -1 : touchedIndex = 3;
              setState(() {});
            },
            title: "سائق".tr,
            amountOfEmployee:
                _accountManagementViewModel.allAccountManagement.values
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
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      double radius = isTouched ? 50.0 : 30;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.redAccent,
            value: _accountManagementViewModel.allAccountManagement.values
                    .where(
                      (element) => element.jobTitle == 'مدير/ه',
                    )
                    .length *
                1.0,
            title: _accountManagementViewModel.allAccountManagement.isEmpty
                ? ''
                : '${((_accountManagementViewModel.allAccountManagement.values.where(
                      (element) => element.jobTitle == 'مدير/ه',
                    ).length / _accountManagementViewModel.allAccountManagement.length) * 100).round()}%',
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
            color: primaryColor,
            value: _accountManagementViewModel.allAccountManagement.values
                .where(
                  (element) => element.jobTitle == 'مدرس/ه',
            )
                .length *
                1.0,
            title: _accountManagementViewModel.allAccountManagement.isEmpty
                ? ''
                : '${((_accountManagementViewModel.allAccountManagement.values.where(
                  (element) => element.jobTitle == 'مدرس/ه',
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
            color: blueColor,
            value: _accountManagementViewModel.allAccountManagement.values
                .where(
                  (element) => element.jobTitle == 'موظف/ه اداري/ه',
            )
                .length *
                1.0,
            title: _accountManagementViewModel.allAccountManagement.isEmpty
                ? ''
                : '${((_accountManagementViewModel.allAccountManagement.values.where(
                  (element) => element.jobTitle == 'موظف/ه اداري/ه',
            ).length / _accountManagementViewModel.allAccountManagement.length) * 100).round()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
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
