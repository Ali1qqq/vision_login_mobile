import 'package:flutter/material.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';

import '../../../../controller/Wait_management_view_model.dart';


Widget buildEmployeeDeleteButton(
    WaitManagementViewModel _,

    BuildContext context,
    EmployeeViewModel controller

    ) {
  return FloatingActionButton(
    backgroundColor: controller.getIfDelete()
        ? Colors.greenAccent.withOpacity(0.5)
        : Colors.red.withOpacity(0.5),
    onPressed: () {
      if (controller.getIfDelete()) {
        _.returnDeleteOperation(
          affectedId: controller.allAccountManagement[controller.currentId]?.id ?? '',
        );
      } else {

        controller.showDeleteConfirmationDialog(context);
      }
    },
    child: Icon(
      controller.getIfDelete() ? Icons.restore_from_trash_outlined : Icons.delete,
      color: Colors.white,
    ),
  );
}

