import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';

import '../../../../constants.dart';
import 'DeleteOrRestoreButton.dart';
import 'EditButton.dart';

Widget buildFloatingActionButton(BuildContext context,ExpensesViewModel controller) {

  if (!enableUpdate || controller.currentId == '' || (controller.allExpenses[controller.currentId]?.isAccepted==  true) || controller.getIfDelete()) {
    return Container();
  }
  return SizedBox(
    width: Get.width,
    child: Wrap(
      alignment: WrapAlignment.center,
      children: [
        buildDeleteOrRestoreButton(context,controller),
        SizedBox(width: defaultPadding),
        buildExpensesEditButton(context,controller),
      ],
    ),
  );
}