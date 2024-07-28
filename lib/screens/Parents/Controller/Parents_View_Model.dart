import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/models/Parent_Model.dart';

import '../../../utils/To_AR.dart';

class ParentsViewModel extends GetxController {
  final parentCollectionRef =
      FirebaseFirestore.instance.collection(parentsCollection);
  final firebaseFirestore =
  FirebaseFirestore.instance;



  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];



  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "الاسم الكامل": PlutoColumnType.text(),
    "العنوان": PlutoColumnType.text(),
    "الجنسية": PlutoColumnType.text(),
    "العمر": PlutoColumnType.text(),
    "العمل": PlutoColumnType.text(),
    "تاريخ البداية": PlutoColumnType.text(),
    "رقم الام": PlutoColumnType.text(),
    "رقم الطوارئ": PlutoColumnType.text(),
    "سجل الأحداث": PlutoColumnType.text(),
    "موافقة المدير": PlutoColumnType.text(),

  };
  GlobalKey key=GlobalKey();

  ParentsViewModel(){
    getColumns();
    getAllParent();
  }

  getColumns(){
    columns.clear();
    columns.addAll(toAR(data));
  }
  Map<String, ParentModel> _parentMap = {};

  Map<String, ParentModel> get parentMap => _parentMap;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;

  getAllParent()async {
    listener=   await   parentCollectionRef.snapshots().listen((value) {
      _parentMap.clear();
      key=GlobalKey();
      rows.clear();
      for (var element in value.docs) {
        _parentMap[element.id] = ParentModel.fromJson(element.data());
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: element.id),
              data.keys.elementAt(1): PlutoCell(value: ParentModel.fromJson(element.data()).fullName),
              data.keys.elementAt(2): PlutoCell(value:  ParentModel.fromJson(element.data()).address),
              data.keys.elementAt(3): PlutoCell(value:  ParentModel.fromJson(element.data()).nationality),
              data.keys.elementAt(4): PlutoCell(value:  ParentModel.fromJson(element.data()).age),
              data.keys.elementAt(5): PlutoCell(value:  ParentModel.fromJson(element.data()).work),
              data.keys.elementAt(6):
              PlutoCell(value: ParentModel.fromJson(element.data()).startDate),
              data.keys.elementAt(7): PlutoCell(value:  ParentModel.fromJson(element.data()).motherPhone),
              data.keys.elementAt(8): PlutoCell(value:  ParentModel.fromJson(element.data()).emergencyPhone),
              data.keys.elementAt(9): PlutoCell(value:  ParentModel.fromJson(element.data()).eventRecords?.length??"0"),
              data.keys.elementAt(10): PlutoCell(value:  ParentModel.fromJson(element.data()).isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),
            },
          ),
        );
      }
      print("Parents :${_parentMap.values.length}");
      update();
    });
  }

  addParent(ParentModel parentModel) {
    parentCollectionRef.doc(parentModel.id).set(parentModel.toJson(), SetOptions(merge: true));
    update();
  }

  updateParent(ParentModel parentModel) async{
    await  parentCollectionRef
        .doc(parentModel.id)
        .set(parentModel.toJson(), SetOptions(merge: true));
    update();
  }

  deleteParent(String parentId,List studentList)async {
   await addWaitOperation(
       type: waitingListTypes.delete,

       collectionName: parentsCollection,
        affectedId: parentId,
   relatedList: studentList.map((e) => e.toString(),).toList());
    update();
  }

  getOldParent(String value) async{
    await   firebaseFirestore.collection(archiveCollection).doc(value).collection(parentsCollection).get().then((value) {
      _parentMap.clear();
      key=GlobalKey();
      rows.clear();
      for (var element in value.docs) {
        _parentMap[element.id] = ParentModel.fromJson(element.data());
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: element.id),
              data.keys.elementAt(1): PlutoCell(value: ParentModel.fromJson(element.data()).fullName),
              data.keys.elementAt(2): PlutoCell(value:  ParentModel.fromJson(element.data()).address),
              data.keys.elementAt(3): PlutoCell(value:  ParentModel.fromJson(element.data()).nationality),
              data.keys.elementAt(4): PlutoCell(value:  ParentModel.fromJson(element.data()).age),
              data.keys.elementAt(5): PlutoCell(value:  ParentModel.fromJson(element.data()).work),
              data.keys.elementAt(6):
              PlutoCell(value: ParentModel.fromJson(element.data()).startDate),
              data.keys.elementAt(7): PlutoCell(value:  ParentModel.fromJson(element.data()).motherPhone),
              data.keys.elementAt(8): PlutoCell(value:  ParentModel.fromJson(element.data()).emergencyPhone),
              data.keys.elementAt(9): PlutoCell(value:  ParentModel.fromJson(element.data()).eventRecords?.length??"0"),
              data.keys.elementAt(10): PlutoCell(value:  ParentModel.fromJson(element.data()).isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),
            },
          ),
        );
      }
      print("Parents :${_parentMap.values.length}");
      update();
    });

  }

  void deleteStudent(String parentId,String studentID) {

    _parentMap[parentId]!.children!.removeWhere((element) => element==studentID,);
    parentCollectionRef.doc(parentId).set({"children": _parentMap[parentId]!.children!},SetOptions(merge: true));

  }
}
