import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';

import '../../../../core/constant/constants.dart';

Widget BuildParentEditButton(BuildContext context) {
  return FloatingActionButton(
    backgroundColor: primaryColor.withOpacity(0.5),
    onPressed: () {
     Get.find<ParentsViewModel>(). showParentInputDialog(
          context);
    },
    child: Icon(
      Icons.edit,
      color: Colors.white,
    ),
  );
}