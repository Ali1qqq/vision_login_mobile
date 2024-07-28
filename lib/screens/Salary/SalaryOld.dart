/*
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:vision_dashboard/models/Salary_Model.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';

import '../../constants.dart';
import '../../controller/account_management_view_model.dart';
import '../../controller/Wait_management_view_model.dart';
import '../../controller/home_controller.dart';
import '../../models/account_management_model.dart';
import '../Widgets/AppButton.dart';
import '../Widgets/header.dart';
import 'controller/Salary_View_Model.dart';

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
    final data =
    await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    await Get.find<AccountManagementViewModel>()
        .adReceiveSalary(id, paySalary, date, constSalary, dilaySalary, bytes);
    Get.back();
  }

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerPayed = ScrollController();

  String selectedMonth = '';
  List data = ["الاسم الكامل", "الراتب المستحق", "الراتب الكلي", "العمليات"];
  List dataReceived = [
    "الاسم الكامل",
    "الراتب المستحق",
    "الراتب الكلي",
    "الراتب المستلم"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedMonth = months.entries
        .where(
          (element) =>
      element.value == DateTime.now().month.toString().padLeft(2, "0"),
    )
        .first
        .key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: 'ادارة رواتب الموظفين',
      ),
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
              List<MapEntry<String, AccountManagementModel>> employee =
              controller.allAccountManagement.entries.where(
                    (element) {
                  return element.value.employeeTime.keys
                      .toString()
                      .split("-")[1] ==
                      months[selectedMonth];
                },
              ).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropDown(
                    value: selectedMonth.toString(),
                    listValue: months.keys
                        .map(
                          (e) => e.toString(),
                    )
                        .toList(),
                    label: "اختر الشهر",
                    onChange: (value) {
                      if (value != null) {
                        selectedMonth = value;
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
                        Container(
                          padding: EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: SizedBox(
                            width: size / 2.5 + 30,
                            child: Scrollbar(
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: GetBuilder<DeleteManagementViewModel>(
                                    builder: (_) {
                                      print(
                                          '${DateTime.now().year}-${months[selectedMonth]}');
                                      return GetBuilder<SalaryViewModel>(
                                          builder: (salaryController) {
                                            return DataTable(
                                                columnSpacing: 0,
                                                columns: List.generate(
                                                    dataReceived.length,
                                                        (index) => DataColumn(
                                                        label: Container(
                                                            width: size /
                                                                2.5 /
                                                                dataReceived.length,
                                                            child: Center(
                                                                child: Text(
                                                                    dataReceived[
                                                                    index]))))),
                                                rows: [
                                                  ...List.generate(
                                                      salaryController.salaryMap.values
                                                          .where((element) =>
                                                      element.salaryId
                                                          .toString()
                                                          .split(" ")[0] ==
                                                          '${DateTime.now().year}-${months[selectedMonth]}')
                                                          .length, (index) {
                                                    SalaryModel salaryEmp = salaryController
                                                        .salaryMap.values
                                                        .where((element) =>
                                                    element.salaryId
                                                        .toString()
                                                        .split(" ")[0] ==
                                                        '${DateTime.now().year}-${months[selectedMonth]}')
                                                        .toList()[index];
                                                    return DataRow(cells: [
                                                      dataRowItem(
                                                          size / 2.5 / data.length,
                                                          controller
                                                              .allAccountManagement[
                                                          salaryEmp.employeeId
                                                              .toString()]!
                                                              .fullName
                                                              .toString()),
                                                      dataRowItem(
                                                          size / 2.5 / data.length,
                                                          salaryEmp.dilaySalary),
                                                      dataRowItem(
                                                          size / 2.5 / data.length,
                                                          salaryEmp.constSalary),
                                                      dataRowItem(
                                                        size / 2.5 / data.length,
                                                        salaryEmp.paySalary,
                                                      ),
                                                    ]);
                                                  })
                                                ]);
                                          });
                                    }),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: SizedBox(
                            width: size / 2.5 + 30,
                            child: Scrollbar(
                              controller: _scrollControllerPayed,
                              child: SingleChildScrollView(
                                controller: _scrollControllerPayed,
                                scrollDirection: Axis.horizontal,
                                child: GetBuilder<DeleteManagementViewModel>(
                                    builder: (_) {
                                      return DataTable(
                                          columnSpacing: 0,
                                          columns: List.generate(
                                              data.length,
                                                  (index) => DataColumn(
                                                  label: Container(
                                                      width:
                                                      size / 2.5 / data.length,
                                                      child: Center(
                                                          child:
                                                          Text(data[index]))))),
                                          rows: [
                                            ...List.generate(
                                                employee
                                                    .where((element) =>
                                                element.value.employeeTime
                                                    .values
                                                    .where(
                                                      (element) {
                                                    return element.dayName!
                                                        .split(
                                                        "-")[1] ==
                                                        months[
                                                        selectedMonth];
                                                  },
                                                ).isNotEmpty &&
                                                    element
                                                        .value.salaryReceived!
                                                        .where(
                                                          (element) {
                                                        return element
                                                            .toString()
                                                            .split(
                                                            " ")[0] ==
                                                            '${DateTime.now().year}-${months[selectedMonth]}';
                                                      },
                                                    ).isEmpty)
                                                    .length, (index) {
                                              AccountManagementModel accountModel =
                                                  employee
                                                      .where((element) =>
                                                  element.value.employeeTime
                                                      .values
                                                      .where(
                                                        (element) {
                                                      return element
                                                          .dayName!
                                                          .split(
                                                          "-")[1] ==
                                                          months[
                                                          selectedMonth];
                                                    },
                                                  ).isNotEmpty &&
                                                      element
                                                          .value.salaryReceived!
                                                          .where(
                                                            (element) {
                                                          return element
                                                              .toString()
                                                              .split(
                                                              " ")[0] ==
                                                              '${DateTime.now().year}-${months[selectedMonth]}';
                                                        },
                                                      ).isEmpty)
                                                      .toList()[index]
                                                      .value;
                                              int totalLate = accountModel
                                                  .employeeTime.isEmpty
                                                  ? 0
                                                  : accountModel.employeeTime.values
                                                  .map(
                                                    (e) => e.totalLate ?? 0,
                                              )
                                                  .toList()
                                                  .reduce((value, element) =>
                                              value + element);
                                              int totalEarlier = accountModel
                                                  .employeeTime.isEmpty
                                                  ? 0
                                                  : accountModel.employeeTime.values
                                                  .map(
                                                    (e) => e.totalEarlier ?? 0,
                                              )
                                                  .toList()
                                                  .reduce((value, element) =>
                                              value + element);
                                              int totalTime =
                                                  totalLate + totalEarlier;
                                              return DataRow(cells: [
                                                dataRowItem(
                                                    size / 2.5 / data.length,
                                                    accountModel.fullName
                                                        .toString()),
                                                dataRowItem(
                                                  size / 2.5 / data.length,
                                                  ((accountModel.salary!) -
                                                      ((accountModel.salary! /
                                                          accountModel
                                                              .dayOfWork!) *
                                                          ((totalTime / 60)
                                                              .floor() *
                                                              0.5)))
                                                      .toString(),
                                                ),
                                                dataRowItem(
                                                    size / 2.5 / data.length,
                                                    accountModel.salary.toString()),
                                                dataRowItem(
                                                    size / 2.5 / data.length,
                                                    "تسليم الراتب",
                                                    color: Colors.green, onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => buildSignViewDialog(
                                                        ((accountModel.salary!) -
                                                            ((accountModel
                                                                .salary! /
                                                                accountModel
                                                                    .dayOfWork!) *
                                                                ((totalTime /
                                                                    60)
                                                                    .floor() *
                                                                    0.5)))
                                                            .toString(),
                                                        accountModel,
                                                        "${DateTime.now().year}-${months[selectedMonth]}"),
                                                  );
                                                }),
                                              ]);
                                            })
                                          ]);
                                    }),
                              ),
                            ),
                          ),
                        ),
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

  AlertDialog buildSignViewDialog(text, account, date) {
    TextEditingController salaryReceived = TextEditingController();
    TextEditingController salaryMonth = TextEditingController();
    return AlertDialog(
      backgroundColor: secondaryColor,
      actions: [
        Container(
          height: Get.height / 2,
          width: Get.width / 2,
          color: secondaryColor,
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Text(
                "يرجى التوقيع من قبل الموظف",
                style: Styles.headLineStyle1,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              CustomTextField(
                controller: salaryMonth..text = text.toString(),
                title: "الراتب المستحق",
                enable: false,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              CustomTextField(
                  controller: salaryReceived..text = text.toString(),
                  title: "الراتب الممنوح"),
              SizedBox(
                height: defaultPadding,
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                      child: SfSignaturePad(
                          key: signatureGlobalKey,
                          backgroundColor: Colors.white,
                          strokeColor: Colors.black,
                          minimumStrokeWidth: 1.0,
                          maximumStrokeWidth: 4.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey)))),
              SizedBox(height: 10),
              Row(children: <Widget>[
                AppButton(
                    text: "حفظ",
                    onPressed: () {
                      _handleSaveButtonPressed(salaryReceived.text, account.id,
                          date, account.salary.toString(), text);
                    }),
                AppButton(text: "اعادة", onPressed: _handleClearButtonPressed),
              ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
            ],
          ),
        )
      ],
    );
  }

  dataRowItem(size, text, {onTap, color}) {
    return DataCell(
      Container(
        width: size,
        child: InkWell(
            onTap: onTap,
            child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: color == null ? null : TextStyle(color: color),
                ))),
      ),
    );
  }
}*/
