import 'package:flutter/material.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';

import '../../../../core/constant/constants.dart';

Widget buildEmployeeEditButton( BuildContext context,EmployeeViewModel controller) {
  return FloatingActionButton(
    backgroundColor: primaryColor.withOpacity(0.5),
    onPressed: () {

      controller.initController();
      controller. showEmployeeInputDialog(
        context,
      );
    },
    child: Icon(
      Icons.edit,
      color: Colors.white,
    ),
  );
}


