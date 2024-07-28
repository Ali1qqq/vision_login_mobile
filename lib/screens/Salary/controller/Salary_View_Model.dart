import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/models/Salary_Model.dart';

import '../../../controller/Wait_management_view_model.dart';

class SalaryViewModel extends GetxController{
  final salaryCollectionRef =
  FirebaseFirestore.instance.collection(salaryCollection);


  SalaryViewModel(){
    getAllSalary();
  }
  Map<String, SalaryModel> _salaryMap = {};

  Map<String, SalaryModel> get salaryMap => _salaryMap;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;
  getAllSalary()async {
    listener=  await   salaryCollectionRef.snapshots().listen((value) {
      _salaryMap.clear();
      for (var element in value.docs) {
        _salaryMap[element.id] = SalaryModel.fromJson(element.data());
      }
      print("salaries :${_salaryMap.keys.length}");
      update();
    });
  }

  addSalary(SalaryModel salaryModel) {
    salaryCollectionRef.doc(salaryModel.salaryId).set(salaryModel.toJson());
    update();
  }

  updateSalary(SalaryModel salaryModel) async{
    await  salaryCollectionRef
        .doc(salaryModel.salaryId)
        .set(salaryModel.toJson(), SetOptions(merge: true));
    update();
  }

  deleteSalary(String salaryId)async {
    await addWaitOperation(
        type: waitingListTypes.delete,

        collectionName: salaryCollection,
        affectedId: salaryId);
    update();
  }



  getOldData(String value)async {

    await  FirebaseFirestore.instance.collection(archiveCollection).doc(value).collection(salaryCollection).get().then((value) {
      _salaryMap.clear();
      for (var element in value.docs) {
        _salaryMap[element.id] = SalaryModel.fromJson(element.data());
      }
      print("salaries :${_salaryMap.keys.length}");
      listener.cancel();
      update();
    });
  }

  int getAllSalaryPay() {

    int total=0;
    _salaryMap.forEach((key, value) {

      total+=double.parse(value.dilaySalary!).toInt();
    },);
update();
    return total;

  }
}