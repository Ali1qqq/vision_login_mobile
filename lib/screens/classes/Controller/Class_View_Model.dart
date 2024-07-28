import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/ClassModel.dart';

import '../../../constants.dart';

class ClassViewModel extends GetxController {
  final classCollectionRef =
      FirebaseFirestore.instance.collection(classCollection);
  final firebaseFirestore = FirebaseFirestore.instance;

  ClassViewModel() {
/*    classNameList.forEach(
      (element) {
        addClass(ClassModel(
            classId: generateId("Class"),
            className: element,
            isAccepted: true));
      },
    );*/
    getAllClass();
  }

  Map<String, ClassModel> _classMap = {};

  Map<String, ClassModel> get classMap => _classMap;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;

  getAllClass() async {
    listener = await classCollectionRef.snapshots().listen((value) {
      _classMap.clear();
      for (var element in value.docs) {
        _classMap[element.id] = ClassModel.fromJson(element.data());
      }
      print("class :${_classMap.values.length}");
      update();
    });
  }

  addStudentToClass(String classId, String stdId) {
    classCollectionRef.doc(classId).set({
      "classStudent": FieldValue.arrayUnion([stdId])
    }, SetOptions(merge: true));
  }

  addClass(ClassModel classModel) {
    classCollectionRef
        .doc(classModel.classId)
        .set(classModel.toJson(), SetOptions(merge: true));
    update();
  }

  updateClass(ClassModel classModel) async {
    await classCollectionRef
        .doc(classModel.classId)
        .set(classModel.toJson(), SetOptions(merge: true));
    update();
  }

  getOldClass(String value) async {
    await firebaseFirestore
        .collection(archiveCollection)
        .doc(value)
        .collection(classCollection)
        .get()
        .then((value) {
      _classMap.clear();
      for (var element in value.docs) {
        _classMap[element.id] = ClassModel.fromJson(element.data());
      }
      print("Class :${_classMap.values.length}");
      listener.cancel();
      update();
    });
  }
}
