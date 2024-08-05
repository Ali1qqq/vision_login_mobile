import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/models/expenses_model.dart';
import '../../../constants.dart';
import '../../../core/Utils/service.dart';
import '../../Buses/Controller/Bus_View_Model.dart';
import '../../Widgets/Custom_Text_Filed.dart';
import '../../../utils/Dialogs.dart';
import '../../../utils/Hive_DataBase.dart';
import '../../../utils/To_AR.dart';
import '../../../utils/const.dart';
import '../../../controller/Wait_management_view_model.dart';

class ExpensesViewModel extends GetxController {
  RxMap<String, ExpensesModel> allExpenses = <String, ExpensesModel>{}.obs;
  final expensesFireStore = FirebaseFirestore.instance.collection(Const.expensesCollection).withConverter<ExpensesModel>(
        fromFirestore: (snapshot, _) => ExpensesModel.fromJson(snapshot.data()!),
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
    "موافقة المدير": PlutoColumnType.text(),
  };

  /// use this for current row selected from user
  String currentId = '';
/// use this for check if current selected id is deleted
  bool getIfDelete() {
    return checkIfPendingDelete(affectedId: currentId);
  }



  /// delete or return current selected row
  void handleDeleteOrRestore(BuildContext context, WaitManagementViewModel waitController) {

    /// if user in archive mode
    if (!enableUpdate) return;

    if (getIfDelete()) {
      waitController.returnDeleteOperation(affectedId: allExpenses[currentId]!.id.toString());
    } else {
      TextEditingController editController = TextEditingController();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        widget: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(controller: editController, title: "سبب الحذف".tr, size: Get.width / 4),
          ),
        ),
        text: 'قبول هذه العملية'.tr,
        title: 'هل انت متأكد ؟'.tr,
        onConfirmBtnTap: () async {
          await addWaitOperation(
            type: waitingListTypes.delete,
            details: editController.text,
            collectionName: Const.expensesCollection,
            affectedId: allExpenses[currentId]!.id!,
            relatedId: allExpenses[currentId]!.busId,
          );
          Get.back();
        },
        onCancelBtnTap: () => Get.back(),
        confirmBtnText: 'نعم'.tr,
        cancelBtnText: 'لا'.tr,
        confirmBtnColor: Colors.redAccent,
        showCancelBtn: true,
      );
    }
  }

  ///this for rebuild pluto Grid
  GlobalKey plutoKey = GlobalKey();

  ExpensesViewModel() {
    getColumns();
    getAllExpenses();
  }


  /// get column header for pluto Grid
  getColumns() {
    columns.clear();
    columns.addAll(toAR(data));
  }


  /// this for cancel listener
  late StreamSubscription<QuerySnapshot<ExpensesModel>> listener;
  Color selectedColor=secondaryColor;

  getAllExpenses() {
    final acc = Get.find<EmployeeViewModel>();
    listener = expensesFireStore.snapshots().listen(
      (event) {
        plutoKey = GlobalKey();
        rows.clear();
        selectedColor=secondaryColor;
        allExpenses = Map<String, ExpensesModel>.fromEntries(event.docs.toList().map((i) {
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: i.id),
                data.keys.elementAt(1): PlutoCell(value: i.data().title),
                data.keys.elementAt(2): PlutoCell(value: i.data().total),
                data.keys.elementAt(3): PlutoCell(value: acc.allAccountManagement[i.data().userId]?.fullName ?? 'No user'),
                data.keys.elementAt(4): PlutoCell(value: i.data().body),
                data.keys.elementAt(5): PlutoCell(value: i.data().images?.length ?? 0),
                data.keys.elementAt(6): PlutoCell(value: i.data().date),
                data.keys.elementAt(7): PlutoCell(value: i.data().isAccepted == true ? "تمت الموافقة".tr : "في انتظار الموافقة".tr),
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
        allExpenses = Map<String, ExpensesModel>.fromEntries(event.docs.toList().map((i) {
          return MapEntry(i.id.toString(), i.data());
        })).obs;

        print("expenses without listen ${allExpenses.length}");

        update();
      },
    );
  }

  /// we use this in diagrams for set limit tall of column height
  double getMaxExpenses() {
    double sub = 0.0;
    allExpenses.forEach(
      (key, value) {
        if (sub < (value.total ?? 0)) sub = (value.total ?? 0) * 1.0;
      },
    );
/// we add 5000 for add more space to max tall
    return sub + 5000;
  }

  double getExpensesAtMonth(String month) {
    double sub = 0.0;
    allExpenses.forEach(
      (key, value) {
        if (value.date!.split("-")[1] == month.padLeft(2, "0")) sub += (value.total ?? 0);
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
    expensesFireStore.doc(expensesModel.id).set(expensesModel, SetOptions(merge: true));
  }

  updateExpenses(ExpensesModel expensesModel) {
    expensesFireStore.doc(expensesModel.id).update(expensesModel.toJson());
  }

  getOldData(String value) async {
    final acc = Get.find<EmployeeViewModel>();
    await FirebaseFirestore.instance.collection(archiveCollection).doc(value).collection(Const.expensesCollection).get().then(
      (event) {
        plutoKey = GlobalKey();
        rows.clear();
        allExpenses = Map<String, ExpensesModel>.fromEntries(event.docs.toList().map((i) {
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: i.id),
                data.keys.elementAt(1): PlutoCell(value: i.data()["title"]),
                data.keys.elementAt(2): PlutoCell(value: i.data()["total"]),
                data.keys.elementAt(3): PlutoCell(value: acc.allAccountManagement[i.data()["userId"]]?.fullName ?? 'No user'),
                data.keys.elementAt(4): PlutoCell(value: i.data()["body"]),
                data.keys.elementAt(5): PlutoCell(value: i.data()["images"]?.length ?? 0),
                data.keys.elementAt(6): PlutoCell(value: i.data()["date"]),
                data.keys.elementAt(7): PlutoCell(value: i.data()["isAccepted"] == true ? "تمت الموافقة".tr : "في انتظار الموافقة".tr),
              },
            ),
          );
          return MapEntry(i.id.toString(), ExpensesModel.fromJson(i.data()));
        })).obs;

        print("expenses ${allExpenses.length}");

        update();
      },
    );
  }


  /// use this for get current row selected from user
  setCurrentId(value) {
    currentId = value;
    update();
  }


  /// use this to change view screen

  bool isAdd = false;

  /// this for add Expenses to bus
   String? busId=null;
   ///  this for Edite Expenses we pass it in initController method
   ExpensesModel? expensesModel=null;


  final titleController = TextEditingController();
  final totalController = TextEditingController();
  final bodyController = TextEditingController();
  final dateController = TextEditingController();
  /// this for image already have in Edite Expenses model
  List imageLinkList = [];
  /// this for image upload from user (we save it temporary before we upload it )
  List<Uint8List> ImagesTempData = [];

  ///  this for Edite Expenses we pass it wen we click in Edite button in line 12
  initController(ExpensesModel model) {
    clearController();
    expensesModel=model;
    if (expensesModel != null) {
      titleController.text = expensesModel!.title.toString();
      totalController.text = expensesModel!.total.toString();
      bodyController.text = expensesModel!.body.toString();
      dateController.text = expensesModel!.date.toString();
      imageLinkList.addAll(expensesModel!.images ?? []);
    }
  }

  clearController() {
    titleController.clear();
    totalController.clear();
    bodyController.clear();
    dateController.clear();
    imageLinkList = [];
    ImagesTempData = [];
    busId = null;
    expensesModel = null;
  }

  /// use this for add or Edit Expenses
  saveExpenses(BuildContext context) async {

    if (validateFields(requiredControllers: [
      titleController,
      totalController,
    ], numericControllers: [
      totalController,
    ])) {
      loadingQuickAlert(context);
      /// upload images
      await uploadImages(ImagesTempData, "expenses").then(
        (value) => imageLinkList.addAll(value),
      );
      BusViewModel busController = Get.find<BusViewModel>();
      ExpensesModel model = ExpensesModel(
        date: dateController.text,
        isAccepted: expensesModel == null ? true : false,
        id: expensesModel == null ? generateId("ExP") : expensesModel!.id!,
        busId: busId,
        title: titleController.text,
        body: busId != null ? "مصروف الحافلة ${busController.busesMap[busId]!.name}\n ${bodyController.text}" : bodyController.text,
        total: int.parse(totalController.text),
        userId: HiveDataBase.getAccountManagementModel()!.id,
        images: imageLinkList,
      );

      await addExpenses(model);

      ///وقت التعديل
      if (expensesModel != null) {
        Get.back();
        addWaitOperation(collectionName: Const.expensesCollection, oldData: expensesModel!.toJson(), newData: model.toJson(), affectedId: model.id!, type: waitingListTypes.edite);
      }
      /// اذا كانت الواجهة مستدعاه من الباص
      if (busId != null) {
        await busController.addExpenses(busId!, model.id!);
        Get.back();
        // Get.back();
      }
      clearController();


      Get.back();
    }
  }

  /// use this to change view screen
  void foldScreen() {
    clearController();

    dateController.text = thisTimesModel!.dateTime.toString().split(" ")[0];

    isAdd = !isAdd;
    update();
  }
}
