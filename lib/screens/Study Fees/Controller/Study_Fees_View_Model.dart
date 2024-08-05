import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';

import '../../../constants.dart';
import '../../../controller/Wait_management_view_model.dart';
import '../../../core/Styling/app_style.dart';
import '../../../core/Utils/service.dart';
import '../../../models/Installment_model.dart';
import '../../../models/Parent_Model.dart';
import '../../../utils/Dialogs.dart';
import '../../../utils/Image_OverLay.dart';
import '../../../utils/To_AR.dart';
import '../../Student/Controller/Student_View_Model.dart';
import '../../Widgets/AppButton.dart';
import '../../Widgets/Custom_Text_Filed.dart';

class StudyFeesViewModel extends GetxController {
  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "الاسم الكامل": PlutoColumnType.text(),
    "الاولاد": PlutoColumnType.text(),
    "المستلم": PlutoColumnType.text(),
    "المتأخر": PlutoColumnType.text(),
    "المستحق": PlutoColumnType.text(),
    "كامل المبلغ": PlutoColumnType.text(),
  };
  GlobalKey plutoKey = GlobalKey();
  String currentId = '';

  Color selectedColor=secondaryColor;

  void setCurrentId(value) {
    currentId = value;
    update();
  }

  ///pluto header
  List<PlutoColumn> columns = [];

  /// pluto data
  List<PlutoRow> rows = [];

  StudyFeesViewModel() {
    getColumns();
  }

  /// Refresh pluto header when change language
  getColumns() {
    columns.clear();
    columns.addAll(toAR(data));
  }

  ParentsViewModel parentController = Get.find<ParentsViewModel>();
  int inkwellIndex = 3;

  setInkwellIndex(index) {
    inkwellIndex = index;
    getParentFees();
    update();
  }
  ParentsViewModel parentsViewModel = Get.find<ParentsViewModel>();

  StudentViewModel studentController = Get.find<StudentViewModel>();

  getParentFees() {
    rows.clear();
    selectedColor=secondaryColor;
    plutoKey = GlobalKey();
    parentController.parentMap.values.forEach((parent) {
      if (filterParentsByIndex(parent, studentController)) {
        int totalPayment = calculateTotalPayment(parent, studentController);
        int payment = calculatePayment(parent, studentController);
        int latPayment = calculateLatePayment(parent, studentController);

        rows.add(PlutoRow(
          cells: {
            data.keys.elementAt(0): PlutoCell(value: parent.id.toString()),
            data.keys.elementAt(1): PlutoCell(value: parent.fullName.toString()),
            data.keys.elementAt(2): PlutoCell(value: parent.children?.map((e) => studentController.studentMap[e]?.studentName).toString()),
            data.keys.elementAt(3): PlutoCell(value: "$payment درهم"),
            data.keys.elementAt(4): PlutoCell(value: "$latPayment درهم"),
            data.keys.elementAt(5): PlutoCell(value: "${totalPayment - payment} درهم"),
            data.keys.elementAt(6): PlutoCell(value: "${totalPayment} درهم"),
          },
        ));
      }
    });
    update();
  }

  bool filterParentsByIndex(ParentModel parent, StudentViewModel studentController) {
    if (inkwellIndex == 0) {
      return parent.children?.any((child) => studentController.studentMap[child]?.installmentRecords?.values.any((record) => record.isPay != true) ?? false) ?? false;
    } else if (inkwellIndex == 1) {
      return parent.children?.any((child) => studentController.studentMap[child]?.installmentRecords?.values.any((record) => record.isPay == true) ?? false) ?? false;
    } else if (inkwellIndex == 2) {
      return parent.children?.any((child) => studentController.studentMap[child]?.installmentRecords?.values.any((record) => int.parse(record.installmentDate!) <= thisTimesModel!.month && record.isPay != true) ?? false) ?? false;
    } else {
      return (parent.children?.length ?? 0) > 0;
    }
  }

  int calculateTotalPayment(ParentModel parent, StudentViewModel studentController) {
    return parent.children?.map((child) => studentController.studentMap[child]?.totalPayment ?? 0).fold(0, (sum, payment) => (sum ?? 0) + payment) ?? 0;
  }

  int calculatePayment(ParentModel parent, StudentViewModel studentController) {
    return parent.children?.expand((child) => studentController.studentMap[child]?.installmentRecords?.values.where((record) => record.isPay == true) ?? [InstallmentModel(installmentCost: "0")]).fold(0, (sum, record) => (sum ?? 0) + int.parse(record.installmentCost.toString())) ?? 0;
  }

  int calculateLatePayment(ParentModel parent, StudentViewModel studentController) {
    return parent.children
            ?.expand((child) =>
                studentController.studentMap[child]?.installmentRecords?.values.where(
                  (record) => record.isPay != true && int.parse(record.installmentDate!) <= thisTimesModel!.month,
                ) ??
                [InstallmentModel(installmentCost: "0")])
            .fold(0, (sum, record) => (sum ?? 0) + int.parse(record.installmentCost.toString())) ??
        0;
  }

   showInstallmentDialogForParent(BuildContext context) {
    Map<String, List<InstallmentModel>> instalmentStudent = {};

    for (var child in parentsViewModel.parentMap[currentId]?.children ?? []) {
      instalmentStudent[child] = studentController.studentMap[child]?.installmentRecords?.values.toList() ?? [];
    }

    showInstallmentDialog(context, instalmentStudent);
  }

  void showInstallmentDialog(BuildContext context, Map<String, List<InstallmentModel>> installmentStudent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<StudentViewModel>(builder: (studentController) {
          return Dialog(
            backgroundColor: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Container(
              width: Get.width / 2,
              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                children: [
                  Center(child: Text('سجل الدفعات'.tr, style: AppStyles.headLineStyle1)),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(
                            height: defaultPadding,
                          ),
                      physics: ClampingScrollPhysics(),
                      itemCount: installmentStudent.length,
                      itemBuilder: (context, parentIndex) {
                        List<InstallmentModel> installment = installmentStudent.values
                            .elementAt(parentIndex) /*.where((element) => element.isPay!=true,)*/
                            .toList();
                        return Container(
                          alignment: Alignment.center,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: installment.length,
                            itemBuilder: (context, index) {
                              bool isLate = int.parse(installment[index].installmentDate!) <= thisTimesModel!.month;
                              Uint8List? _contractsTemp;
                              String? imageURL = installment[index].InstallmentImage;
                              return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (index == 0)
                                        Text(
                                          studentController.studentMap[installmentStudent.keys.elementAt(parentIndex)]!.studentName!,
                                          style: AppStyles.headLineStyle2,
                                        ),
                                      if (index == 0)
                                        SizedBox(
                                          height: defaultPadding,
                                        ),
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                                width: 2.0,
                                                color: isLate && installment[index].isPay != true
                                                    ? Colors.red.withOpacity(0.5)
                                                    : installment[index].isPay == true
                                                        ? Colors.green.withOpacity(0.5)
                                                        : primaryColor.withOpacity(0.5))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                                          child: Wrap(
                                            alignment: WrapAlignment.spaceBetween,
                                            // spacing: 25,
                                            runSpacing: 25,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomTextField(
                                                controller: TextEditingController()..text = installment[index].installmentDate.toString(),
                                                title: 'الشهر'.tr,
                                                enable: false,
                                                size: max(140, Get.width / 10),
                                                isFullBorder: true,
                                              ),
                                              CustomTextField(
                                                controller: TextEditingController()..text = installment[index].installmentCost.toString(),
                                                title: "الدفعة".tr,
                                                enable: false,
                                                size: max(140, Get.width / 10),
                                                isFullBorder: true,
                                              ),
                                              if (installment[index].isPay != true)
                                                InkWell(
                                                  onTap: () async {
                                                    FilePickerResult? _ = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
                                                    if (_ != null) {
                                                      _.files.forEach(
                                                        (element) async {
                                                          if (element.bytes != null) _contractsTemp = element.bytes!;
                                                        },
                                                      );

                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(color: secondaryColor.withOpacity(0.8), borderRadius: BorderRadius.circular(15)),
                                                      height: 50,
                                                      width: max(140, Get.width / 10),
                                                      child: _contractsTemp == null
                                                          ? Center(
                                                              child: Wrap(
                                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                                alignment: WrapAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "صورة السند".tr,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                  Icon(Icons.add),
                                                                ],
                                                              ),
                                                            )
                                                          : Container(
                                                              clipBehavior: Clip.hardEdge,
                                                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                                                              child: Image.memory(
                                                                (_contractsTemp!),
                                                                fit: BoxFit.cover,
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                              if (installment[index].isPay == true)
                                                ImageOverlay(
                                                  imageUrl: imageURL!,
                                                  imageHeight: 50,
                                                  imageWidth: max(140, Get.width / 10),
                                                ),
                                              if (installment[index].isPay != true)
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: AppButton(
                                                    onPressed: () async {
                                                      getConfirmDialog(context, onConfirm: () async {
                                                        if (_contractsTemp != null)
                                                          await uploadImages([_contractsTemp!], "contracts").then(
                                                            (value) => imageURL = value.first,
                                                          );
                                                        studentController.setInstallmentPay(installment[index].installmentId!, installmentStudent.keys.elementAt(parentIndex), true, imageURL!);
                                                        Get.back();
                                                      });

                                                      Get.back();
                                                    },
                                                    text: "تسديد!"
                                                        .tr, /*Row(
                                                  children: [
                                                    Text(
                                                      "تسديد!".tr,
                                                      style: Styles.headLineStyle3
                                                          .copyWith(
                                                              color:
                                                                  primaryColor),
                                                    ),
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.blue,
                                                    )
                                                  ],
                                                )*/
                                                  ),
                                                )
                                              else
                                                GetBuilder<WaitManagementViewModel>(builder: (deleteController) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: AppButton(
                                                      text: checkIfPendingDelete(affectedId: installment[index].installmentId!) ? 'في انتظار الموفقة..'.tr : "تراجع".tr,
                                                      onPressed: () {
                                                        if (checkIfPendingDelete(affectedId: installment[index].installmentId!))
                                                          QuickAlert.show(context: context, type: QuickAlertType.info, width: Get.width / 2, title: "مراجعة المسؤول".tr, text: "يرجى مراجعة مسؤول المنصة".tr);
                                                        else
                                                          getConfirmDialog(
                                                            context,
                                                            onConfirm: () {
                                                              addWaitOperation(type: waitingListTypes.returnInstallment, collectionName: installmentCollection, affectedId: installment[index].installmentId!, relatedId: installmentStudent.keys.elementAt(parentIndex));
                                                            },
                                                          );
                                                      },
                                                    ),
                                                  );
                                                }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                          ),
                        );
                      }),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Center(
                      child: AppButton(
                    text: "حفظ".tr,
                    onPressed: () {
                      Get.back();
                    },
                  )),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
