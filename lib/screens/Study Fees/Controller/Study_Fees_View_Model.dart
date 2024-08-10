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
    "الاولاد": PlutoColumnType.select([]),
    "المستلم": PlutoColumnType.text(),
    "المتأخر": PlutoColumnType.text(),
    "المستحق": PlutoColumnType.text(),
    "كامل المبلغ": PlutoColumnType.text(),
  };
  GlobalKey plutoKey = GlobalKey();
  String currentId = '';

  Color selectedColor = secondaryColor;

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
    currentId = '';
    update();
  }

  ParentsViewModel parentsViewModel = Get.find<ParentsViewModel>();
  StudentViewModel studentController = Get.find<StudentViewModel>();

  getParentFees() {
    rows.clear();
    selectedColor = secondaryColor;
    plutoKey = GlobalKey();
    parentController.parentMap.values.forEach((parent) {
      if (filterParentsByIndex(parent)) {
        int totalPayment = calculateTotalPayment(parent);
        int payment = calculatePayment(parent);
        int latPayment = calculateLatePayment(parent);

        rows.add(PlutoRow(
          cells: {
            data.keys.elementAt(0): PlutoCell(value: parent.id.toString()),
            data.keys.elementAt(1): PlutoCell(value: parent.fullName.toString()),
            data.keys.elementAt(2): PlutoCell(value: parent.children!.isEmpty ? "لا يوجد" : parent.children?.map((e) => studentController.studentMap[e]?.studentName).toList()),
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

  bool filterParentsByIndex(ParentModel parent) {
    if (inkwellIndex == 0) {
      return parent.installmentRecords?.values.any((record) => record.isPay != true) ?? false;
    } else if (inkwellIndex == 1) {
      return parent.installmentRecords?.values.any((record) => record.isPay == true) ?? false;
    } else if (inkwellIndex == 2) {
      return parent.installmentRecords?.values.any((record) => int.parse(record.installmentDate!) <= thisTimesModel!.month && record.isPay != true) ?? false;
    } else {
      return (parent.installmentRecords?.length ?? 0) > 0;
    }
  }

  int calculateTotalPayment(ParentModel parent) {
    return parent.totalPayment ?? 0;
  }

  int calculatePayment(ParentModel parent) {
    return parent.installmentRecords?.values.where((record) => record.isPay == true).fold(0, (sum, record) => (sum ?? 0) + int.parse(record.installmentCost.toString())) ?? 0;
    // return parent.children?.expand((child) => parent.installmentRecords?.values.where((record) => record.isPay == true) ?? [InstallmentModel(installmentCost: "0")]).fold(0, (sum, record) => (sum ?? 0) + int.parse(record.installmentCost.toString())) ?? 0;
  }

  int calculateLatePayment(ParentModel parent) {
    return parent.installmentRecords?.values
            .where(
              (record) => record.isPay != true && int.parse(record.installmentDate!) <= thisTimesModel!.month,
            )
            .fold(0, (sum, record) => (sum ?? 0) + int.parse(record.installmentCost.toString())) ??
        0;
  }

  showInstallmentDialog(BuildContext context) {
    Map<String, InstallmentModel> installmentStudent = parentsViewModel.parentMap[currentId]!.installmentRecords!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<ParentsViewModel>(builder: (parentController) {
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
                        InstallmentModel installment = installmentStudent.values.elementAt(parentIndex);
                        bool isLate = int.parse(installment.installmentDate!) > DateTime.now().month;
                        Uint8List? _contractsTemp;
                        String? imageURL = installment.InstallmentImage;
                        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 2.0,
                                          color: isLate && installment.isPay != true
                                              ? Colors.red.withOpacity(0.5)
                                              : installment.isPay == true
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
                                          controller: TextEditingController()..text = installment.installmentDate.toString(),
                                          title: 'الشهر'.tr,
                                          enable: false,
                                          size: max(140, Get.width / 10),
                                          isFullBorder: true,
                                        ),
                                        CustomTextField(
                                          controller: TextEditingController()..text = installment.installmentCost.toString(),
                                          title: "الدفعة".tr,
                                          enable: false,
                                          size: max(140, Get.width / 10),
                                          isFullBorder: true,
                                        ),
                                        if (installment.isPay != true)
                                          InkWell(
                                            onTap: () async {
                                              FilePickerResult? _ = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
                                              if (_ != null) {
                                                _.files.forEach(
                                                  (element) async {
                                                    if (element.bytes != null) _contractsTemp = element.bytes!;
                                                  },
                                                );

                                                update();
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
                                        if (installment.isPay == true)
                                          ImageOverlay(
                                            imageUrl: imageURL!,
                                            imageHeight: 50,
                                            imageWidth: max(140, Get.width / 10),
                                          ),
                                        if (installment.isPay != true)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: AppButton(
                                              onPressed: () async {
                                                await getConfirmDialog(context, onConfirm: () async {
                                                  if (_contractsTemp != null)
                                                    await uploadImages([_contractsTemp!], "contracts").then(
                                                      (value) => imageURL = value.first,
                                                    );
                                                  parentController.setInstallmentPay(installmentId: installment.installmentId!, parentId: currentId, isPay: true, imageUrl: imageURL!);
                                                  Get.back();
                                                });

                                                //
                                              },
                                              text: "تسديد!".tr,
                                            ),
                                          )
                                        else
                                          GetBuilder<WaitManagementViewModel>(builder: (deleteController) {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: AppButton(
                                                text: checkIfPendingDelete(affectedId: installment.installmentId!) ? 'في انتظار الموفقة..'.tr : "تراجع".tr,
                                                onPressed: () {
                                                  if (checkIfPendingDelete(affectedId: installment.installmentId!))
                                                    QuickAlert.show(context: context, type: QuickAlertType.info, width: Get.width / 2, title: "مراجعة المسؤول".tr, text: "يرجى مراجعة مسؤول المنصة".tr);
                                                  else
                                                    getConfirmDialog(
                                                      context,
                                                      onConfirm: () {
                                                        addWaitOperation(type: waitingListTypes.returnInstallment, collectionName: installmentCollection, affectedId: installment.installmentId!, relatedId: installmentStudent.keys.elementAt(parentIndex));
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
