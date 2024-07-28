import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/dashboard/components/Employee_Salary_BarChar.dart';

import '../../../constants.dart';
import '../../Widgets/Custom_Drop_down.dart';

class EmployeeSalaryChartBox extends StatefulWidget {
  EmployeeSalaryChartBox({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeSalaryChartBox> createState() => _EmployeeSalaryChartBoxState();
}

class _EmployeeSalaryChartBoxState extends State<EmployeeSalaryChartBox> {
  String selectedMonth = '';

  @override
  void initState() {
    super.initState();

    selectedMonth = months.entries
        .where(
          (element) =>
              element.value == thisTimesModel!.month.toString().padLeft(2, "0"),
        )
        .first
        .key;
  }

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
          CustomDropDown(
            value: selectedMonth.toString().tr,
            listValue: months.keys
                .map(
                  (e) => e.toString().tr,
                )
                .toList(),
            label: "اختر الشهر".tr,
            onChange: (value) {
              if (value != null) {
                selectedMonth = value.tr;
                setState(() {});
              }
            },
            isFullBorder: true,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          SizedBox(
              height: 400,
              width: double.infinity,
              child: EmployeeSalaryBarChart(
                  selectedMonth: months[selectedMonth]!)),
          Row(
            children: [
              const Spacer(),
              Row(
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
                    "المستحق".tr,
                    // style: Styles.headLineStyle3,
                  )
                ],
              ),
              const Spacer(),
              Row(
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
                    "المدفوع".tr,
                    // style: Styles.headLineStyle3,
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
