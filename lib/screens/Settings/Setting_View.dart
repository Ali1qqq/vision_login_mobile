import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/screens/Settings/Settings_Screen.dart';
import 'package:vision_dashboard/screens/Employee/Edite_Add_Employee/Employee_user_details.dart';

import '../../constants.dart';
import 'Controller/Settings_View_Model.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<SettingsViewModel>(builder: (context) {
      if (currentEmployee?.type != 'مالك') {
        Get.find<EmployeeViewModel>().currentId=currentEmployee!.id;
        WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
          Get.find<EmployeeViewModel>().initController();
          Get.find<EmployeeViewModel>().update();
        },);
      }
      return Scaffold(
        body: AnimatedCrossFade(
          duration: Duration(milliseconds: 500),
          firstChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: SettingsScreen(),
          ),
          secondChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: EmployeeInputForm(viewOnly:true),
          ),
          crossFadeState: currentEmployee!.type != 'مالك' ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      );
    });
  }
}
