import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:vision_dashboard/core/constant/constants.dart';
import 'package:vision_dashboard/models/Salary_Model.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'dart:ui' as ui;

import '../../../controller/Wait_management_view_model.dart';
import '../../../models/account_management_model.dart';
import '../../../core/Utils/To_AR.dart';
import '../SignViewDialog.dart';

class SalaryViewModel extends GetxController {
  final salaryCollectionRef = FirebaseFirestore.instance.collection(salaryCollection);

  ///pluto header
  List<PlutoColumn> columns = [];

  /// pluto data
  List<PlutoRow> rows = [];

  /// Refresh pluto header when change language
  getColumns() {
    columns.clear();
    columns.addAll(toAR(data));
  }

  bool getIfReceive() {
    bool isPaid = false;
    salaryMap.entries
        .where(
      (element) => element.key.split(" ")[0].split("-")[1] == months[selectedMonth],
    )
        .forEach(
      (element) {
        if (element.value.employeeId == currentId) isPaid = true;
      },
    );
    return isPaid;
  }

  String? getSalarySign() {
    String? image ;
    salaryMap.entries
        .where(
          (element) => element.key.split(" ")[0].split("-")[1] == months[selectedMonth],
    )
        .forEach(
          (element) {
        if (element.value.employeeId == currentId) image = element.value.signImage;
      },
    );
    return image;
  }
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  void handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }
  void handleSaveButtonPressed(
     String paySalary,
     String id,
     String date,
     String constSalary,
     String dilaySalary,
     BuildContext context,
      String nots,
  ) async {
    QuickAlert.show(width: Get.width / 2, context: context, type: QuickAlertType.loading, title: 'جاري التحميل'.tr, text: 'يتم العمل على الطلب'.tr, barrierDismissible: false);
    final data = await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    await employeeController.adReceiveSalary(id, paySalary, date, constSalary, dilaySalary, bytes,nots);
  }
receiveSalary({required BuildContext context}){
 EmployeeModel  accountModel=employeeController.allAccountManagement[currentId]!;
  showDialog(
    context: context,
    builder: (context) => buildSignViewDialog(
        (employeeController.getUserSalariesAtMonth(months[selectedMonth]!, accountModel.id)).toString(),
        accountModel,
        "${thisTimesModel!.year}-${months[selectedMonth]}",signatureGlobalKey,context),
  );
}

getSalaryImage({required BuildContext context}){
  EmployeeModel  accountModel=employeeController.allAccountManagement[currentId]!;
  String?  image;
  print(salaryMap.values.where((element) => element.employeeId==accountModel.id&&element.salaryId!.split(" ")[0]=="${thisTimesModel!.year}-${months[selectedMonth]}",));
  image=salaryMap.values.where((element) => element.employeeId==accountModel.id&&element.salaryId!.split(" ")[0]=="${thisTimesModel!.year}-${months[selectedMonth]}",).lastOrNull?.signImage;


if(image!=null) {

      showDialog(context: context, builder: (context) => buildSignImageView(image!));
    }
  }
  SalaryViewModel() {
    getColumns();
    getAllSalary();

    getEmployeeSalaryPluto();
  }

  String selectedMonth = months.entries
      .where(
        (element) => element.value == thisTimesModel!.month.toString().padLeft(2, "0"),
      )
      .first
      .key;

  Map<String, SalaryModel> _salaryMap = {};

  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "الاسم الكامل": PlutoColumnType.text(),
    "الراتب المستحق": PlutoColumnType.text(),
    "الراتب الكلي": PlutoColumnType.text(),
    "الراتب المستلم": PlutoColumnType.text(),
    "الحالة": PlutoColumnType.text(),
  };

  Map<String, SalaryModel> get salaryMap => _salaryMap;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;

  getAllSalary() async {
    listener = await salaryCollectionRef.snapshots().listen((value) {
      _salaryMap.clear();
      for (var element in value.docs) {
        _salaryMap[element.id] = SalaryModel.fromJson(element.data());
      }
      print("salaries :${_salaryMap.keys.length}");
      getEmployeeSalaryPluto();
      update();
    });
  }

  GlobalKey plutoKey = GlobalKey();
  String currentId = '';

  void setCurrentId(value) {
    currentId = value;
    update();
  }

  EmployeeViewModel employeeController = Get.find<EmployeeViewModel>();
  Color selectedColor=secondaryColor;

  getEmployeeSalaryPluto() async {
    rows.clear();
    plutoKey = GlobalKey();
    selectedColor=secondaryColor;
    employeeController.allAccountManagement.forEach(
      (key, value) {
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: key),
              data.keys.elementAt(1): PlutoCell(value: value.fullName),
              data.keys.elementAt(2): PlutoCell(value: employeeController.getUserSalariesAtMonth(months[selectedMonth].toString(), key)),
              data.keys.elementAt(3): PlutoCell(value: value.salary.toString()),
              data.keys.elementAt(4): PlutoCell(value: getPaidSalaryAtMonth(empId: key, month: months[selectedMonth].toString())),
              data.keys.elementAt(5): PlutoCell(value: cheekIfEmpHaveSalaryAtMonth(empId: key, month: months[selectedMonth].toString()) ? "تم التسليم".tr : "لم يتم التسليم".tr),
            },
          ),
        );
      },
    );
    update();
  }

  bool cheekIfEmpHaveSalaryAtMonth({required String empId, required String month}) {
    bool isPaid = false;
    salaryMap.entries
        .where(
      (element) => element.key.split(" ")[0].split("-")[1] == month,
    )
        .forEach(
      (element) {
        if (element.value.employeeId == empId) isPaid = true;
      },
    );
    return isPaid;
  }

  addSalary(SalaryModel salaryModel) {
    salaryCollectionRef.doc(salaryModel.salaryId).set(salaryModel.toJson());
    update();
  }

  updateSalary(SalaryModel salaryModel) async {
    await salaryCollectionRef.doc(salaryModel.salaryId).set(salaryModel.toJson(), SetOptions(merge: true));
    update();
  }

  deleteSalary(String salaryId) async {
    await addWaitOperation(type: waitingListTypes.delete,

        userName: currentEmployee?.userName.toString()??"",
        collectionName: salaryCollection, affectedId: salaryId

    );
    update();
  }

  getOldData(String value) async {
    await FirebaseFirestore.instance.collection(archiveCollection).doc(value).collection(salaryCollection).get().then((value) {
      _salaryMap.clear();
      for (var element in value.docs) {
        _salaryMap[element.id] = SalaryModel.fromJson(element.data());
      }
      print("salaries :${_salaryMap.keys.length}");
      listener.cancel();
      update();
    });
  }

  int getAllSalaryPay() {
    int total = 0;
    _salaryMap.forEach(
      (key, value) {
        total += double.parse(value.paySalary!).toInt();
      },
    );
    update();
    return total;
  }

  String getPaidSalaryAtMonth({required String empId, required String month}) {
    String totalPay = "0";
    salaryMap.entries
        .where(
      (element) => element.key.split(" ")[0].split("-")[1] == month,
    )
        .forEach(
      (element) {
        if (element.value.employeeId == empId) totalPay = element.value.paySalary.toString();
      },
    );

    return totalPay;
  }

  setMothValue(String value) {
    selectedMonth = value;
    getEmployeeSalaryPluto();
    update();
  }
}
