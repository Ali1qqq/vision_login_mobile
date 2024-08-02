import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/screens/Employee/View_Employee/Employee_Screen.dart';
import '../../constants.dart';
import 'Edite_Add_Employee/Employee_user_details.dart';

class EmployeeView extends StatelessWidget {
  EmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeViewModel>(builder: (controller) {
      return Scaffold(
        body: AnimatedCrossFade(
          duration: Duration(milliseconds: 500),
          firstChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: AccountManagementScreen(),
          ),
          secondChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: EmployeeInputForm(),
          ),
          crossFadeState: controller.isAdd ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
        floatingActionButton: enableUpdate
            ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () {
                  controller.foldScreen();
                },
                child: Icon(
                  !controller.isAdd ? Icons.add : Icons.grid_view,
                  color: Colors.white,
                ),
              )
            : Container(),
      );
    });
  }
}
