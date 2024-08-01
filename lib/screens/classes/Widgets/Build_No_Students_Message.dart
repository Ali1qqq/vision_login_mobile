import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

Widget buildNoStudentsMessage() {
  return Expanded(
    child: Center(
      child: Text(
        "لايوجد طلاب".tr,
        style: Styles.headLineStyle2.copyWith(color: blueColor),
      ),
    ),
  );
}
