import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';
import '../../Controller/expenses_view_model.dart';
import '../../Input_Edit_Expenses/expenses_input_form.dart';

Widget buildExpensesEditButton(BuildContext context, controller) {
  return FloatingActionButton(
    backgroundColor: primaryColor.withOpacity(0.5),
    onPressed: () {
      Get.find<ExpensesViewModel>().initController(controller.allExpenses[controller.currentId]!);
      showExpensesInputDialog(context);
    },
    child: Icon(Icons.edit, color: Colors.white),
  );
}

void showExpensesInputDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
          ),
          height: Get.height / 1.1,
          width: Get.width / 1.1,
          child: ExpensesInputForm(),
        ),
      );
    },
  );
}
