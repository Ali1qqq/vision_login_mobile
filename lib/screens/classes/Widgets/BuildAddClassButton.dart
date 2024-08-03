import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';

import '../../../constants.dart';
import '../../../models/ClassModel.dart';
import '../Controller/Class_View_Model.dart';

Widget buildAddClassButton(BuildContext context, ClassViewModel classController) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        classController. showClassInputDialog(context, ClassModel(className: '', classId: generateId("Class")));
      },
      child: AnimatedContainer(
        duration: Durations.long1,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "اضافة".tr,
            style: AppStyles.headLineStyle2.copyWith(color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
