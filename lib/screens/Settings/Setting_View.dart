import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/screens/Settings/Settings_Screen.dart';
import 'package:vision_dashboard/screens/Employee/Edite_Add_Employee/Employee_user_details.dart';

import '../../utils/Hive_DataBase.dart';
import 'Controller/Settings_View_Model.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    if (HiveDataBase.getAccountManagementModel()!.type != 'مالك') {
      Get.find<EmployeeViewModel>().setCurrentId( HiveDataBase.getAccountManagementModel()!.id) ;
      Get.find<EmployeeViewModel>(). initController() ;
    }
    return GetBuilder<SettingsViewModel>(builder: (context) {
      return Scaffold(
        body: AnimatedCrossFade(
          duration: Duration(milliseconds: 500),
          firstChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: SettingsScreen(),
          ),
          secondChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: EmployeeInputForm(),
          ),
          crossFadeState: HiveDataBase.getAccountManagementModel()!.type != 'مالك' ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      );
    });
  }
}
