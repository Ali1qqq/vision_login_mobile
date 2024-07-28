import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/core/binding.dart';
import 'package:vision_dashboard/screens/login/login_screen.dart';

import '../../../constants.dart';
import '../../../controller/event_view_model.dart';
import '../../../controller/expenses_view_model.dart';
import '../../../utils/const.dart';
import '../../Buses/Controller/Bus_View_Model.dart';
import '../../Exams/controller/Exam_View_Model.dart';
import '../../Parents/Controller/Parents_View_Model.dart';
import '../../Salary/controller/Salary_View_Model.dart';
import '../../Store/Controller/Store_View_Model.dart';
import '../../Student/Controller/Student_View_Model.dart';

class SettingsViewModel extends GetxController {
  AccountManagementViewModel _accountManagementViewModel =
      Get.find<AccountManagementViewModel>();
  EventViewModel _eventViewModel = Get.find<EventViewModel>();
  SalaryViewModel _salaryViewModel = Get.find<SalaryViewModel>();
  ExamViewModel _examViewModel = Get.find<ExamViewModel>();
  StudentViewModel _studentViewModel = Get.find<StudentViewModel>();
  ParentsViewModel _parentsViewModel = Get.find<ParentsViewModel>();
  ExpensesViewModel _expensesViewModel = Get.find<ExpensesViewModel>();
  StoreViewModel _storeViewModel = Get.find<StoreViewModel>();
  WaitManagementViewModel _deleteManagementViewModel = Get.find<WaitManagementViewModel>();
  BusViewModel _busViewModel = Get.find<BusViewModel>();


  final fireStoreInstance = FirebaseFirestore.instance;

  SettingsViewModel() {
    getAllArchive();
  }

  List allArchive = [];


  changeLanguage(String lan)async{

/*    HomeViewModel homeViewModel =Get.find<HomeViewModel>();
    homeViewModel.changeIsLoading();*/

    if(lan=='عربي')
      {
      await  Get.updateLocale(Locale("ar",'ar'));

      }else{
    await  Get.updateLocale(Locale("en",'US'));

    }
    await _busViewModel.getColumns();
    await _examViewModel.getColumns();
    await _studentViewModel.getColumns();
    await _parentsViewModel.getColumns();
    await _expensesViewModel.getColumns();
    await _storeViewModel.getColumns();

    await   Get.offAll(() =>LoginScreen(), binding: GetBinding());
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
    fireStoreInstance
        .collection(archiveCollection)
        .doc(yearName)
        .set({"Year": yearName}, SetOptions(merge: true));
    for (var arr
        in _accountManagementViewModel.allAccountManagement.values.toList()) {
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(accountManagementCollection)
          .doc(arr.id)
          .set(arr.toJson());
      print("Finished allAccountManagement");
    }
    for (var arr in _salaryViewModel.salaryMap.values.toList()) {
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(salaryCollection)
          .doc(arr.salaryId)
          .set(arr.toJson());
      print("Finished SalaryViewModel");
    }
    for (var arr in _eventViewModel.allEvents.values.toList()) {
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(Const.eventCollection)
          .doc(arr.id)
          .set(arr.toJson());
      print("Finished EventViewModel");
    }
    for (var arr in _examViewModel.examMap.values.toList()) {
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(examsCollection)
          .doc(arr.id)
          .set(arr.toJson());
      print("Finished ExamViewModel");
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
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(parentsCollection)
          .doc(arr.id)
          .set(arr.toJson());
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
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(storeCollection)
          .doc(arr.id)
          .set(arr.toJson());
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
      await fireStoreInstance
          .collection(archiveCollection)
          .doc(yearName)
          .collection(busesCollection)
          .doc(arr.busId)
          .set(arr.toJson());
      print("Finished busesCollection");
    }
  }

  void deleteCurrentData() async {
    for (var arr
        in _accountManagementViewModel.allAccountManagement.values.toList()) {
      await fireStoreInstance
          .collection(accountManagementCollection)
          .doc(arr.id)
          .delete();
      print("Finished allAccountManagement");
    }
    for (var arr in _salaryViewModel.salaryMap.values.toList()) {
      await fireStoreInstance
          .collection(salaryCollection)
          .doc(arr.salaryId)
          .delete();
      print("Finished SalaryViewModel");
    }
    for (var arr in _eventViewModel.allEvents.values.toList()) {
      await fireStoreInstance
          .collection(Const.eventCollection)
          .doc(arr.id)
          .delete();
      print("Finished EventViewModel");
    }
    for (var arr in _examViewModel.examMap.values.toList()) {
      await fireStoreInstance.collection(examsCollection).doc(arr.id).delete();
      print("Finished ExamViewModel");
    }
    for (var arr in _studentViewModel.studentMap.values.toList()) {
      await fireStoreInstance
          .collection(studentCollection)
          .doc(arr.studentID)
          .delete();
      print("Finished StudentViewModel");
    }
    for (var arr in _parentsViewModel.parentMap.values.toList()) {
      await fireStoreInstance
          .collection(parentsCollection)
          .doc(arr.id)
          .delete();
      print("Finished ParentsViewModel");
    }
    for (var arr in _expensesViewModel.allExpenses.values.toList()) {
      await fireStoreInstance
          .collection(Const.expensesCollection)
          .doc(arr.id)
          .delete();
      print("Finished ExpensesViewModel");
    }
    for (var arr in _storeViewModel.storeMap.values.toList()) {
      await fireStoreInstance.collection(storeCollection).doc(arr.id).delete();
      print("Finished StoreViewModel");
    }
    for (var arr in _busViewModel.busesMap.values.toList()) {
      await fireStoreInstance.collection(storeCollection).doc(arr.busId).delete();
      print("Finished storeCollection");
    }
  }

  void getOldData(String value) async {
    await _parentsViewModel.getOldParent(value);
    await _accountManagementViewModel.getOldData(value);
    await _eventViewModel.getOldData(value);
    await _salaryViewModel.getOldData(value);
    await _examViewModel.getOldData(value);
    await _studentViewModel.getOldData(value);
    await _expensesViewModel.getOldData(value);
    await _storeViewModel.getOldData(value);
    await _deleteManagementViewModel.getOldData(value);
    await _busViewModel.getOldData(value);
  }

  void getDefaultData() async {
    await _parentsViewModel.getAllParent();
    await _accountManagementViewModel.getAllEmployee();
    await _eventViewModel.getAllEventRecord();
    await _salaryViewModel.getAllSalary();
    await _examViewModel.getAllExam();
    await _studentViewModel.getAllStudent();
    await _expensesViewModel.getAllExpenses();
    await _storeViewModel.getAllStore();
    await _deleteManagementViewModel.getAllDeleteModel();
    await _busViewModel.getAllBuse();
  }
}
