import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/models/event_model.dart';

import '../../../constants.dart';
import '../../../controller/Wait_management_view_model.dart';
import '../../../utils/To_AR.dart';
import '../../../utils/const.dart';

class EventViewModel extends GetxController {
  RxMap<String, EventModel> allEvents = <String, EventModel>{}.obs;
  final eventFireStore = FirebaseFirestore.instance.collection(Const.eventCollection).withConverter<EventModel>(
        fromFirestore: (snapshot, _) => EventModel.fromJson(snapshot.data()!),
        toFirestore: (account, _) => account.toJson(),
      );
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  Color selectedColor = secondaryColor;

  getColumns() {
    columns.clear();
    columns.addAll(toAR(data));
  }

  EventViewModel() {
    getColumns();

    getAllEventRecord();
  }

  late StreamSubscription<QuerySnapshot<EventModel>> listener;

  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "الاسم": PlutoColumnType.text(),
    "العنصر المتأثر": PlutoColumnType.text(),
    "اللون": PlutoColumnType.text(),
  };

  GlobalKey plutoKey = GlobalKey();



  getAllEventRecord() {
    listener = eventFireStore.snapshots().listen(
      (event) {
        selectedColor = secondaryColor;
        plutoKey = GlobalKey();
        rows.clear();
        allEvents = Map<String, EventModel>.fromEntries(event.docs.toList().map((i) {
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: i.id),
                data.keys.elementAt(1): PlutoCell(value: i.data().name),
                data.keys.elementAt(2): PlutoCell(value: i.data().role),
                data.keys.elementAt(3): PlutoCell(value: i.data().color.toString()),
              },
            ),
          );
          return MapEntry(i.id.toString(), i.data());
        })).obs;

        update();
      },
    );
  }

  addEvent(EventModel eventModel) {
    eventFireStore.doc(eventModel.id).set(eventModel);
  }

  updateEvent(EventModel eventModel) {
    eventFireStore.doc(eventModel.id).update(eventModel.toJson());
  }

  deleteEvent(EventModel eventModel) {
    eventFireStore.doc(eventModel.id).delete();
  }

  getOldData(String value) {
    FirebaseFirestore.instance.collection(archiveCollection).doc(value).collection(Const.eventCollection).get().then(
      (event) {
        allEvents = Map<String, EventModel>.fromEntries(event.docs.toList().map((i) => MapEntry(i.id.toString(), EventModel.fromJson(i.data())))).obs;
        listener.cancel();
        update();
      },
    );
  }
  /// use this for current row selected from user
  String currentId = '';
  /// use this for check if current selected id is deleted
  bool getIfDelete() {
    print(checkIfPendingDelete(affectedId: currentId));
    return checkIfPendingDelete(affectedId: currentId);
  }
  String? role;
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  int selectedMatColor = 4294198070;
clearController(){
  name.clear();
  pass.clear();
  role = null;
  selectedMatColor = 4294198070;
  currentId='';
  update();
}

  /// use this for get current row selected from user
  setCurrentId(value) {
    currentId = value;
    name.text=allEvents[currentId]!.name;
    selectedMatColor=allEvents[currentId]!.color;
    role = allEvents[currentId]!.role;
    update();
  }
}
