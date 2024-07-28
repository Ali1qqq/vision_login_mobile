import 'dart:math';

import 'package:vision_dashboard/controller/account_management_view_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/utils/Dialogs.dart';
import '../../constants.dart';
import '../../controller/home_controller.dart';
import '../../models/account_management_model.dart';
import '../../utils/Hive_DataBase.dart';
import '../../utils/minutesToTime.dart';
import '../Widgets/Custom_Drop_down.dart';
import '../Widgets/Custom_Text_Filed.dart';
import '../Widgets/Data_Row.dart';

class EmployeeTimeView extends StatefulWidget {
  @override
  State<EmployeeTimeView> createState() => _EmployeeTimeViewState();
}

class _EmployeeTimeViewState extends State<EmployeeTimeView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSecure = true;
  AccountManagementViewModel accountManagementViewModel = Get.find<AccountManagementViewModel>();

  String selectedMonth = '';
  String selectedDay = '';
  String dayNameNow = '';

/*  List<bool> _isOpen   = List.generate(
      Get.find<AccountManagementViewModel>().allAccountManagement.length,
  (index) => false);*/
  final selectedDate = TextEditingController();

  @override
  void initState() {
    super.initState();

    accountManagementViewModel.initNFC(typeNFC.time);
    selectedMonth = months.entries
        .where(
          (element) => element.value == thisTimesModel!.month.toString().padLeft(2, "0"),
        )
        .first
        .key;
    print(" super.initState();");

    getTime().then(
      (value) {
        if (value != null) {
          dayNameNow = value.formattedTime;
          selectedDate.text = value.formattedTime;
        }
      },
    );
  }

  @override
  void dispose() {
    accountManagementViewModel.disposeNFC();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();

  bool isShowLogin = true;
  List<String> data = [
    "اليوم",
    "الدخول",
    "الخروج",
    "المجموع",
    "التأخير",
    "عرض المبرر",
  ];
  List<String> empData = ["الموظف", "الخيارات"];
  bool isCard = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AccountManagementViewModel>(builder: (controller) {
        return !controller.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              child: GetBuilder<HomeViewModel>(builder: (hController) {
                double size = max(
                    MediaQuery.sizeOf(context).width -
                        (hController.isDrawerOpen ? 240 : 120),
                    1000) -
                    60;
                  return SizedBox(
                    width: size+60,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade300,
                            ),
                            width: size * 0.8,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            isShowLogin = true;
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 50,
                                        
                                            decoration: BoxDecoration(
                                                color: isShowLogin ? primaryColor : Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  bottomRight: Radius.circular(15),
                                                )),
                                            child: Center(
                                                child: Text(
                                              "تسجيل دخول الموظف".tr,
                                              style: TextStyle(color: isShowLogin ? Colors.white : Colors.black),
                                            )),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if (HiveDataBase.getUserData().type != 'مستخدم') isShowLogin = false;
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: isShowLogin ? Colors.transparent : primaryColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  bottomLeft: Radius.circular(15),
                                                )),
                                            child: Center(
                                                child: Text(
                                              "عرض تفاصيل دوام الموظفين".tr,
                                              style: TextStyle(color: isShowLogin ? Colors.black : Colors.white),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (isShowLogin)
                            Expanded(
                              child: Container(
                                width: Get.width,
                                child: controller.loginUserPage != null
                                    ? Center(
                                        child: Text(
                                          controller.loginUserPage.toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                        ),
                                      )
                                    : AnimatedCrossFade(
                                        secondChild: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(defaultPadding),
                                            decoration: BoxDecoration(
                                              color: secondaryColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: SizedBox(
                                              width: size / 2,
                                              child: Scrollbar(

                                                controller: scrollController,
                                                child: SingleChildScrollView(
                                                  physics: ClampingScrollPhysics(),

                                                  controller: scrollController,
                                                  scrollDirection: Axis.horizontal,
                                                  child: GetBuilder<AccountManagementViewModel>(builder: (controller) {
                                                    return Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            showDatePicker(
                                                              context: context,
                                                              firstDate: DateTime(2010),
                                                              lastDate: DateTime(2100),
                                                            ).then((date) {
                                                              if (date != null) {
                                                                selectedDate.text = date.toString().split(" ")[0];
                                                                setState(() {});
                                                              }
                                                            });
                                                          },
                                                          child: CustomTextField(
                                                            controller: selectedDate,
                                                            title: 'تاريخ العرض'.tr,
                                                            enable: false,
                                                            keyboardType: TextInputType.datetime,
                                                            icon: Icon(
                                                              Icons.date_range_outlined,
                                                              color: primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                        // CustomDropDown(value: '', listValue: [], label: 'اختر اليوم', onChange: onChange)
                                                        DataTable(columnSpacing: 0, dividerThickness: 0.3, columns: _buildDataColumns(size), rows: _buildDataRows(controller, size)),
                                                      ],
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        duration: Durations.short1,
                                        crossFadeState: isCard ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                        firstChild: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (controller.isSupportNfc && enableUpdate)
                                              Column(
                                                children: [
                                                  Text(
                                                    "تسجيل الدوام".tr,
                                                    style: Styles.headLineStyle1,
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Text(
                                                    "سجل الدخول باستخدام بطاقتك".tr,
                                                    style: TextStyle(fontSize: 22),
                                                  )
                                                ],
                                              )
                                            else if (enableUpdate)
                                              Center(
                                                child: Container(
                                                  width: size / 2,
                                                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                                                  padding: EdgeInsets.all(8),
                                                  child: Center(
                                                    child: Text(
                                                      overflow: TextOverflow.ellipsis,
                                                      "هذا الجهاز لا يحتوي قارئ NFC".tr,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 22),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            else
                                              Container(
                                                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text(
                                                    "لا يمكن تسجيل دوام اثناء عرض السنة المؤشفة".tr,
                                                    style: TextStyle(fontSize: 22),
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                              ),
                            )
                          else
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      defaultPadding,
                                    ),
                                    child: CustomDropDown(
                                      value: selectedMonth.toString().tr,
                                      listValue: ['الكل'.tr] +
                                          months.keys
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
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                                        child: ListView(
                                          shrinkWrap: true,
                                          // padding: EdgeInsets.only(bottom: defaultPadding*3),
                                          physics: ClampingScrollPhysics(),
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                    width: Get.width / 7,
                                                    child: Text(
                                                      "الموظف".tr,
                                                      style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                      textAlign: TextAlign.center,
                                                    )),
                                                Container(
                                                  width: Get.width / 7,
                                                  child: Text(
                                                    "اجمالي التأخير".tr,
                                                    style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width / 7,
                                                  child: Text(
                                                    "اجمالي الخصم".tr,
                                                    style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width / 7,
                                                  child: Text(
                                                    "الراتب المقطوع".tr,
                                                    style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width / 7,
                                                  child: Text(
                                                    "الراتب المستحق".tr,
                                                    style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 5,
                                              color: Colors.white,
                                            ),
                                            ExpansionPanelList(
                                              dividerColor: secondaryColor,
                                              expansionCallback: (int index, bool isExpanded) {
                                                setState(() {
                                                  controller.isOpen[index] = !controller.isOpen[index];
                                                });
                                              },
                                              children: controller.allAccountManagement.values.toList().asMap().entries.map<ExpansionPanel>((entry) {
                                                int indexKey = entry.key;

                                                var accountModel = entry.value;
                                                int totalLate = accountModel.employeeTime.isEmpty ? 0 : accountModel.employeeTime.values.map((e) => e.totalLate ?? 0).toList().reduce((value, element) => value + element);
                                                int totalEarlier = accountModel.employeeTime.isEmpty ? 0 : accountModel.employeeTime.values.map((e) => e.totalEarlier ?? 0).toList().reduce((value, element) => value + element);
                                                int totalTime = totalLate + totalEarlier;

                                                return ExpansionPanel(
                                                  headerBuilder: (BuildContext context, bool isExpanded) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          controller.isOpen[indexKey] = !controller.isOpen[indexKey];
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(16.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Container(
                                                              width: Get.width / 7,
                                                              child: Text(
                                                                accountModel.userName,
                                                                style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: Get.width / 7,
                                                              child: Text(
                                                                DateFun.minutesToTime(totalTime),
                                                                style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: Get.width / 7,
                                                              child: Text(
                                                                selectedMonth == "الكل".tr
                                                                    ? (accountModel.salary! - accountManagementViewModel.getAllUserSalariesAtMonth(accountModel.id)).toString()
                                                                    : (accountModel.salary! - accountManagementViewModel.getUserSalariesAtMonth(months[selectedMonth]!, accountModel.id)).toString(),
                                                                style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: Get.width / 7,
                                                              child: Text(
                                                                (accountModel.salary!).toString(),
                                                                style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: Get.width / 7,
                                                              child: Text(
                                                                selectedMonth == "الكل".tr ? (accountManagementViewModel.getAllUserSalariesAtMonth(accountModel.id)).toString() : accountManagementViewModel.getUserSalariesAtMonth(months[selectedMonth]!, accountModel.id).toString(),
                                                                style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  body: SingleChildScrollView(
                                                    physics: ClampingScrollPhysics(),
                                                    padding: EdgeInsets.only(bottom: defaultPadding*3),

                                                    scrollDirection: Axis.horizontal,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: defaultPadding,
                                                        ),
                                                        CustomDropDown(
                                                          value: selectedDay,
                                                          listValue: ['الكل'.tr] + List.generate(30, (index) => index.toString()).toList(),
                                                          label: "اختر اليوم".tr,
                                                          onChange: (value) {
                                                            if (value != null) {
                                                              selectedDay = value;
                                                              setState(() {});
                                                            }
                                                          },
                                                          isFullBorder: true,
                                                        ),
                                                        SizedBox(height: defaultPadding),
                                                        DataTable(
                                                          columnSpacing: 0,
                                                          columns: List.generate(
                                                            data.length,
                                                            (index) => DataColumn(
                                                              label: Container(
                                                                width: size / data.length,
                                                                child: Center(child: Text(data[index].toString().tr)),
                                                              ),
                                                            ),
                                                          ),
                                                          rows: [
                                                            for (var j in accountModel.employeeTime.values.where((element) {
                                                              if (selectedMonth != 'الكل'.tr) if (selectedDay == '' || selectedDay == 'الكل'.tr)
                                                                return element.dayName.toString().split("-")[1] == months[selectedMonth];
                                                              else
                                                                return element.dayName.toString().split("-")[1] == months[selectedMonth] && element.dayName.toString().split("-")[2] == selectedDay;
                                                              else if (selectedDay == '' || selectedDay == 'الكل'.tr)
                                                                return true;
                                                              else
                                                                return element.dayName.toString().split("-")[2] == selectedDay;
                                                            }))
                                                              DataRow(
                                                                color: WidgetStatePropertyAll((j.isLateWithReason == false || j.endDate == null) ? Colors.red.withOpacity(0.07) : Colors.transparent),
                                                                cells: [
                                                                  dataRowItem(size / data.length, j.dayName.toString()),
                                                                  dataRowItem(size / data.length, j.isDayOff == true ? "غائب".tr : DateFun.dateToMinAndHour(j.startDate!)),
                                                                  dataRowItem(
                                                                      color: j.isDayOff != true
                                                                          ? j.endDate == null
                                                                              ? Colors.teal
                                                                              : primaryColor
                                                                          : primaryColor,
                                                                      size / data.length,
                                                                      j.isDayOff == true
                                                                          ? "غائب".tr
                                                                          : j.endDate == null
                                                                              ? "لم يسجل خروج".tr
                                                                              : DateFun.dateToMinAndHour(j.endDate!)),
                                                                  dataRowItem(size / data.length, j.isDayOff == true ? "غائب".tr : DateFun.minutesToTime(j.totalDate ?? 0)),
                                                                  dataRowItem(
                                                                      size / data.length,
                                                                      j.isDayOff == true
                                                                          ? "غائب".tr
                                                                          : j.totalLate == null || j.totalLate == 0
                                                                              ? ""
                                                                              : DateFun.minutesToTime(j.totalLate!)),
                                                                  dataRowItem(
                                                                      size / data.length,
                                                                      j.isDayOff == true
                                                                          ? "غائب".tr
                                                                          : j.isLateWithReason == null
                                                                              ? ""
                                                                              : (j.isLateWithReason! ? "مع مبرر".tr : "بدون مبرر".tr), onTap: () {
                                                                    if (j.isLateWithReason != false && j.isLateWithReason != null)
                                                                      Get.defaultDialog(
                                                                        title: "المبرر".tr,
                                                                        backgroundColor: Colors.white,
                                                                        content: Center(
                                                                          child: Container(
                                                                            alignment: Alignment.center,
                                                                            width: Get.height / 2,
                                                                            child: Text(
                                                                              j.reasonOfLate.toString(),
                                                                              style: Styles.headLineStyle2.copyWith(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                  }, color: Colors.teal),
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  isExpanded: controller.isOpen[indexKey],
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            );
      }),
      floatingActionButton: enableUpdate && isShowLogin
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                setState(() {
                  isCard = !isCard;
                });
              },
              child: Icon(
                isCard ? Icons.credit_card_off_outlined : Icons.credit_card_outlined,
                color: Colors.white,
              ),
            )
          : Container(),
    );
  }

  List<DataColumn> _buildDataColumns(double size) {
    return List.generate(
        empData.length,
        (index) => DataColumn(
            label: Container(
                width: size / 4,
                child: Center(
                    child: Text(
                  empData[index].toString().tr,
                  style: Styles.headLineStyle1,
                )))));
  }

  List<DataRow> _buildDataRows(AccountManagementViewModel accountController, double size) {
    List<AccountManagementModel> employees = accountController.allAccountManagement.values.toList();

    return List.generate(employees.length, (index) {
      return DataRow(cells: [
        dataRowItem(size / 4, employees[index].fullName.toString(), color: Colors.white),
        DataCell(Center(
          child: Container(
            width: size / 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (employees[index].employeeTime.values.where((element) => element.dayName == selectedDate.text && element.endDate != null).isNotEmpty)
                  Text(
                    "تم الانتهاء".tr,
                    style: Styles.headLineStyle3.copyWith(color: primaryColor),
                  )
                else if (selectedDate.text == dayNameNow)
                  AppButton(
                      text: employees[index].employeeTime.values.where((element) => element.dayName == dayNameNow.split(' ')[0]).isNotEmpty ? "الخروج".tr : "الدخول".tr,
                      onPressed: () {
                        if (employees[index].employeeTime.values.where((element) => element.dayName == dayNameNow.split(' ')[0] && element.endDate != null).isEmpty)
                          getConfirmDialog(
                            context,
                            onConfirm: () {
                              accountController.addTime(
                                userName: employees[index].userName,
                              );
                              Get.back();
                            },
                          );
                      })
                else
                  Text(
                    "لم يسجل الخروج".tr,
                    style: Styles.headLineStyle3.copyWith(color: primaryColor),
                  ),
                if (employees[index].employeeTime.values.where((element) => element.dayName == selectedDate.text.split(' ')[0]).isEmpty)
                  AppButton(
                    text: "غائب",
                    onPressed: () {
                      getConfirmDialog(context, onConfirm: () {
                        accountController.setAppend(employees[index].id, selectedDate.text);
                        Get.back();
                      });
                    },
                    color: Colors.redAccent.withOpacity(0.5),
                  )
              ],
            ),
          ),
        ))
      ]);
    });
  }
}

/*   Accordion(
                                    paddingListTop: 0,
                                    disableScrolling: true,
                                    headerBackgroundColor: secondaryColor,
                                    headerBackgroundColorOpened: Colors.grey,
                                    contentBorderColor: secondaryColor,
                                    contentBackgroundColor: secondaryColor,
                                    paddingListHorizontal: 0,
                                    rightIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                    ),
                                    scaleWhenAnimating: false,
                                    children: [
                                      for (var i
                                          in controller.allAccountManagement.values.where((element) {
                                          return  element.employeeTime.values.where((element) => element.dayName.toString().split("-")[1]==months[selectedMonth],).isNotEmpty;
                                          },))

                                        AccordionSection(
                                          isOpen: true,
                                          header: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Builder(builder: (_) {
                                              int totalLate = i.employeeTime.isEmpty
                                                  ? 0
                                                  : i.employeeTime.values
                                                      .map(
                                                        (e) => e.totalLate ?? 0,
                                                      )
                                                      .toList()
                                                      .reduce((value, element) =>
                                                          value + element);
                                              int totalEarlier = i
                                                      .employeeTime.isEmpty
                                                  ? 0
                                                  : i.employeeTime.values
                                                      .map(
                                                        (e) => e.totalEarlier ?? 0,
                                                      )
                                                      .toList()
                                                      .reduce((value, element) =>
                                                          value + element);
                                              int totalTime =
                                                  totalLate + totalEarlier;
                                              return SizedBox(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Container(
                                                          width: Get.width /7,
                                                        child: Text(
                                                          i.userName,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  Get.width < 700
                                                                      ? 16
                                                                      : 20),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                          width: Get.width /7,
                                                        child: Text(
                                                          DateFun.minutesToTime(
                                                              totalTime),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  Get.width < 700
                                                                      ? 16
                                                                      : 20),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    // Text("اجمالي الخصم : " +((totalTime / 60 ).floor()*0.5).toString()+" ايام",style: TextStyle(fontSize: 20),),
                                                    Container(
                                                          width: Get.width /7,
                                                        child: Text(
                                                          (i.salary!-accountManagementViewModel.getUserSalariesAtMonth(months[selectedMonth]!, i.id)).toString(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  Get.width < 700
                                                                      ? 16
                                                                      : 20),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Container(
                                                          width: Get.width /7,
                                                        child: Text(
                                                          (i.salary!).toString(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  Get.width < 700
                                                                      ? 16
                                                                      : 20),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    //salary
                                                    Container(
                                                          width: Get.width /7,
                                                        child: Text(
                                                          accountManagementViewModel.getUserSalariesAtMonth(months[selectedMonth]!, i.id).toString(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  Get.width < 700
                                                                      ? 16
                                                                      : 20),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                          content: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomDropDown(
                                                  value: selectedDay,
                                                  listValue:['الكل']+List.generate(30, (index) => index.toString(),)
                                                      .toList(),
                                                  label: "اختر اليوم".tr,
                                                  onChange: (value) {
                                                    if (value != null) {
                                                      selectedDay=value;
                                                      // selectedMonth = value.tr;
                                                      setState(() {});
                                                    }
                                                  },
                                                  isFullBorder: true,
                                                ),
                                                SizedBox(
                                                  height: defaultPadding,
                                                ),
                                                DataTable(
                                                    columnSpacing: 0,
                                                    columns: List.generate(
                                                        data.length,
                                                        (index) => DataColumn(
                                                            label: Container(
                                                                width:
                                                                    size / data.length,
                                                                child: Center(
                                                                    child: Text(
                                                                        data[index]
                                                                            .toString()
                                                                            .tr))))),
                                                    rows: [
                                                      for (var j
                                                          in i.employeeTime.values.where((element) {
                                                            if(selectedDay==''||selectedDay=='الكل')
                                                            return element.dayName.toString().split("-")[1]==months[selectedMonth];
                                                            else
                                                              return element.dayName.toString().split("-")[1]==months[selectedMonth]&&element.dayName.toString().split("-")[2]==selectedDay;

                                                      },))
                                                        DataRow(cells: [
                                                          dataRowItem(
                                                              size / data.length,
                                                              j.dayName.toString()),
                                                          dataRowItem(
                                                              size / data.length,
                                                              DateFun.dateToMinAndHour(
                                                                  j.startDate!)),
                                                          dataRowItem(
                                                              size / data.length,
                                                              (j.endDate == null
                                                                  ? ""
                                                                  : DateFun
                                                                      .dateToMinAndHour(
                                                                          j.endDate!))),
                                                          dataRowItem(
                                                              size / data.length,
                                                              DateFun.minutesToTime(
                                                                  j.totalDate ?? 0)),
                                                          // dataRowItem(size / data.length, (j.isLateWithReason == null ? "" : (j.isLateWithReason! ? "مع مبرر".tr : "بدون مبرر".tr))),
                                                          dataRowItem(
                                                              size / data.length,
                                                              j.totalLate == null ||
                                                                      j.totalLate == 0
                                                                  ? ""
                                                                  : DateFun
                                                                      .minutesToTime(j
                                                                          .totalLate!)),
                                                          dataRowItem(
                                                              size / data.length,
                                                              (j.isLateWithReason ==
                                                                      null
                                                                  ? ""
                                                                  : (j.isLateWithReason!
                                                                      ? "مع مبرر".tr
                                                                      : "بدون مبرر"
                                                                          .tr)),
                                                              onTap: () {
                                                            if (j.isLateWithReason !=
                                                                    false &&
                                                                j.isLateWithReason !=
                                                                    null)
                                                              Get.defaultDialog(
                                                                  title: "المبرر".tr,
                                                                  backgroundColor:
                                                                      Colors.white,
                                                                  content: Center(
                                                                    child: Container(
                                                                      // height: Get.height / 2,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width:
                                                                          Get.height /
                                                                              2,
                                                                      child: Text(
                                                                        j.reasonOfLate
                                                                            .toString(),
                                                                        style: Styles
                                                                            .headLineStyle2
                                                                            .copyWith(
                                                                                color: Colors
                                                                                    .white),
                                                                      ),
                                                                    ),
                                                                  ));
                                                          }, color: Colors.teal),
                                                          // dataRowItem(size / data.length, (j.isEarlierWithReason == null ? "" : (j.isEarlierWithReason! ? "مع مبرر".tr : "بدون مبرر".tr))),
                                                          dataRowItem(
                                                              size / data.length,
                                                              j.totalEarlier == null ||
                                                                      j.totalEarlier ==
                                                                          0
                                                                  ? ""
                                                                  : DateFun.minutesToTime(
                                                                      j.totalEarlier!)),
                                                          */ /*dataRowItem(size / data.length, (j.isEarlierWithReason == null ? "" : (j.isEarlierWithReason! ? "مع مبرر".tr : "بدون مبرر".tr)), onTap: () {
                                                        if(j.isEarlierWithReason != false&&j.isEarlierWithReason != null)
                                                          print(j.reasonOfEarlier);
                                                        Get.defaultDialog(
                                                            title: "المبرر".tr,
                                                            backgroundColor: secondaryColor,
                                                            content: Center(
                                                              child: Container(
                                                      alignment: Alignment.center,
                                                                width: Get.height / 2,
                                                                child: Text(j.reasonOfEarlier.toString(),style: Styles.headLineStyle2.copyWith(color: Colors.white),),
                                                              ),
                                                            ));
                                                      }, color: Colors.teal),*/ /*
                                                        ]),
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),*/
