import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/core/binding/binding.dart';
import 'package:vision_dashboard/screens/login/login_screen.dart';

import '../../../core/constant/constants.dart';
import '../../event/Controller/event_view_model.dart';
import '../../expenses/Controller/expenses_view_model.dart';
import '../../../core/constant/const.dart';
import '../../Buses/Controller/Bus_View_Model.dart';
import '../../Parents/Controller/Parents_View_Model.dart';
import '../../Salary/controller/Salary_View_Model.dart';
import '../../Store/Controller/Store_View_Model.dart';
import '../../Student/Controller/Student_View_Model.dart';

class SettingsViewModel extends GetxController {
  EmployeeViewModel _accountManagementViewModel = Get.find<EmployeeViewModel>();
  EventViewModel _eventViewModel = Get.find<EventViewModel>();
  SalaryViewModel _salaryViewModel = Get.find<SalaryViewModel>();
  StudentViewModel _studentViewModel = Get.find<StudentViewModel>();
  ParentsViewModel _parentsViewModel = Get.find<ParentsViewModel>();
  ExpensesViewModel _expensesViewModel = Get.find<ExpensesViewModel>();
  StoreViewModel _storeViewModel = Get.find<StoreViewModel>();
  WaitManagementViewModel _deleteManagementViewModel = Get.find<WaitManagementViewModel>();
  BusViewModel _busViewModel = Get.find<BusViewModel>();

  Map<String, dynamic> settingsMap = {
    "AppendTime": {"Time": "8 00"},
    "LateTime": {"Time": "7 30"},
    "OutTime": {"Time": "14 00"},
    "FriAppendTime": {"Time": "7 30"},
    "FriLateTime": {"Time": "7 45"},
    "FriOutTime": {"Time": "11 45"},
  };

  TextEditingController lateTimeController = TextEditingController()..text = "0 0";
  TextEditingController appendTimeController = TextEditingController()..text = "0 0";
  TextEditingController outTimeController = TextEditingController()..text = "0 0";
  TextEditingController friLateTimeController = TextEditingController()..text = "0 0";
  TextEditingController friAppendTimeController = TextEditingController()..text = "0 0";
  TextEditingController friOutTimeController = TextEditingController()..text = "0 0";

  final fireStoreInstance = FirebaseFirestore.instance;

  SettingsViewModel() {
    getAllArchive();
    getAllSettings();
  }

  List allArchive = [];

  setTime(String time, String TimeName) async {
    await fireStoreInstance.collection(Const.settingsCollection).doc(TimeName).set({"Time": time});
    update();
  }

  getAllSettings() async {
    await fireStoreInstance.collection(Const.settingsCollection).snapshots().listen(
      (date) {
        settingsMap.clear();
        for (var element in date.docs) {
          settingsMap[element.id] = element.data();
        }
        update();
      },
    );
  }

  changeLanguage(String lan) async {
/*    HomeViewModel homeViewModel =Get.find<HomeViewModel>();
    homeViewModel.changeIsLoading();*/

    if (lan == 'عربي') {
      await Get.updateLocale(Locale("ar", 'ar'));
    } else {
      await Get.updateLocale(Locale("en", 'US'));
    }
    // await _busViewModel.getColumns();
    await _studentViewModel.getColumns();
    await _parentsViewModel.getColumns();
    await _expensesViewModel.getColumns();
    await _storeViewModel.getColumns();

    await Get.offAll(() => LoginScreen(), binding: GetBinding());
/* await   homeViewModel.changeIsLoading();
    // await  Get.offNamed(AppRoutes.EmployeeView);
    update();*/
  }

  getAllArchive() {
    fireStoreInstance.collection(archiveCollection).get().then(
      (event) {
        allArchive.clear();
        for (var value in event.docs) {
          allArchive.add(value.id);
        }
        allArchive.add("الافتراضي");
        update();
      },
    );
  }

