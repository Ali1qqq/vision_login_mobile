import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/screens/Study%20Fees/Controller/Study_Fees_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/Pluto_View_Model.dart';
import 'package:vision_dashboard/screens/event/Controller/event_view_model.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';
import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Salary/controller/Salary_View_Model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';

import '../controller/NFC_Card_View_model.dart';
import '../screens/Settings/Controller/Settings_View_Model.dart';
import '../screens/Store/Controller/Store_View_Model.dart';
import '../screens/classes/Controller/Class_View_Model.dart';
class GetBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(NfcCardViewModel());

    Get.put(HomeViewModel());
    Get.put(EmployeeViewModel());
    Get.put(ExpensesViewModel());
    Get.put(EventViewModel());
    Get.put(ParentsViewModel());
    Get.put(StudentViewModel());
    Get.put(StoreViewModel());
    Get.put(SalaryViewModel());
    Get.put(BusViewModel());
    Get.put(WaitManagementViewModel());
    Get.put(SettingsViewModel());
    Get.put(ClassViewModel());
    Get.put(StudyFeesViewModel());
    Get.put(PlutoViewModel());
  }

}
