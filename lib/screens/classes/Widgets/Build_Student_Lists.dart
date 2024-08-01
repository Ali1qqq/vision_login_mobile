import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/ClassModel.dart';
import 'package:vision_dashboard/screens/classes/Controller/Class_View_Model.dart';

import '../../../constants.dart';
import '../../Student/Controller/Student_View_Model.dart';
import 'Build_No_Students_Message.dart';
import 'Build_Student_List.dart';
import 'Build_Student_List_Header.dart';

Widget buildStudentLists(ClassViewModel clasViewModel,ClassModel SelectedClass ) {
  return Column(
    children: [
      ///language of each student header
      buildStudentListHeader(),
      Divider(
        color: secondaryColor,
        height: 5,
        thickness: 3,
      ),
      Get.find<StudentViewModel>()
          .studentMap
          .values
          .where(
            (element) => element.stdClass == SelectedClass.className && (element.stdLanguage == 'لغات' || element.stdLanguage == 'عربي'),
      )
          .isEmpty

      ///if no have Student in all language
          ? buildNoStudentsMessage()
          : buildStudentList(clasViewModel,SelectedClass),
    ],
  );
}