import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../controller/Wait_management_view_model.dart';
import '../../Controller/Parents_View_Model.dart';

Widget BuildParentDeleteOrRestoreButton(WaitManagementViewModel _,ParentsViewModel controller,BuildContext context) {
  return FloatingActionButton(
    backgroundColor: controller.getIfDelete()
        ? Colors.greenAccent.withOpacity(0.5)
        : Colors.red.withOpacity(0.5),
    onPressed: () async {
      if (enableUpdate) {
        if (controller.getIfDelete()) {
          _.returnDeleteOperation(
              affectedId: controller.parentMap[controller.currentId]!.id.toString());
        } else {
          await controller.showDeleteConfirmationDialog(_,context);
        }
      }
    },
    child: Icon(
      controller. getIfDelete()
          ? Icons.restore_from_trash_outlined
          : Icons.delete,
      color: Colors.white,
    ),
  );
}