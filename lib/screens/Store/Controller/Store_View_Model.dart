import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/models/Store_Model.dart';

import '../../../controller/Wait_management_view_model.dart';
import '../../../utils/To_AR.dart';

class StoreViewModel extends GetxController{
  final storeCollectionRef =
  FirebaseFirestore.instance.collection(storeCollection);
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "اسم المادة": PlutoColumnType.text(),
    "الكمية": PlutoColumnType.text(),
    "موافقة المدير": PlutoColumnType.text(),

  };

  GlobalKey key = GlobalKey();
  StoreViewModel(){
    getColumns();
    getAllStore();
  }

  getColumns() {
    columns.clear();
    columns.addAll(toAR(data));
  }
  Map<String, StoreModel> _storeMap = {};

  Map<String, StoreModel> get storeMap => _storeMap;

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;

  getAllStore()async {
    listener=   await   storeCollectionRef.snapshots().listen((value) {
      _storeMap.clear();
      key = GlobalKey();
      rows.clear();
      for (var element in value.docs) {
        _storeMap[element.id] = StoreModel.fromJson(element.data());
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: element.id),
              data.keys.elementAt(1):
              PlutoCell(value: StoreModel.fromJson(element.data()).subName),
              data.keys.elementAt(2):
              PlutoCell(value: StoreModel.fromJson(element.data()).subQuantity),
              data.keys.elementAt(3):
              PlutoCell(value: StoreModel.fromJson(element.data()).isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),

            },
          ),
        );
      }
      print("StoreModel :${_storeMap.keys.length}");
      update();
    });
  }

  addStore(StoreModel storeModel) {
    storeCollectionRef.doc(storeModel.id).set(storeModel.toJson());
    update();
  }

  updateStore(StoreModel storeModel) async{
    await  storeCollectionRef
        .doc(storeModel.id)
        .set(storeModel.toJson(), SetOptions(merge: true));
    update();
  }

  deleteStore(String storeId)async {
    await addWaitOperation(
        type: waitingListTypes.delete,

        collectionName: storeCollection,
        affectedId: storeId);
    update();
  }



  getOldData(String value)async{

    await FirebaseFirestore.instance.collection(archiveCollection).doc(value).collection(storeCollection).get().then((value) {

      _storeMap.clear();
      key = GlobalKey();
      rows.clear();
      for (var element in value.docs) {
        _storeMap[element.id] = StoreModel.fromJson(element.data());
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: element.id),
              data.keys.elementAt(1):
              PlutoCell(value: StoreModel.fromJson(element.data()).subName),
              data.keys.elementAt(2):
              PlutoCell(value: StoreModel.fromJson(element.data()).subQuantity),
              data.keys.elementAt(3):
              PlutoCell(value: StoreModel.fromJson(element.data()).isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),

            },
          ),
        );
      }
      print("StoreModel :${_storeMap.keys.length}");
      listener.cancel();
      update();
    });
  }
}