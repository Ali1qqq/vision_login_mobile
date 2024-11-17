import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vision_dashboard/models/ClassModel.dart';

import '../../../core/constant/constants.dart';
import '../../Student/Controller/Student_View_Model.dart';
import '../Controller/Class_View_Model.dart';
import 'Build_Language_Specific_StudentList.dart';

Widget buildStudentList(ClassViewModel clasViewModel,ClassModel selectedClass) {
  return GetBuilder<StudentViewModel>(builder: (studentController) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLanguageSpecificStudentList(studentController, 'عربي',clasViewModel,selectedClass),
          VerticalDivider(
            color: secondaryColor,
            width: 3,
            thickness: 3,
          ),
          buildLanguageSpecificStudentList(studentController, 'لغات',clasViewModel,selectedClass),
        ],
      ),
    );
  });
}