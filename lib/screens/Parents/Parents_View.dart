import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Parents/Edite_Add_Parent/parent_user_details.dart';
import 'package:vision_dashboard/screens/Parents/Parent_View/parent_users_screen.dart';

import '../../core/constant/constants.dart';

class ParentsView extends StatelessWidget {
  const ParentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentsViewModel>(builder: (controller) {
      return Scaffold(
        body: AnimatedCrossFade(
          duration: Duration(milliseconds: 500),
          firstChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: ParentUsersScreen(),
          ),
          secondChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: ParentInputForm(),
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
