import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

Widget buildStudentListHeader() {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "عربي".tr,
              style: Styles.headLineStyle2.copyWith(color: blueColor),
            ),
          ),
        ),
      ),
      Container(
        height: 75,
        width: 3,
        color: secondaryColor,
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "لغات".tr,
              style: Styles.headLineStyle2.copyWith(color: blueColor),
            ),
          ),
        ),
      ),
    ],
  );
}