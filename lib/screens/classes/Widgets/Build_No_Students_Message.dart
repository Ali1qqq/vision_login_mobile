import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/Styling/app_style.dart';

Widget buildNoStudentsMessage() {
  return Expanded(
    child: Center(
      child: Text(
        "لايوجد طلاب".tr,
        style: AppStyles.headLineStyle1,
      ),
    ),
  );
}
