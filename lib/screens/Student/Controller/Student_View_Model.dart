import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/models/Student_Model.dart';
import 'package:vision_dashboard/screens/Study%20Fees/Controller/Study_Fees_View_Model.dart';

import '../../../core/constant/constants.dart';

import '../../../core/Utils/To_AR.dart';
import '../../Buses/Controller/Bus_View_Model.dart';
import '../../Parents/Controller/Parents_View_Model.dart';

class StudentViewModel extends GetxController {
  final studentCollectionRef =
      FirebaseFirestore.instance.collection(studentCollection);
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  List<String> contracts = [];
  List<Uint8List> contractsTemp = [];
  int imageHeight=200;
  int imageWidth=200;


  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "اسم الطالب": PlutoColumnType.text(),
    "رقم الطالب": PlutoColumnType.text(),
    "الجنس": PlutoColumnType.text(),
    "الميلاد": PlutoColumnType.text(),
    "الصف": PlutoColumnType.text(),
    "تاريخ البداية": PlutoColumnType.text(),
    "الحافلة": PlutoColumnType.text(),
    "ولي الأمر": PlutoColumnType.text(),
    "المعدل": PlutoColumnType.text(),
    "سجل الأحداث": PlutoColumnType.text(),
    "موافقة المدير": PlutoColumnType.text(),
  };
  GlobalKey plutoKey = GlobalKey();

  StudentViewModel() {
    getColumns();

    getAllStudent();
  }

  getColumns() {
    columns.clear();
    columns.addAll(toAR(data));
  }

  Map<String, StudentModel> _studentMap = {};

  Map<String, StudentModel> get studentMap => _studentMap;




  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;
  Color selectedColor=secondaryColor;


  getAllStudent() async {
    listener = await studentCollectionRef.snapshots().listen((value) async {
      _studentMap.clear();

      for (var element in value.docs) {
        _studentMap[element.id] = StudentModel.fromJson(element.data());
      }
      await Get.find<BusViewModel>().getAllWithoutListenBuse();
      selectedColor=secondaryColor;
      plutoKey = GlobalKey();
      rows.clear();
      _studentMap.forEach(
        (key, value) {
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: key),
                data.keys.elementAt(1): PlutoCell(value: value.studentName),
                data.keys.elementAt(2): PlutoCell(value: value.studentNumber),
                data.keys.elementAt(3): PlutoCell(value: value.gender),
                data.keys.elementAt(4): PlutoCell(value: value.StudentBirthDay),
                data.keys.elementAt(5): PlutoCell(value: value.stdClass),
                data.keys.elementAt(6): PlutoCell(value: value.startDate),
                data.keys.elementAt(7): PlutoCell(
                    value: Get.find<BusViewModel>().busesMap[value.bus]?.name ??
                        value.bus),
                data.keys.elementAt(8): PlutoCell(
                    value: Get.find<ParentsViewModel>()
                        .parentMap[value.parentId]!
                        .fullName),
                data.keys.elementAt(9): PlutoCell(value: value.grade),
                data.keys.elementAt(10):
                    PlutoCell(value: value.eventRecords?.length ?? "0"),
                data.keys.elementAt(11): PlutoCell(value: value.isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),
              },
            ),
          );
        },
      );
      Get.find<StudyFeesViewModel>().getParentFees();
      update();
    });
  }

  getAllStudentWithOutListen() async {
    await studentCollectionRef.get().then((value) {
      _studentMap.clear();

      for (var element in value.docs) {
        _studentMap[element.id] = StudentModel.fromJson(element.data());
      }
      print("Student :${_studentMap.keys.length}");

      update();
    });
  }

  addStudent(StudentModel studentModel) async {
    await studentCollectionRef
        .doc(studentModel.studentID)
        .set(studentModel.toJson());

    if (studentModel.parentId != null)
      await FirebaseFirestore.instance
          .collection(parentsCollection)
          .doc(studentModel.parentId)
          .set({
        "children": FieldValue.arrayUnion([studentModel.studentID])
      }, SetOptions(merge: true));

    update();
  }

  updateStudent(StudentModel studentModel) async {
    await studentCollectionRef
        .doc(studentModel.studentID)
        .set(studentModel.toJson(), SetOptions(merge: true));

    update();
  }





  // deleteStudent(String studentId) async {
  //   await addWaitOperation(
  //       type: waitingListTypes.delete,
  //       collectionName: studentCollection,
  //       affectedId: studentId);
  //   update();
  // }

  getOldData(String value) async {
    await FirebaseFirestore.instance
        .collection(archiveCollection)
        .doc(value)
        .collection(studentCollection)
        .get()
        .then((value)  async{
      _studentMap.clear();

      for (var element in value.docs) {
        _studentMap[element.id] = StudentModel.fromJson(element.data());
      }
      await Get.find<BusViewModel>().getAllWithoutListenBuse();
      plutoKey = GlobalKey();
      rows.clear();
      _studentMap.forEach(
            (key, value) {
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: key),
                data.keys.elementAt(1): PlutoCell(value: value.studentName),
                data.keys.elementAt(2): PlutoCell(value: value.studentNumber),
                data.keys.elementAt(3): PlutoCell(value: value.gender),
                data.keys.elementAt(4): PlutoCell(value: value.StudentBirthDay),
                data.keys.elementAt(5): PlutoCell(value: value.stdClass),
                data.keys.elementAt(6): PlutoCell(value: value.startDate),
                data.keys.elementAt(7): PlutoCell(
                    value: Get.find<BusViewModel>().busesMap[value.bus]?.name ??
                        value.bus),
                data.keys.elementAt(8): PlutoCell(
                    value: Get.find<ParentsViewModel>()
                        .parentMap[value.parentId]!
                        .fullName),
                data.keys.elementAt(9): PlutoCell(value: value.grade),
                data.keys.elementAt(10):
                PlutoCell(value: value.eventRecords?.length ?? "0"),
                data.keys.elementAt(11): PlutoCell(value: value.isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),
              },
            ),
          );
        },
      );
      update();
    });
  }



  void removeClass(String studentId) {
    studentCollectionRef
        .doc(studentId)
        .set({"stdClass": null}, SetOptions(merge: true));
  }

  setBus(String s, List std) {
    for (var student in std)
      studentCollectionRef
          .doc(student)
          .set({"bus": s}, SetOptions(merge: true));
  }

  removeExam(String examId, List studentList) {
    for (var std in studentList) {
      _studentMap[std]!.stdExam!.removeWhere(
            (element) => element == examId,
          );
      studentCollectionRef.doc(std).set(
          {"stdExam":_studentMap[std]!.stdExam},
          SetOptions(merge: true));
    }
  }
}
