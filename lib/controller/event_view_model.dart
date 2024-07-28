

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:vision_dashboard/models/event_model.dart';

import '../constants.dart';
import '../utils/const.dart';


class EventViewModel extends GetxController{
  RxMap<String,EventModel> allEvents = <String,EventModel>{}.obs;
  final eventFireStore = FirebaseFirestore.instance.collection(Const.eventCollection).withConverter<EventModel>(
    fromFirestore: (snapshot, _) =>EventModel.fromJson(snapshot.data()!),
    toFirestore: (account, _) => account.toJson(),
  );

  EventViewModel(){
    getAllEventRecord();
  }
  late StreamSubscription<QuerySnapshot<EventModel>> listener;

  getAllEventRecord(){
    listener= eventFireStore.snapshots().listen((event) {
    allEvents = Map<String,EventModel>.fromEntries(event.docs.toList().map((i)=>MapEntry(i.id.toString(), i.data()))).obs;
    update();
  },);
}
  addEvent(EventModel eventModel){
    eventFireStore.doc(eventModel.id).set(eventModel);
  }

  updateEvent(EventModel eventModel){
    eventFireStore.doc(eventModel.id).update(eventModel.toJson());
  }

  deleteEvent(EventModel eventModel){
    eventFireStore.doc(eventModel.id).delete();
  }

   getOldData(String value) {
    FirebaseFirestore.instance.collection(archiveCollection).doc(value).collection(Const.eventCollection).get().then((event) {
      allEvents = Map<String,EventModel>.fromEntries(event.docs.toList().map((i)=>MapEntry(i.id.toString(),EventModel.fromJson(i.data())))).obs;
     listener.cancel();
      update();
    },);
  }

}