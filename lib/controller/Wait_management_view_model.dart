import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';
import 'package:vision_dashboard/models/Bus_Model.dart';
import 'package:vision_dashboard/models/Parent_Model.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';
import 'package:vision_dashboard/screens/classes/Controller/Class_View_Model.dart';
import 'package:vision_dashboard/utils/Dialogs.dart';

import '../models/delete_management_model.dart';
import '../screens/Parents/Controller/Parents_View_Model.dart';

import '../utils/const.dart';

class WaitManagementViewModel extends GetxController {
  ParentsViewModel _parentsViewModel = Get.find<ParentsViewModel>();

  BusViewModel _busViewModel = Get.find<BusViewModel>();
  RxMap<String, WaitManagementModel> allWaiting =
      <String, WaitManagementModel>{}.obs;
  final waitManagementFireStore = FirebaseFirestore.instance
      .collection(Const.waitManagementCollection)
      .withConverter<WaitManagementModel>(
        fromFirestore: (snapshot, _) =>
            WaitManagementModel.fromJson(snapshot.data()!),
        toFirestore: (account, _) => account.toJson(),
      );

  WaitManagementViewModel() {
    getAllDeleteModel();
  }

  late StreamSubscription<QuerySnapshot<WaitManagementModel>> listener;

  getAllDeleteModel() {
    listener = waitManagementFireStore.snapshots().listen(
      (event) {
        allWaiting = Map<String, WaitManagementModel>.fromEntries(event.docs
            .toList()
            .map((i) => MapEntry(i.id.toString(), i.data()))).obs;
        update();
      },
    );
  }

  doTheWait(WaitManagementModel waitModel) async {
    await setAcceptedDeleteOperation(waitModel, true);
    if (waitModel.type == waitingListTypes.delete.name)
      doDelete(waitModel);
    else if (waitModel.type == waitingListTypes.returnInstallment.name)
      doReturnInstallment(waitModel);
    if (waitModel.type == waitingListTypes.add.name) doAdd(waitModel);
    update();


  }

  doAdd(WaitManagementModel waitModel) async {
    Get.find<AccountManagementViewModel>().setAccepted(waitModel.affectedId);
  }

  doReturnInstallment(WaitManagementModel waitModel) async {
    await Get.find<StudentViewModel>().setInstallmentPay(
        waitModel.affectedId, waitModel.relatedId.toString(), false,'');
  }

  doDelete(WaitManagementModel waitModel) async {
    await FirebaseFirestore.instance
        .collection(waitModel.collectionName)
        .doc(waitModel.affectedId)
        .delete();
    switch (waitModel.collectionName) {
      case Const.expensesCollection:
        if (waitModel.relatedId != null) {
          await deleteExpenseFromBus(
              waitModel.relatedId.toString(), waitModel.affectedId);
        }
        break;
      case studentCollection:
        await deleteStudentFromParentsAndBus(
            waitModel.affectedId, waitModel.relatedId!);
        break;

      case classCollection:
        await deleteClassFromStudent(waitModel.affectedId);
        break;

      case busesCollection:
        {
          Get.find<StudentViewModel>().getAllStudentWithOutListen();
          Get.find<AccountManagementViewModel>().getAllEmployeeWithoutListen();
        }
    }
  }

  deleteStudentFromParentsAndBus(String studentId, String relatedId) async {
    _parentsViewModel.parentMap[relatedId]!.children!.remove(studentId);
    await _parentsViewModel.updateParent(ParentModel(
        id: relatedId,
        children: _parentsViewModel.parentMap[relatedId]!.children!));

  }

  deleteExpenseFromBus(String busId, String expensesId) {
    _busViewModel.busesMap[busId]!.expense!.remove(expensesId);
    _busViewModel.updateBus(BusModel(
        busId: busId, expense: _busViewModel.busesMap[busId]!.expense!));
  }

  undoTheDelete(WaitManagementModel waitModel) {
    setAcceptedDeleteOperation(waitModel, false);
    if (waitModel.type == waitingListTypes.add.name)
      Get.find<AccountManagementViewModel>()
          .deleteUnAcceptedAccount(waitModel.affectedId);
    if (waitModel.type == waitingListTypes.edite) {}

    update();
  }

  addDeleteOperation(WaitManagementModel waitModel) {
    getTime().then((date) {
      waitManagementFireStore.doc(waitModel.id).set(
        waitModel..date = date!.dateTime.toString(),
      );
    },);

    update();
  }

  updateDeleteOperation(WaitManagementModel waitModel) {
    waitManagementFireStore.doc(waitModel.id).update(waitModel.toJson());
  }

  setAcceptedDeleteOperation(WaitManagementModel waitModel, bool isAccepted) {
    waitManagementFireStore
        .doc(waitModel.id)
        .set(waitModel..isAccepted = isAccepted);
  }

