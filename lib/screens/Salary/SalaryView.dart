import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Salary/controller/Salary_View_Model.dart';

import '../../core/constant/constants.dart';
import '../../controller/home_controller.dart';

import '../Widgets/Custom_Drop_down.dart';
import '../Widgets/Custom_Pluto_Grid.dart';
import '../Widgets/header.dart';

class SalaryView extends StatefulWidget {
  const SalaryView({super.key});

  @override
  State<SalaryView> createState() => _SalaryViewState();
}

class _SalaryViewState extends State<SalaryView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalaryViewModel>(builder: (controller) {
      return Scaffold(
        appBar: Header(context: context, title: 'ادارة رواتب الموظفين'.tr, middleText: 'تستخدم هذه الواجهة لعرض الرواتب المستحقة او المقبوضة لكل موظف حسب شهر معين مع امكانية تسليم رواتب للموظفين'.tr),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: GetBuilder<HomeViewModel>(builder: (hController) {
            double size = max(MediaQuery.sizeOf(context).width - (hController.isDrawerOpen ? 240 : 120), 1000) - 60;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropDown(
                  value: controller.selectedMonth.toString().tr,
                  listValue: months.keys
                      .map(
                        (e) => e.toString().tr,
                      )
                      .toList(),
                  label: "اختر الشهر".tr,
                  onChange: (value) {
                    if (value != null) {
                      controller.setMothValue(value.tr);
                    }
                  },
                  isFullBorder: true,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox(
                      height: Get.height - 180,
                      width: size + 60,
                      child: CustomPlutoGrid(
                        controller: controller,
                        idName: "الرقم التسلسلي",
                        onSelected: (event) {
                          controller.selectedColor = Colors.white.withOpacity(0.5);
                          controller.setCurrentId(event.row?.cells["الرقم التسلسلي"]?.value);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        floatingActionButton: controller.getIfReceive()
            ? FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            controller.getSalaryImage(context: context);
          },
          child: Icon(
            Icons.image_aspect_ratio_rounded,
            color: Colors.white,
          ),
        )
            : FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () {
                  controller.receiveSalary(context: context);
                },
                child: Icon(
                  Icons.payments_outlined,
                  color: Colors.white,
                ),
              ),
      );
    });
  }
}
