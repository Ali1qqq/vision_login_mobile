import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../core/Styling/app_style.dart';

Widget buildNoClassSelectedMessage() {
  return Padding(
    padding: EdgeInsets.all(20),
    child: Center(
      child: Text(
        "يرجى إختيار احد الصفوف لمشاهدة تفاصيله".tr,
        style: AppStyles.headLineStyle2.copyWith(color: blueColor),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
