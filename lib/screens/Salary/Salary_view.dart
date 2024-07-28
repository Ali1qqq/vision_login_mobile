import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../constants.dart';
import '../../controller/account_management_view_model.dart';
import '../../controller/home_controller.dart';

import '../Widgets/Custom_Drop_down.dart';
import '../Widgets/header.dart';
import 'SalaryTable.dart';

class SalaryView extends StatefulWidget {
  const SalaryView({super.key});

  @override
  State<SalaryView> createState() => _SalaryViewState();
}

class _SalaryViewState extends State<SalaryView> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed(String paySalary, String id, String date,
      String constSalary, String dilaySalary) async {
    QuickAlert.show(
        width: Get.width / 2,
        context: context,
        type: QuickAlertType.loading,
        title: 'جاري التحميل'.tr,
        text: 'يتم العمل على الطلب'.tr,
        barrierDismissible: false);
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    await Get.find<AccountManagementViewModel>()
        .adReceiveSalary(id, paySalary, date, constSalary, dilaySalary, bytes);

  }

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
    return Scaffold(
      appBar: Header(
          context: context,
          title: 'ادارة رواتب الموظفين'.tr,
          middleText:
              'تستخدم هذه الواجهة لعرض الرواتب المستحقة او المقبوضة لكل موظف حسب شهر معين مع امكانية تسليم رواتب للموظفين'
                  .tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: GetBuilder<HomeViewModel>(builder: (controller) {
          double size = max(
                  MediaQuery.sizeOf(context).width -
                      (controller.isDrawerOpen ? 240 : 120),
                  1000) -
              60;
          return Padding(
            padding: const EdgeInsets.all(8),
            child:
                GetBuilder<AccountManagementViewModel>(builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        controller.update();
                      }
                    },
                    isFullBorder: true,
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  SizedBox(
                    width: size + 60,
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: MediaQuery.sizeOf(context).width < 800
                          ? WrapAlignment.center
                          : WrapAlignment.spaceEvenly,
                      runSpacing: 25,
                      spacing: 0,
                      children: [
                        if (enableUpdate)
                          SalaryTable(
                              size: enableUpdate ? size : size * 2,
                              selectedMonth: selectedMonth,
                              type: TableType.Payable,
                              signatureGlobalKey: signatureGlobalKey,
                              handleSaveButtonPressed: _handleSaveButtonPressed,
                              handleClearButtonPressed:
                                  _handleClearButtonPressed,
                              scrollController: _scrollControllerPayed),
                        SalaryTable(
                            size: enableUpdate ? size : size * 2,
                            selectedMonth: selectedMonth,
                            type: TableType.Received,
                            signatureGlobalKey: signatureGlobalKey,
                            handleSaveButtonPressed: _handleSaveButtonPressed,
                            handleClearButtonPressed: _handleClearButtonPressed,
                            scrollController: _scrollController),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        }),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerPayed = ScrollController();
}
