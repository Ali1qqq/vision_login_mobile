import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:get/get.dart';

import '../../controller/NFC_Card_View_model.dart';
import '../../screens/Settings/Controller/Settings_View_Model.dart';
import '../../screens/employee_time/Controller/Employee_view_model.dart';
class GetBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(NfcCardViewModel());

    Get.put(HomeViewModel());
    Get.put(EmployeeViewModel());
    Get.put(SettingsViewModel());
  }

}