import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/models/Exam_model.dart';
import 'package:vision_dashboard/models/Student_Model.dart';

import '../../../controller/Wait_management_view_model.dart';
import '../../../utils/To_AR.dart';

class ExamViewModel extends GetxController {
  final examCollectionRef =
      FirebaseFirestore.instance.collection(examsCollection);
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "المقرر": PlutoColumnType.text(),
    "الأستاذ": PlutoColumnType.text(),
    "التاريخ": PlutoColumnType.date(),
    "الطلاب": PlutoColumnType.text(),
    "علامة النجاح": PlutoColumnType.text(),
    "العلامة الكاملة": PlutoColumnType.text(),
    "نسبة النجاح": PlutoColumnType.text(),
    "موافقة المدير": PlutoColumnType.text(),
  };
  GlobalKey key=GlobalKey();
  ExamViewModel() {
    getColumns();
    getAllExam();
  }
  getColumns(){
    columns.clear();
    columns.addAll(toAR(data));
  }
  Map<String, ExamModel> _examMap = {};

  Map<String, ExamModel> get examMap => _examMap;
  bool addMarks = false;

  changeExamScreen() {
    addMarks = !addMarks;
    update();
  }

  addMarkExam(Map marks, String examId) async {
    await examCollectionRef
        .doc(examId)
        .set({"marks": marks,"isDone":true}, SetOptions(merge: true));
    update();
  }
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;

  getAllExam() async {
    listener=   await examCollectionRef.snapshots().listen((value) async{
      _examMap.clear();
      key=GlobalKey();
      rows.clear();
      for (var element in value.docs) {
        _examMap[element.id] = ExamModel.fromJson(element.data());
      }
      print("Exams :${_examMap.keys.length}");
      await getPassRate();

      _examMap.forEach((key, value) {
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: key),
              data.keys.elementAt(1): PlutoCell(value:value.subject.toString()),
              data.keys.elementAt(2): PlutoCell(value:value.professor.toString()),
              data.keys.elementAt(3): PlutoCell(value:value.date),
              data.keys.elementAt(4): PlutoCell(value:value.marks?.length.toString()),
              data.keys.elementAt(5): PlutoCell(value:value.examPassMark.toString()),
              data.keys.elementAt(6): PlutoCell(value:value.examMaxMark.toString()),
              data.keys.elementAt(7): PlutoCell(value:value.isDone==true? value.passRate.toString():"لم يصحح بعد".tr),
              data.keys.elementAt(8): PlutoCell(value:value.isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),

            },
          ),
        );
      },);
      update();
    });
  }

  getAllExamWithOutListen() async {
    await examCollectionRef.get().then((value)async {
      _examMap.clear();
      for (var element in value.docs) {
        _examMap[element.id] = ExamModel.fromJson(element.data());
      }
      print("Exams :${_examMap.keys.length}");
    await  getPassRate();
      update();
    });
  }

  addExam(ExamModel examModel) {
    examCollectionRef.doc(examModel.id).set(examModel.toJson());
    update();
  }

  updateExam(ExamModel examModel) async {
    await examCollectionRef
        .doc(examModel.id)
        .set(examModel.toJson(), SetOptions(merge: true));
    update();
  }

  deleteExam(String examId) async {
    await addWaitOperation(
        type: waitingListTypes.delete,

        collectionName: examsCollection, affectedId: examId);
    update();
  }

  getPassRate() {

    examMap.forEach(
      (key, value) {
        int numOfPass = 0;

        value.marks!.forEach(
          (_, value0) {
            double studentPercentage = double.parse(value0);
            int examMaxMark = int.parse(examMap[key]!.examMaxMark!);
            double studentMark = (studentPercentage * examMaxMark) / 100;
            int examPassMark = int.parse(examMap[key]!.examPassMark!);
            if (studentMark >= examPassMark) {
              numOfPass++;
            }
          },
        );

        examMap[key]!.passRate = (numOfPass / value.marks!.length) * 100;
      },
    );
  }

  getGrade(Map<String, StudentModel> studentMap)async {
  // await  getAllExamWithOutListen();

    studentMap.forEach((key, value) {
      if(value.stdExam!.isEmpty)
        studentMap[key]!.grade=0.0;
      else {
        for (var exam in value.stdExam!) {
          studentMap[key]!.grade = studentMap[key]!.grade! +
              double.parse(examMap[exam]?.marks?[key] ?? "0");
        }
        studentMap[key]!.grade =
            studentMap[key]!.grade! / studentMap[key]!.stdExam!.length;
      }
    });
  }

   getOldData(String value) async{

    await FirebaseFirestore.instance.collection(archiveCollection).doc(value).collection(examsCollection).get().then((value)async{
      _examMap.clear();
      key=GlobalKey();
      rows.clear();
      for (var element in value.docs) {
        _examMap[element.id] = ExamModel.fromJson(element.data());
      }
      print("Exams :${_examMap.keys.length}");
      await getPassRate();

      _examMap.forEach((key, value) {
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: key),
              data.keys.elementAt(1): PlutoCell(value:value.subject.toString()),
              data.keys.elementAt(2): PlutoCell(value:value.professor.toString()),
              data.keys.elementAt(3): PlutoCell(value:value.date),
              data.keys.elementAt(4): PlutoCell(value:value.marks?.length.toString()),
              data.keys.elementAt(5): PlutoCell(value:value.examPassMark.toString()),
              data.keys.elementAt(6): PlutoCell(value:value.examMaxMark.toString()),
              data.keys.elementAt(7): PlutoCell(value:value.isDone==true? value.passRate.toString():"لم يصحح بعد".tr),
              data.keys.elementAt(8): PlutoCell(value:value.isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),

            },
          ),
        );
      },);
      update();
    });
  }
}