  archive(String yearName) async {
    fireStoreInstance.collection(archiveCollection).doc(yearName).set({"Year": yearName}, SetOptions(merge: true));
    for (var arr in _accountManagementViewModel.allAccountManagement.values.toList()) {
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(accountManagementCollection)
          .doc(arr.id)
          .set(arr.toJson());
      print("Finished allAccountManagement");
    }
    for (var arr in _salaryViewModel.salaryMap.values.toList()) {
      await fireStoreInstance.collection(archiveCollection).doc(yearName).collection(salaryCollection).doc(arr.salaryId).set(arr.toJson());
      print("Finished SalaryViewModel");
    }
    for (var arr in _eventViewModel.allEvents.values.toList()) {
      await fireStoreInstance.collection(archiveCollection).doc(yearName).collection(Const.eventCollection).doc(arr.id).set(arr.toJson());
      print("Finished EventViewModel");
    }
    for (var arr in _studentViewModel.studentMap.values.toList()) {
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(studentCollection)
          .doc(arr.studentID)
          .set(arr.toJson());
      print("Finished StudentViewModel");
    }
    for (var arr in _parentsViewModel.parentMap.values.toList()) {
      await fireStoreInstance.collection(archiveCollection).doc(yearName).collection(parentsCollection).doc(arr.id).set(arr.toJson());
      print("Finished ParentsViewModel");
    }
    for (var arr in _expensesViewModel.allExpenses.values.toList()) {
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(Const.expensesCollection)
          .doc(arr.id)
          .set(arr.toJson());
      print("Finished ExpensesViewModel");
    }
    for (var arr in _storeViewModel.storeMap.values.toList()) {
      await fireStoreInstance.collection(archiveCollection).doc(yearName).collection(storeCollection).doc(arr.id).set(arr.toJson());
      print("Finished StoreViewModel");
    }
    for (var arr in _deleteManagementViewModel.allWaiting.values.toList()) {
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(Const.waitManagementCollection)
          .doc(arr.id)
          .set(arr.toJson());
      print("Finished deleteManagementCollection");
    }
    for (var arr in _busViewModel.busesMap.values.toList()) {
      await fireStoreInstance.collection(archiveCollection).doc(yearName).collection(busesCollection).doc(arr.busId).set(arr.toJson());
      print("Finished busesCollection");
    }
  }

  Future<void> deleteAllDocumentsInCollection(String collectionName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection(collectionName);

    try {
      QuerySnapshot querySnapshot = await collection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print("Finished deleting all documents in $collectionName");
    } catch (e) {
      print("Error deleting documents in $collectionName: $e");
    }
  }

  deleteCurrentData() async {
    for (var arr in _accountManagementViewModel.allAccountManagement.values.toList()) {
      await fireStoreInstance.collection(accountManagementCollection).doc(arr.id).set({
        "employeeTime": {},
        "salaryReceived": [],
        "bus": "بدون حافلة",
        "eventRecords": [],
      }, SetOptions(merge: true));
      print("Finished allAccountManagement");
    }
    for (var parent in _parentsViewModel.parentMap.values.toList()) {
      await fireStoreInstance.collection(parentsCollection).doc(parent.id).set({
        'installmentRecords': {},
        "eventRecords": [],
      }, SetOptions(merge: true));
      print("Finished parentsCollection");
    }

    await deleteAllDocumentsInCollection(Const.expensesCollection);
    await deleteAllDocumentsInCollection(Const.eventCollection);
    await deleteAllDocumentsInCollection(salaryCollection);
    // await deleteAllDocumentsInCollection(studentCollection);
    // await deleteAllDocumentsInCollection(parentsCollection);
    await deleteAllDocumentsInCollection(busesCollection);
    await deleteAllDocumentsInCollection(storeCollection);
    await deleteAllDocumentsInCollection(Const.waitManagementCollection);

    print("Finished deleting documents in all collections");

    update();
  }

  void getOldData(String value) async {
    await _parentsViewModel.getOldParent(value);
    await _accountManagementViewModel.getOldData(value);
    await _eventViewModel.getOldData(value);
    await _salaryViewModel.getOldData(value);
    await _studentViewModel.getOldData(value);
    await _expensesViewModel.getOldData(value);
    await _storeViewModel.getOldData(value);
    await _deleteManagementViewModel.getOldData(value);
    await _busViewModel.getOldData(value);
    update();
  }

  void getDefaultData() async {
    await _parentsViewModel.getAllParent();
    await _accountManagementViewModel.getAllEmployee();
    await _eventViewModel.getAllEventRecord();
    await _salaryViewModel.getAllSalary();
    await _studentViewModel.getAllStudent();
    await _expensesViewModel.getAllExpenses();
    await _storeViewModel.getAllStore();
    await _deleteManagementViewModel.getAllDeleteModel();
    await _busViewModel.getAllBuse();
    update();
  }
}