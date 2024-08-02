import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';

import '../../../../controller/Wait_management_view_model.dart';


Widget buildDeleteOrRestoreButton(BuildContext context,ExpensesViewModel controller) {
  return GetBuilder<WaitManagementViewModel>(builder: (_) {
    return FloatingActionButton(
      backgroundColor: controller.getIfDelete() ? Colors.greenAccent.withOpacity(0.5) : Colors.red.withOpacity(0.5),
      onPressed: () => controller.handleDeleteOrRestore(context, _),
      child: Icon(
        controller.getIfDelete() ? Icons.restore_from_trash_outlined : Icons.delete,
        color: Colors.white,
      ),
    );
  });
}