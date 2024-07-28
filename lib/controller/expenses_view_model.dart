import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';
import 'package:vision_dashboard/models/expenses_model.dart';
import '../constants.dart';
import '../utils/To_AR.dart';
import '../utils/const.dart';

class ExpensesViewModel extends GetxController {
  RxMap<String, ExpensesModel> allExpenses = <String, ExpensesModel>{}.obs;
  final expensesFireStore = FirebaseFirestore.instance
      .collection(Const.expensesCollection)
      .withConverter<ExpensesModel>(
        fromFirestore: (snapshot, _) =>
            ExpensesModel.fromJson(snapshot.data()!),
        toFirestore: (data, _) => data.toJson(),
      );

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "العنوان": PlutoColumnType.text(),
    "المبلغ": PlutoColumnType.currency(
      locale: 'ar',
      symbol: 'AED',
      name: 'درهم',
      decimalDigits: 2,
    ),
    "اسم الموظف": PlutoColumnType.text(),
    "الوصف": PlutoColumnType.text(),
    "الفواتير المدخلة": PlutoColumnType.number(),
    "تاريخ": PlutoColumnType.date(),
    "موافقة المدير":PlutoColumnType.text(),

  };
  GlobalKey key=GlobalKey();
  ExpensesViewModel() {
    getColumns();
    getAllExpenses();


  }

  getColumns(){
    columns.clear();
    columns.addAll(toAR(data));
  }
  late StreamSubscription<QuerySnapshot<ExpensesModel>> listener;


  getAllExpenses() {
    final acc=  Get.find<AccountManagementViewModel>();
    listener = expensesFireStore.snapshots().listen(
      (event) {
        key=GlobalKey();
        rows.clear();
        allExpenses =
            Map<String, ExpensesModel>.fromEntries(event.docs.toList().map((i) {
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: i.id),
                data.keys.elementAt(1): PlutoCell(value: i.data().title),
                data.keys.elementAt(2): PlutoCell(value: i.data().total),
                data.keys.elementAt(3): PlutoCell(value:acc.allAccountManagement[i.data().userId]?.fullName??'No user' ),
                data.keys.elementAt(4): PlutoCell(value: i.data().body),
                data.keys.elementAt(5):
                    PlutoCell(value: i.data().images?.length ?? 0),
                data.keys.elementAt(6): PlutoCell(value: i.data().date),
                data.keys.elementAt(7): PlutoCell(value: i.data().isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),
              },
            ),
          );
          return MapEntry(i.id.toString(), i.data());
        })).obs;

        print("expenses ${allExpenses.length}");

        update();
      },
    );
  }
  getAllWithoutListenExpenses() {
     expensesFireStore.get().then(
          (event) {

        allExpenses =
            Map<String, ExpensesModel>.fromEntries(event.docs.toList().map((i) {
              return MapEntry(i.id.toString(), i.data());
            })).obs;

        print("expenses without listen ${allExpenses.length}");

        update();
      },
    );
  }

  double getMaxExpenses() {
    double sub = 0.0;
    allExpenses.forEach(
      (key, value) {
        if (sub < (value.total ?? 0)) sub = (value.total ?? 0) * 1.0;
      },
    );

    return sub + 5000;
  }

  double getExpensesAtMonth(String month) {
    double sub = 0.0;
    allExpenses.forEach(
      (key, value) {
        if (value.date!.split("-")[1] == month.padLeft(2, "0"))
          sub += (value.total ?? 0);
      },
    );

    return sub;
  }

  double getAllExpensesMoney() {
    double sub = 0.0;
    allExpenses.forEach(
      (key, value) {
        sub += (value.total ?? 0);
      },
    );
    return sub;
  }

  addExpenses(ExpensesModel expensesModel) {
    expensesFireStore
        .doc(expensesModel.id)
        .set(expensesModel, SetOptions(merge: true));
  }

  updateExpenses(ExpensesModel expensesModel) {
    expensesFireStore.doc(expensesModel.id).update(expensesModel.toJson());
  }

  getOldData(String value) async {
    final acc=  Get.find<AccountManagementViewModel>();
    await FirebaseFirestore.instance
        .collection(archiveCollection)
        .doc(value)
        .collection(Const.expensesCollection)
        .get()
        .then(
          (event) {
        key=GlobalKey();
        rows.clear();
        allExpenses =
            Map<String, ExpensesModel>.fromEntries(event.docs.toList().map((i) {
              rows.add(
                PlutoRow(
                  cells: {
                    data.keys.elementAt(0): PlutoCell(value: i.id),
                    data.keys.elementAt(1): PlutoCell(value: i.data()["title"]),
                    data.keys.elementAt(2): PlutoCell(value: i.data()["total"]),
                    data.keys.elementAt(3): PlutoCell(value:acc.allAccountManagement[i.data()["userId"]]?.fullName??'No user' ),
                    data.keys.elementAt(4): PlutoCell(value: i.data()["body"]),
                    data.keys.elementAt(5):
                    PlutoCell(value: i.data()["images"]?.length ?? 0),
                    data.keys.elementAt(6): PlutoCell(value: i.data()["date"]),
                    data.keys.elementAt(7): PlutoCell(value: i.data()["isAccepted"]==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),
                  },
                ),
              );
              return MapEntry(i.id.toString(),ExpensesModel.fromJson(i.data()) );
            })).obs;

        print("expenses ${allExpenses.length}");

        update();
      },
    );
  }
}
