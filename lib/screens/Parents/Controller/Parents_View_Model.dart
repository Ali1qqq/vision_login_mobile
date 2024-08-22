import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/models/Parent_Model.dart';
import 'package:vision_dashboard/models/TimeModel.dart';

import '../../../core/Utils/service.dart';
import '../../../models/Installment_model.dart';
import '../../../models/event_model.dart';
import '../../../models/event_record_model.dart';
import '../../../utils/Dialogs.dart';
import '../../../utils/To_AR.dart';
import '../../Widgets/Custom_Text_Filed.dart';
import '../Edite_Add_Parent/parent_user_details.dart';

class ParentsViewModel extends GetxController {
  final parentCollectionRef = FirebaseFirestore.instance.collection(parentsCollection);
  final firebaseFirestore = FirebaseFirestore.instance;

  final fullNameController = TextEditingController();
  final numberController = TextEditingController();
  final addressController = TextEditingController();
  final nationalityController = TextEditingController();
  final startDateController = TextEditingController();
  final motherPhoneNumberController = TextEditingController();
  final bodyEventController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final workController = TextEditingController();
  final editController = TextEditingController();
  final idNumController = TextEditingController();

  Map<String, InstallmentModel> instalmentMap = {};

  List<EventRecordModel> eventRecords = [];
  EventModel? selectedEvent;
  List<String> contracts = [];
  List<Uint8List> contractsTemp = [];
  ParentModel? parent = null;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "الاسم الكامل": PlutoColumnType.text(),
    "عدد الاولاد": PlutoColumnType.text(),
    "العنوان": PlutoColumnType.text(),
    "الجنسية": PlutoColumnType.text(),
    "العمل": PlutoColumnType.text(),
    "تاريخ البداية": PlutoColumnType.text(),
    "رقم الام": PlutoColumnType.text(),
    "رقم الطوارئ": PlutoColumnType.text(),
    "اجمالي الدفعات": PlutoColumnType.text(),
    "سجل الأحداث": PlutoColumnType.text(),
    "موافقة المدير": PlutoColumnType.text(),
  };
  GlobalKey plutoKey = GlobalKey();

  ParentsViewModel() {
    getColumns();
    getAllParent();
  }

  getColumns() {
    columns.clear();
    columns.addAll(toAR(data));
  }

  Map<String, ParentModel> _parentMap = {};

  Map<String, ParentModel> get parentMap => _parentMap;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;

  getAllParent() async {
    listener = await parentCollectionRef.snapshots().listen((value) {
      selectedColor = secondaryColor;
      _parentMap.clear();
      plutoKey = GlobalKey();
      rows.clear();
      for (var element in value.docs) {
        // print("object");
        _parentMap[element.id] = ParentModel.fromJson(element.data());
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: element.id),
              data.keys.elementAt(1): PlutoCell(value: ParentModel.fromJson(element.data()).fullName),
              data.keys.elementAt(2): PlutoCell(value: ParentModel.fromJson(element.data()).children?.length ?? '0'),
              data.keys.elementAt(3): PlutoCell(value: ParentModel.fromJson(element.data()).address),
              data.keys.elementAt(4): PlutoCell(value: ParentModel.fromJson(element.data()).nationality),
              data.keys.elementAt(5): PlutoCell(value: ParentModel.fromJson(element.data()).work),
              data.keys.elementAt(6): PlutoCell(value: ParentModel.fromJson(element.data()).startDate),
              data.keys.elementAt(7): PlutoCell(value: ParentModel.fromJson(element.data()).motherPhone),
              data.keys.elementAt(8): PlutoCell(value: ParentModel.fromJson(element.data()).emergencyPhone),
              data.keys.elementAt(9): PlutoCell(value: ParentModel.fromJson(element.data()).totalPayment),
              data.keys.elementAt(10): PlutoCell(value: ParentModel.fromJson(element.data()).eventRecords?.length ?? "0"),
              data.keys.elementAt(11): PlutoCell(value: ParentModel.fromJson(element.data()).isAccepted == true ? "تمت الموافقة".tr : "في انتظار الموافقة".tr),
            },
          ),
        );
      }
      print("Parents :${_parentMap.values.length}");
      update();
    });
  }

  Color selectedColor = secondaryColor;

  addParent(ParentModel parentModel) {
    parentCollectionRef.doc(parentModel.id).set(parentModel.toJson(), SetOptions(merge: true));
    update();
  }

  updateParent(ParentModel parentModel) async {
    await parentCollectionRef.doc(parentModel.id).set(parentModel.toJson(), SetOptions(merge: true));
    update();
  }

  deleteParent(String parentId, List studentList) async {
    await addWaitOperation(
        userName: currentEmployee?.userName.toString()??"",

        type: waitingListTypes.delete,
        collectionName: parentsCollection,
        affectedId: parentId,
        relatedList: studentList
            .map(
              (e) => e.toString(),
            )
            .toList());
    update();
  }

  getOldParent(String value) async {
    await firebaseFirestore.collection(archiveCollection).doc(value).collection(parentsCollection).get().then((value) {
      _parentMap.clear();
      plutoKey = GlobalKey();
      rows.clear();
      for (var element in value.docs) {
        _parentMap[element.id] = ParentModel.fromJson(element.data());
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: element.id),
              data.keys.elementAt(1): PlutoCell(value: ParentModel.fromJson(element.data()).fullName),
              data.keys.elementAt(2): PlutoCell(value: ParentModel.fromJson(element.data()).children?.length ?? '0'),
              data.keys.elementAt(3): PlutoCell(value: ParentModel.fromJson(element.data()).address),
              data.keys.elementAt(4): PlutoCell(value: ParentModel.fromJson(element.data()).nationality),
              data.keys.elementAt(5): PlutoCell(value: ParentModel.fromJson(element.data()).work),
              data.keys.elementAt(6): PlutoCell(value: ParentModel.fromJson(element.data()).startDate),
              data.keys.elementAt(7): PlutoCell(value: ParentModel.fromJson(element.data()).motherPhone),
              data.keys.elementAt(8): PlutoCell(value: ParentModel.fromJson(element.data()).emergencyPhone),
              data.keys.elementAt(9): PlutoCell(value: ParentModel.fromJson(element.data()).totalPayment),
              data.keys.elementAt(10): PlutoCell(value: ParentModel.fromJson(element.data()).eventRecords?.length ?? "0"),
              data.keys.elementAt(11): PlutoCell(value: ParentModel.fromJson(element.data()).isAccepted == true ? "تمت الموافقة".tr : "في انتظار الموافقة".tr),
            },
          ),
        );
      }
      print("Parents :${_parentMap.values.length}");
      update();
    });
  }

  double getAllTotalPay() {
    double total = 0.0;
    _parentMap.values.forEach(
      (element) {
        total += element.totalPayment!;
      },
    );
    return total;
  }

  void deleteStudent(String parentId, String studentID) {
    _parentMap[parentId]!.children!.removeWhere(
          (element) => element == studentID,
        );
    parentCollectionRef.doc(parentId).set({"children": _parentMap[parentId]!.children!}, SetOptions(merge: true));
  }

  int installmentCount = 0;
  List<TextEditingController> monthsController = [];
  List<TextEditingController> costsController = [];

  initController() {
    parent = parentMap[currentId];
    if (parent != null) {
      payWay = parent!.paymentWay ?? '';
      fullNameController.text = parent!.fullName.toString();
      numberController.text = parent!.phoneNumber.toString();
      addressController.text = parent!.address.toString();
      nationalityController.text = parent!.nationality.toString();
      startDateController.text = parent!.startDate.toString();
      motherPhoneNumberController.text = parent!.motherPhone.toString();
      emergencyPhoneController.text = parent!.emergencyPhone.toString();
      workController.text = parent!.work.toString();
      eventRecords = parent!.eventRecords ?? [];
      idNumController.text = parent!.parentID ?? '';
      instalmentMap = {};
      instalmentMap .addAll( parent!.installmentRecords!);
      print(instalmentMap.values.length);
      monthsController = List.generate(
        parent?.installmentRecords?.values.length ?? 0,
        (index) => TextEditingController()..text = parent!.installmentRecords!.values.elementAt(index).installmentDate.toString(),
      );
      costsController = List.generate(
        parent?.installmentRecords?.length ?? 0,
        (index) => TextEditingController()..text = parent!.installmentRecords!.values.elementAt(index).installmentCost.toString(),
      );
    }
    update();
  }

  addInstalment() {
    String installmentId = generateId("INSTALLMENT");
    instalmentMap[installmentId] = InstallmentModel(installmentId: installmentId, installmentCost: "0", installmentDate: DateTime.now().month.toString().padLeft(2, "0"), isPay: false);
    monthsController.add(TextEditingController()..text =DateTime.now().month.toString().padLeft(2, "0"),);
    costsController.add(TextEditingController()..text = "0");
    update();
  }

  Future<void> saveParentData(BuildContext context) async {
    // تحقق من صحة الحقول
    if (!validateFields(
      requiredControllers: [
        fullNameController,
        numberController,
        addressController,
        nationalityController,
        numberController,
        startDateController,
        motherPhoneNumberController,
        emergencyPhoneController,
        workController,
        idNumController,
      ],
      numericControllers: [
        numberController,
        motherPhoneNumberController,
        idNumController,
      ],
    )) {
      return;
    }

    loadingQuickAlert(context);
    try {
      // تحميل الصور
      List<String> uploadedContracts = await uploadImages(contractsTemp, "contracts");
      for (int index = 0; index < instalmentMap.length; index++) {
        instalmentMap[instalmentMap.keys.elementAt(index)] = InstallmentModel(
          installmentCost: costsController[index].text,
          installmentDate: monthsController[index].text,
          installmentId: instalmentMap.keys.elementAt(index),
          isPay: parent != null ? parent!.installmentRecords!.values.toList()[index].isPay! : false,
        );
      }
      contracts.addAll(uploadedContracts);


      ParentModel parentModel = ParentModel(
        nationality: nationalityController.text,
        contract: contracts,
        isAccepted: parent == null ? true : false,
        parentID: idNumController.text,
        id: parent == null ? generateId("PARENT") : parent!.id.toString(),
        fullName: fullNameController.text,
        address: addressController.text,
        work: workController.text,
        emergencyPhone: emergencyPhoneController.text,
        motherPhone: motherPhoneNumberController.text,
        phoneNumber: numberController.text,
        eventRecords: eventRecords,
        startDate: startDateController.text,
        children: parent == null ? null : parent!.children,
        paymentWay: payWay,
        installmentRecords: instalmentMap,
      );

      // إضافة عملية الانتظار إذا كانت العملية تحديث
      print(parent?.installmentRecords?.values.map((e) => e.toJson(),));
      print(instalmentMap.values.map((e) => e.toJson(),));
      // Get.back();
      // return;
      if (parent != null) {
        await addWaitOperation(
          userName: currentEmployee?.userName.toString()??"",

          collectionName: parentsCollection,
          affectedId: parent!.id.toString(),
          type: waitingListTypes.edite,
          newData: parentModel.toJson(),
          oldData: parent!.toJson(),
          details: editController.text,
        );
      }

      await Get.find<ParentsViewModel>().addParent(parentModel);

      clearController();

      // إخفاء حوارات التحميل والنجاح
      Get.back();

      Get.back();
    } catch (e) {
      print('Error: $e');
      getReedOnlyError(title: "حدث خطأ أثناء حفظ البيانات. حاول مرة أخرى.", context);
      Get.back();
    }
  }

  String payWay = '';

  final List<String> payWays = [
    'كاش',
    'اقساط',
    'كريدت',
  ];

  clearController() {
    parent = null;
    currentId = '';
    payWay = '';
    fullNameController.clear();
    numberController.clear();
    addressController.clear();
    nationalityController.clear();
    startDateController.clear();
    motherPhoneNumberController.clear();
    bodyEventController.clear();
    emergencyPhoneController.clear();
    idNumController.clear();
    workController.clear();
    eventRecords.clear();
    editController.clear();
    selectedEvent = null;
    contracts = [];
    contractsTemp = [];
    monthsController.clear();
    costsController.clear();
    monthsController.clear();
    costsController.clear();
    instalmentMap = {};
    addInstalment();
  }

  String currentId = '';

  bool getIfDelete() {
    return checkIfPendingDelete(affectedId: currentId);
  }

  bool isAdd = false;

  void addEventRecord() async {
    final value = TimesModel.fromDateTime(DateTime.now());
    eventRecords.add(EventRecordModel(
      body: bodyEventController.text,
      type: selectedEvent!.name,
      date: value.dateTime.toString().split(" ")[0],
      color: selectedEvent!.color.toString(),
    ));
    bodyEventController.clear();
    update();
  }

  double getAllReceivePay() {
    double total = 0;
    _parentMap.values.forEach(
      (element) {
        element.installmentRecords!.values.forEach(
          (element0) {
            if (element0.isPay == true) {
              total += int.parse(element0.installmentCost!);
            }
          },
        );
      },
    );

    return total;
  }

  showParentInputDialog(BuildContext context) async {
    initController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Dialog(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: ParentInputForm()),
        );
      },
    );
  }

  int getAllNunReceivePay() {
    int total = 0;
    _parentMap.values.forEach(
      (element) {
        element.installmentRecords!.values.forEach(
          (element0) {
            if (element0.isPay != true) {
              total += int.parse(element0.installmentCost!);
            }
          },
        );
      },
    );
    return total;
  }

  int getAllNunReceivePayThisMonth() {
    int total = 0;
    _parentMap.values.forEach(
      (element) {
        element.installmentRecords!.values.forEach(
          (element0) {
            if (int.parse(element0.installmentDate!) <= thisTimesModel!.month && element0.isPay != true) {
              total += int.parse(element0.installmentCost!);
            }
          },
        );
      },
    );
    return total;
  }

  double getAllReceiveMaxPay() {
    double total = 0;
    _parentMap.values.forEach(
      (element) {
        element.installmentRecords!.values.forEach(
          (element0) {
            if (element0.isPay == true) {
              if (int.parse(element0.installmentCost!) > total) total = int.parse(element0.installmentCost!) * 1.0;
            }
          },
        );
      },
    );
    return total + 50000;
  }

  double getAllReceivePayAtMonth(String month) {
    double total = 0;
    _parentMap.values.forEach(
      (element) {
        element.installmentRecords!.values.forEach(
          (element0) {
            if (element0.installmentDate! == month && element0.isPay == true) {
              total += int.parse(element0.installmentCost!);
            }
          },
        );
      },
    );
    return total;
  }

  setInstallmentPay({required String installmentId, required String parentId, required bool isPay, required String imageUrl}) async {
    // DateTime dateTime= await NTP.now();
    TimesModel timesModel = TimesModel.fromDateTime(DateTime.now());
    Map<String, InstallmentModel>? installmentRecords = _parentMap[parentId]!.installmentRecords;
    installmentRecords![installmentId]!.isPay = isPay;
    installmentRecords[installmentId]!.InstallmentImage = imageUrl;
    installmentRecords[installmentId]!.payTime = timesModel.dateTime.toString();
    parentCollectionRef.doc(parentId).set(ParentModel(installmentRecords: installmentRecords).toJson(), SetOptions(merge: true));
  }

  bool chekaIfHaveLateInstallment(String parentId) {
    bool isLate = false;
    _parentMap[parentId]!.installmentRecords!.entries.forEach(
      (element) {
        if (int.parse(element.value.installmentDate!) <= DateTime.now().month && element.value.isPay != true) {
          isLate = true;
        }
      },
    );
    return isLate;
  }

  Future<void> showDeleteConfirmationDialog(WaitManagementViewModel _, BuildContext context) async {
    TextEditingController editController = TextEditingController();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      widget: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            controller: editController,
            title: "سبب الحذف".tr,
            size: Get.width / 4,
          ),
        ),
      ),
      text: 'قبول هذه العملية'.tr,
      title: 'هل انت متأكد ؟'.tr,
      onConfirmBtnTap: () async {
        await addWaitOperation(
          type: waitingListTypes.delete,
          collectionName: parentsCollection,
          affectedId: parentMap[currentId]!.id!,
          details: editController.text,
          userName: currentEmployee?.userName.toString()??"",

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

  void setCurrentId(value) {
    currentId = value;
    update();
  }

  void foldScreen() {
    clearController();
    isAdd = !isAdd;
    update();
  }
}