  returnDeleteOperation({required String affectedId}) {
    WaitManagementViewModel controller = Get.find<WaitManagementViewModel>();
    WaitManagementModel deleteManagementModel =
        controller.allWaiting.values.lastWhere(
      (element) => element.affectedId == affectedId,
    );
    waitManagementFireStore.doc(deleteManagementModel.id).delete();
  }

  getOldData(String value) {
    FirebaseFirestore.instance
        .collection(archiveCollection)
        .doc(value)
        .collection(Const.waitManagementCollection)
        .get()
        .then(
      (event) {
        allWaiting = Map<String, WaitManagementModel>.fromEntries(event.docs
            .toList()
            .map((i) => MapEntry(
                i.id.toString(), WaitManagementModel.fromJson(i.data())))).obs;
      },
    );
    listener.cancel();
    update();
  }

  deleteClassFromStudent(String affectedId) {
    String className =
        Get.find<ClassViewModel>().classMap[affectedId]?.className ?? '';
    Get.find<StudentViewModel>().studentMap.forEach(
      (key, value) {
        if (value.stdClass == className) {
          Get.find<StudentViewModel>().removeClass(key);
        }
      },
    );
  }

  deleteBusFromStudentAndEmployee(String affectedId) {
    Get.find<StudentViewModel>().studentMap.forEach(
      (key, value) {
        if (value.bus == affectedId) {}
      },
    );
  }

  approveEdite(WaitManagementModel waitModel) async {
    await FirebaseFirestore.instance
        .collection(waitModel.collectionName)
        .doc(waitModel.affectedId)
        .set({"isAccepted": true}, SetOptions(merge: true));
    setAcceptedDeleteOperation(waitModel, true);
  }

  declineEdit(WaitManagementModel waitModel) async {
    if (waitModel.collectionName == busesCollection) {
      await Get.find<StudentViewModel>()
          .setBus("بدون حافلة", waitModel.newData?['students'] ?? []);
      await Get.find<AccountManagementViewModel>()
          .setBus("بدون حافلة", waitModel.newData?['employees'] ?? []);
      await Get.find<StudentViewModel>()
          .setBus(waitModel.affectedId, waitModel.oldDate?['students'] ?? []);
      await Get.find<AccountManagementViewModel>()
          .setBus(waitModel.affectedId, waitModel.oldDate?['employees'] ?? []);
    }
    if (waitModel.collectionName == examsCollection) {
      await Get.find<StudentViewModel>().removeExam(
          waitModel.affectedId, waitModel.newData!['marks'].keys.toList());
      await Get.find<StudentViewModel>().addExamToStudent(
          waitModel.oldDate!['marks'].keys.toList(), waitModel.affectedId);
    }

    await FirebaseFirestore.instance
        .collection(waitModel.collectionName)
        .doc(waitModel.affectedId)
        .set(waitModel.oldDate!, SetOptions(merge: true));
    setAcceptedDeleteOperation(waitModel, false);
  }

}

addWaitOperation({
  required String collectionName,
  required String affectedId,
  String? details,
  String? relatedId,
  Map<String, dynamic>? oldData,
  Map<String, dynamic>? newData,
  List<String>? relatedList,
  required waitingListTypes type,
}) {
  Get.find<WaitManagementViewModel>().addDeleteOperation(WaitManagementModel(
    id: generateId("Wait"),
    affectedId: affectedId,
    collectionName: collectionName,
    newData: newData,
    oldDate: oldData,
    details: details,
    type: type.name,
    relatedId: relatedId,
  ));
  Get.find<WaitManagementViewModel>().update();
}

bool checkIfPendingAdd({required String affectedId}) {
  return Get.find<WaitManagementViewModel>()
          .allWaiting
          .values
          .where(
            (element) =>
                element.affectedId == affectedId &&
                element.isAccepted != false &&
                (element.type ==
                    waitingListTypes.add
                        .name) /*||(element.isAccepted == null||element.isAccepted == false)*/,
          )
          .length >
      0;
}

bool checkIfPendingDelete({required String affectedId}) {
  return Get.find<WaitManagementViewModel>()
          .allWaiting
          .values
          .where(
            (element) =>
                element.affectedId == affectedId &&
                element.isAccepted != false &&
                (element.type == waitingListTypes.delete.name ||
                    element.type ==
                        waitingListTypes.returnInstallment
                            .name) /*||(element.isAccepted == null||element.isAccepted == false)*/,
          )
          .length >
      0;
}

returnPendingDelete({required String affectedId}) {
  WaitManagementViewModel controller = Get.find<WaitManagementViewModel>();
  WaitManagementModel deleteManagementModel =
      controller.allWaiting.values.lastWhere(
    (element) => element.affectedId == affectedId,
  );
  controller.undoTheDelete(deleteManagementModel);
  controller.update();
}
