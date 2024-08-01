import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/ClassModel.dart';

import '../../../constants.dart';
import '../../Student/Controller/Student_View_Model.dart';
import '../Controller/Class_View_Model.dart';

Widget buildLanguageSpecificStudentList(StudentViewModel studentController, String language, ClassViewModel clasViewModel,ClassModel SelectedClass) {
  var students = studentController.studentMap.values
      .where(
        (element) => element.stdClass == SelectedClass.className && element.stdLanguage == language,
  )
      .toList();

  ///if no have Student in this language
  if (students.isEmpty) {
    return Expanded(
      child: Center(
        child: Text(
          "لايوجد طلاب".tr,
          style: Styles.headLineStyle2.copyWith(color: blueColor),
        ),
      ),
    );
  }

  ///if  have Student in this language
  return Expanded(
    child: ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: students.length,
      itemBuilder: (context, index) {
        var student = students[index];
        return Column(
          children: [
            InkWell(
              onTap: () {
                clasViewModel.showStudentInputDialog(context, student);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    student.studentName!,
                    style: Styles.headLineStyle3.copyWith(color: blueColor),
                  ),
                ),
              ),
            ),
            Divider(
              color: secondaryColor,
              height: 3,
              thickness: 3,
            ),
          ],
        );
      },
    ),
  );
}
