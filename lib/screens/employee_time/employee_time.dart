import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vision_dashboard/models/employee_time_model.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/core/dialogs/Dialogs.dart';
import '../../core/constant/constants.dart';
import '../../controller/home_controller.dart';
import '../../core/Styling/app_colors.dart';
import '../../core/Styling/app_style.dart';
import '../../models/account_management_model.dart';
import '../../core/constant/const.dart';
import '../../core/Utils/minutesToTime.dart';
import '../Settings/Controller/Settings_View_Model.dart';
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
  EmployeeViewModel accountManagementViewModel = Get.find<EmployeeViewModel>();

  String selectedMonth = '';
  String selectedDay = '';
  String dayNameNow = '';

/*  List<bool> _isOpen   = List.generate(
      Get.find<AccountManagementViewModel>().allAccountManagement.length,
  (index) => false);*/
  final selectedDate = TextEditingController();
  final selectedYear = TextEditingController();

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
    dayNameNow = thisTimesModel!.formattedTime;
    selectedDate.text = thisTimesModel!.formattedTime;

    selectedYear.text = thisTimesModel!.year.toString();


  }

  @override
  void dispose() {
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
      body: GetBuilder<EmployeeViewModel>(builder: (controller) {
        return !controller.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                child: GetBuilder<HomeViewModel>(builder: (hController) {
                  double size = max(Get.width - (hController.isDrawerOpen ? 240 : 100), 1000) - 60;
                  return SizedBox(
                    width: size + 60,
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
                                      ///عرض دوام الموظفين
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

                                      ///عرض تسجيل الموظفين
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if (currentEmployee?.type != 'مستخدم') {
                                              isShowLogin = false;
                                              setState(() {});
                                            }
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

                            ///تسجيل الدوام
                            Expanded(
                              child: Container(
                                width: Get.width,
                                alignment: Alignment.center,

                                ///بعد تسجيل دخول الموظف يعرض له اسمه لفترة ومن ثم يختفي
                                child: controller.loginUserPage != null
                                    ? Center(
                                        child: Text(
                                          controller.loginUserPage.toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                        ),
                                      )
                                    : AnimatedCrossFade(
                                        ///تسجيل الدخول ب اسم وكلمة مرور
                                        secondChild: Center(
                                          child: Container(
                                            width: size / 1.3,
                                            height: Get.height * 0.8,
                                            padding: EdgeInsets.all(defaultPadding),
                                            decoration: BoxDecoration(
                                              color: secondaryColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: GetBuilder<EmployeeViewModel>(builder: (controller) {
                                              return ListView(
                                                shrinkWrap: true,
                                                // mainAxisSize: MainAxisSize.min,
                                                // crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  Scrollbar(
                                                    controller: scrollController,
                                                    child: SingleChildScrollView(
                                                        physics: ClampingScrollPhysics(), controller: scrollController, scrollDirection: Axis.horizontal, child: DataTable(columnSpacing: 0, dividerThickness: 0.3, columns: _buildDataColumns(size), rows: _buildDataRows(controller, size))),
                                                  )
                                                ],
                                              );
                                            }),
                                          ),
                                        ),
                                        duration: Durations.short1,
                                        crossFadeState: isCard ? CrossFadeState.showFirst : CrossFadeState.showSecond,

                                        ///تسجيل الدخول بالبطاقة
                                        firstChild: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (true /*controller.isSupportNfc && enableUpdate*/)
                                              Column(
                                                children: [
                                                  Text(
                                                    "تسجيل الدوام".tr,
                                                    style: AppStyles.headLineStyle1,
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Text(
                                                    accountManagementViewModel.isLogIn ? "سجل الدخول باستخدام بطاقتك".tr : "سجل الخروج باستخدام بطاقتك".tr,
                                                    style: TextStyle(fontSize: 22),
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      AppButton(
                                                        text: "تسجيل دخول",
                                                        onPressed: () {
                                                          accountManagementViewModel.isLogIn = true;
                                                          accountManagementViewModel.update();
                                                        },
                                                        color: accountManagementViewModel.isLogIn ? Colors.green : Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      AppButton(
                                                        text: "تسجيل خروج",
                                                        onPressed: () {
                                                          accountManagementViewModel.isLogIn = false;
                                                          accountManagementViewModel.update();
                                                        },
                                                        color: accountManagementViewModel.isLogIn ? Colors.blue : Colors.green,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )

                                            ///اذا لم يكن في وضع الارشفة
                                            else if (enableUpdate)

                                              ///الجهاز لا يدعم البطاقة
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

                            /// عرض دوام الموظفين
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                      Padding(
                                        padding: const EdgeInsets.all(
                                          defaultPadding,
                                        ),
                                        child: CustomDropDown(
                                          value: selectedYear.text.toString(),
                                          listValue:
                                              year,
                                          label: "اختر السنة".tr,
                                          onChange: (value) {
                                            if (value != null) {
                                              selectedYear.text = value.tr;
                                              setState(() {});
                                            }
                                          },
                                          isFullBorder: true,
                                        ),
                                      ),
                                    ],
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

                                                EmployeeModel accountModel = entry.value;
                                                for(var empTime in controller.getAbsentDaysForEmployee(entry.value.id, int.parse(selectedYear.text), int.parse(months[selectedMonth]!)).map((e)=> MapEntry(e, EmployeeTimeModel(dayName: e, startDate:DateTime.now(), endDate: DateTime.now(), totalDate:0, isDayEnd: true, isLateWithReason: null, reasonOfLate: null, isEarlierWithReason: null, reasonOfEarlier: "reasonOfEarlier", isDayOff: true, totalLate: 0, totalEarlier: 0))  ).toList())
                                                  {
                                                    accountModel.employeeTime?[empTime.key]=empTime.value!;

                                                  }

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
                                                                DateFun.minutesToTime(   controller.getTotalLateForUserAtMonth(selectedMonth: selectedMonth, userId: entry.value.id,selectedYear: selectedYear.text)).toString(),
                                                                style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: Get.width / 7,
                                                              child: Text(
                                                                selectedMonth == "الكل".tr
                                                                    ? (accountModel.salary! - accountManagementViewModel.getUserSalariesAllMonth(accountModel.id)).toString()
                                                                    : (accountModel.salary! - accountManagementViewModel.getUserSalariesAtMonth(months[selectedMonth]!, accountModel.id,selectedYear.text)).toString(),
                                                                style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: Get.width / 7,
                                                              child: Text(
                                                                selectedMonth == "الكل".tr ?(accountModel.salary!*controller.monthCount.toSet().length).toString():  (accountModel.salary!).toString(),
                                                                style: TextStyle(fontSize: Get.width < 700 ? 16 : 20),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: Get.width / 7,
                                                              child: Text(
                                                                selectedMonth == "الكل".tr ? ((accountModel.salary!*controller.monthCount.toSet().length)-(accountModel.salary! - accountManagementViewModel.getUserSalariesAllMonth(accountModel.id))).toString() : accountManagementViewModel.getUserSalariesAtMonth(months[selectedMonth]!, accountModel.id,selectedYear.text).toString(),
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
                                                    padding: EdgeInsets.only(bottom: defaultPadding * 3),
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
                                                            for (var j in accountModel.employeeTime!.values.where((element) {
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
                                                                color: WidgetStatePropertyAll((j.isLateWithReason == false || j.endDate == null) ? Colors.red.withOpacity(0.3) : Colors.transparent),
                                                                cells: [
                                                                  dataRowItem(size / data.length, j.dayName.toString()),
                                                                  dataRowItem(size / data.length, j.isDayOff == true ? "غائب".tr : DateFun.dateToMinAndHour(j.startDate??DateTime.now())),
                                                                  dataRowItem(
                                                                      size / data.length,
                                                                      j.isDayOff == true
                                                                          ? "غائب".tr
                                                                          : j.endDate == null
                                                                              ? "لم يسجل خروج".tr
                                                                              : DateFun.dateToMinAndHour(j.endDate!)),
                                                                  dataRowItem(size / data.length, j.isDayOff == true ? "غائب".tr : DateFun.minutesToTime(j.endDate?.difference(j.startDate ?? j.endDate!).inMinutes ?? 0)),
                                                                  dataRowItem(
                                                                      size / data.length,
                                                                      j.isDayOff == true
                                                                          ? "غائب".tr
                                                                          : ((j.startDate?.difference(j.startDate!.copyWith(hour: 7, minute: 30)).inSeconds ?? 0)<0)
                                                                              ? DateFun.minutesToTime(0)
                                                                              : DateFun.minutesToTime((j.startDate?.difference(j.startDate!.copyWith(hour: 7, minute: 30)).inSeconds ?? 0)~/60)),
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
                                                                              style: AppStyles.headLineStyle2.copyWith(color: AppColors.textColor),
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
                }),
              );
      }),
      floatingActionButton: enableUpdate && isShowLogin
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                if (currentEmployee?.type != 'مستخدم')
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
                width: size / 3,
                child: Center(
                    child: Text(
                  empData[index].toString().tr,
                  style: AppStyles.headLineStyle1,
                )))));
  }

  List<DataRow> _buildDataRows(EmployeeViewModel accountController, double size) {
    List<EmployeeModel> employees = accountController.allAccountManagement.values.toList();

    return List.generate(employees.length, (index) {
      return DataRow(cells: [
        dataRowItem(size / 3, employees[index].fullName.toString(), color: Colors.white),
        DataCell(Center(
          child: Container(
            width: size / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (employees[index].employeeTime!.values.where((element) => element.dayName == selectedDate.text && element.endDate != null).isNotEmpty)
                  Text(
                    "تم الانتهاء".tr,
                    style: AppStyles.headLineStyle3.copyWith(color: AppColors.textColor),
                  )
                else if (selectedDate.text == dayNameNow)
                  AppButton(
                      text: employees[index].employeeTime!.values.where((element) => element.dayName == dayNameNow.split(' ')[0]).isNotEmpty ? "الخروج".tr : "الدخول".tr,
                      onPressed: () {
                        if (employees[index].employeeTime!.values.where((element) => element.dayName == dayNameNow.split(' ')[0] && element.endDate != null).isEmpty)
                          getConfirmDialog(
                            context,
                            onConfirm: () {
                              SettingsViewModel settingsController = Get.find<SettingsViewModel>();
                              String lateTime = settingsController.settingsMap[Const.lateTime][Const.time];
                              String appendTime = settingsController.settingsMap[Const.appendTime][Const.time];
                              String outTime = settingsController.settingsMap[Const.outTime][Const.time];
                              String friLateTime = settingsController.settingsMap[Const.friLateTime][Const.time];
                              String friAppendTime = settingsController.settingsMap[Const.friAppendTime][Const.time];
                              String friOutTime = settingsController.settingsMap[Const.friOutTime][Const.time];
                              if (Timestamp.now().toDate().weekday == DateTime.friday) {
                                accountController.addTime(
                                  appendTime: friAppendTime,
                                  lateTime: friLateTime,
                                  outTime: friOutTime,
                                  userName: employees[index].userName,
                                );
                              } else {
                                accountController.addTime(
                                  appendTime: appendTime,
                                  lateTime: lateTime,
                                  outTime: outTime,
                                  userName: employees[index].userName,
                                );
                              }

                              Get.back();
                            },
                          );
                      })
                else
                  Text(
                    "لم يسجل الخروج".tr,
                    style: AppStyles.headLineStyle3.copyWith(color: AppColors.textColor),
                  ),
                if (employees[index].employeeTime!.values.where((element) => element.dayName == selectedDate.text.split(' ')[0]).isEmpty)
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


