import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/models/Installment_model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/utils/Image_OverLay.dart';

import '../../constants.dart';
import '../../controller/home_controller.dart';
import '../../models/Parent_Model.dart';
import '../../utils/Dialogs.dart';
import '../Parents/Controller/Parents_View_Model.dart';
import '../Widgets/Custom_Text_Filed.dart';
import '../Widgets/Square_Widget.dart';
import '../Widgets/expanded_data_row.dart';
import '../Widgets/header.dart';

class StudyFeesView extends StatefulWidget {
  const StudyFeesView({super.key});

  @override
  State<StudyFeesView> createState() => _StudyFeesViewState();
}

class _StudyFeesViewState extends State<StudyFeesView> {
  List data = [
    "الاسم الكامل",
    "الاولاد",
    "المستلم",
    "المبلغ الكامل",
    "المستحق",
    "الحالة",
  ];
  final ScrollController _scrollController = ScrollController();

  int inkwellIndex = 3;
  ParentsViewModel parentsViewModel = Get.find<ParentsViewModel>();

  // StudentViewModel studentViewModel = Get.find<StudentViewModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentViewModel>(builder: (studentViewModel) {
      return Scaffold(
        appBar: Header(context: context, title: 'الرسوم الدراسية'.tr, middleText: "تعرض هذه الواجهة اجمالي ادفعات المستلمة من الطلاب و اجمالي الدفعات الخير مستلمة واجمالي الدفعات المتأخرة عن الدفع عن هذا الشهر مع جدول يوضح تفاصيل الدفعات لكل اب مع امكانية استلام دفعة او التراجع عنها".tr),
        body: SingleChildScrollView(
          child: GetBuilder<HomeViewModel>(builder: (controller) {
            double size = max(MediaQuery.sizeOf(context).width - (controller.isDrawerOpen ? 240 : 120), 1000) - 60;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width,
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: MediaQuery.sizeOf(context).width < 800 ? WrapAlignment.center : WrapAlignment.spaceEvenly,
                      runSpacing: 25,
                      spacing: 10,
                      children: [
                        InkWell(
                            onTap: () {
                              inkwellIndex = 0;
                              setState(() {});
                            },
                            child: SquareWidget(title: "الدفعات القادمة", body: "${studentViewModel.getAllNunReceivePay()}", color: primaryColor, png: "assets/poor.png")),
                        InkWell(
                            onTap: () {
                              inkwellIndex = 1;
                              setState(() {});
                            },
                            child: SquareWidget(title: "الدفعات المستلمة", body: "${studentViewModel.getAllReceivePay()}", color: blueColor, png: "assets/profit.png")),
                        InkWell(
                            onTap: () {
                              inkwellIndex = 2;
                              setState(() {});
                            },
                            child: SquareWidget(title: "الدفعات المتأخرة", body: "${studentViewModel.getAllNunReceivePayThisMonth()}", color: Colors.redAccent, png: "assets/late-payment.png")),
                        InkWell(
                            onTap: () {
                              inkwellIndex = 3;
                              setState(() {});
                            },
                            child: SquareWidget(title: "الاجمالي", body: "${studentViewModel.getAllTotalPay()}", color: Colors.black, png: "assets/budget.png")),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                  Container(
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox(
                      width: size + 60,
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              columnSpacing: 0,
                              dividerThickness: 0.3,
                              columns: List.generate(data.length, (index) => DataColumn(label: Container(width: size / data.length, child: Center(child: Text(data[index].toString().tr))))),
                              rows: generateDataRows(inkwellIndex, size, data, studentViewModel, parentsViewModel)

                              /*[
                                      ...List.generate(
                                        parentController.parentMap.values
                                            .where(
                                              (element) {

                                                if(inkwellIndex==0)
                                            return    element.children?.where((element) =>  studentController
                                                    .studentMap[element]!.installmentRecords?.entries.where((element0) {
                                              return  element0.value.isPay!=true;
                                                    },).isNotEmpty??false,).toList().isNotEmpty??false;
                                                else  if(inkwellIndex==1)
                                                  return    element.children?.where((element) =>  studentController
                                                      .studentMap[element]!.installmentRecords?.entries.where((element0) {
                                                    return  element0.value.isPay==true;
                                                  },).isNotEmpty??false,).toList().isNotEmpty??false;
                                                else  if(inkwellIndex==2)
                                                  return    element.children?.where((element) =>  studentController
                                                      .studentMap[element]!.installmentRecords?.entries.where((element0) {
                                                    return  int.parse(element0.value.installmentDate!) <= DateTime.now().month &&
                                                        element0.value.isPay != true;
                                                  },).isNotEmpty??false,).toList().isNotEmpty??false;
                                                else
                                                return (element.children?.length ?? 0) >
                                                  0;
                                              },
                                            )
                                            .length,
                                        (index) {
                                          ParentModel parent =
                                              parentController.parentMap.values
                                                  .where(
                                                    (element) {

                                                  if(inkwellIndex==0)
                                                    return    element.children?.where((element) =>  studentController
                                                        .studentMap[element]!.installmentRecords?.entries.where((element0) {
                                                      return  element0.value.isPay!=true;
                                                    },).isNotEmpty??false,).toList().isNotEmpty??false;
                                                  else  if(inkwellIndex==1)
                                                    return    element.children?.where((element) =>  studentController
                                                        .studentMap[element]!.installmentRecords?.entries.where((element0) {
                                                      return  element0.value.isPay==true;
                                                    },).isNotEmpty??false,).toList().isNotEmpty??false;
                                                  else  if(inkwellIndex==2)
                                                    return    element.children?.where((element) =>  studentController
                                                        .studentMap[element]!.installmentRecords?.entries.where((element0) {
                                                      return  int.parse(element0.value.installmentDate!) <= DateTime.now().month &&
                                                          element0.value.isPay != true;
                                                    },).isNotEmpty??false,).toList().isNotEmpty??false;
                                                  else
                                                    return (element.children?.length ?? 0) >
                                                        0;
                                                },
                                                  )
                                                  .toList()[index];
                                          int payment = 0;
                                          int totalPayment = 0;
                                          for (var pat in parent.children
                                              ?.map((e) => studentController
                                                  .studentMap[e]!.totalPayment)
                                              .toList()??[0]) {
                                            totalPayment += (pat??0);
                                          }
                                          for (var pat in parent.children
                                              ?.map((e) => studentController
                                                  .studentMap[e]
                                                  ?.installmentRecords
                                                  ?.values
                                                  .where(
                                                    (element) =>
                                                        element.isPay == true,
                                                  )
                                                  .toList())
                                              .toList()??[])

                                          {
                                            for (var pay in pat ?? []) {
                                              payment += int.parse(
                                                  pay.installmentCost.toString());
                                            }
                                          }
                                          return DataRow(
                                              color: WidgetStatePropertyAll(
                                                  studentController
                                                          .chekaIfHaveLateInstallment(
                                                              parent.id!)
                                                      ? Colors.redAccent
                                                          .withOpacity(0.2)
                                                      : Colors.transparent),
                                              cells: [
                                                dataRowItem(size / data.length,
                                                    parent.fullName.toString()),
                                                dataRowItem(
                                                    size / data.length,
                                                    parent.children
                                                        ?.map(
                                                          (e) => studentController
                                                              .studentMap[e]!
                                                              .studentName,
                                                        )
                                                        .toString()),
                                                dataRowItem(size / data.length,
                                                    "$payment درهم ".toString()),
                                                dataRowItem(size / data.length,
                                                    "$totalPayment درهم"),
                                                dataRowItem(size / data.length,
                                                    "${totalPayment - payment} درهم"),
                                                dataRowItem(
                                                    size / data.length,
                                                    payment - totalPayment >= 0
                                                        ? "تم استلام كامل المبلغ".tr
                                                        : "اضافة دفعة".tr,
                                                    color: payment - totalPayment >=
                                                            0
                                                        ? blueColor
                                                        : Colors.green, onTap: () {
                                                  Map<String,
                                                          List<InstallmentModel>>
                                                      instalmentStudent = {};

                                                  for (var child
                                                      in parent.children!) {
                                                    //studentController.studentMap[child]!.studentName!
                                                    instalmentStudent[child] = [];
                                                    studentController
                                                        .studentMap[child]!
                                                        .installmentRecords!
                                                        .values
                                                        .forEach(
                                                      (element) {
                                                        instalmentStudent[child]!
                                                            .add(element);
                                                      },
                                                    );
                                                  }

                                                  showInstallmentDialog(
                                                      context, instalmentStudent);
                                                }),
                                              ]);
                                        },
                                      )
                                    ]*/
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  List<DataRow> generateDataRows(int inkwellIndex, double size, List data, StudentViewModel studentController, ParentsViewModel parentController) {
    return parentController.parentMap.values.where((parent) => filterParentsByIndex(parent, inkwellIndex, studentController)).map((parent) {
      int totalPayment = calculateTotalPayment(parent, studentController);
      int payment = calculatePayment(parent, studentController);

      return DataRow(
        color: WidgetStatePropertyAll(
          studentController.chekaIfHaveLateInstallment(parent.id ?? "") ? Colors.redAccent.withOpacity(0.2) : Colors.transparent,
        ),
        cells: [
          dataRowItem(size / data.length, parent.fullName.toString()),
          dataRowItem(
            size / data.length,
            parent.children?.map((e) => studentController.studentMap[e]?.studentName).toString(),
          ),
          dataRowItem(size / data.length, "$payment درهم"),
          dataRowItem(size / data.length, "$totalPayment درهم"),
          dataRowItem(size / data.length, "${totalPayment - payment} درهم"),
          dataRowItem(
            size / data.length,
            payment - totalPayment >= 0 ? "تم استلام كامل المبلغ".tr : "اضافة دفعة".tr,
            color: payment - totalPayment >= 0 ? blueColor : Colors.green,
            onTap: () => showInstallmentDialogForParent(context, parent, studentController),
          ),
        ],
      );
    }).toList();
  }

  bool filterParentsByIndex(ParentModel parent, int inkwellIndex, StudentViewModel studentController) {
    if (inkwellIndex == 0) {
      return parent.children?.any((child) => studentController.studentMap[child]?.installmentRecords?.values.any((record) => record.isPay != true) ?? false) ?? false;
    } else if (inkwellIndex == 1) {
      return parent.children?.any((child) => studentController.studentMap[child]?.installmentRecords?.values.any((record) => record.isPay == true) ?? false) ?? false;
    } else if (inkwellIndex == 2) {
      return parent.children?.any((child) => studentController.studentMap[child]?.installmentRecords?.values.any((record) => int.parse(record.installmentDate ?? '0') <= thisTimesModel!.month && record.isPay != true) ?? false) ?? false;
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

  void showInstallmentDialogForParent(BuildContext context, ParentModel parent, StudentViewModel studentController) {
    Map<String, List<InstallmentModel>> instalmentStudent = {};

    for (var child in parent.children ?? []) {
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
                  Center(child: Text('سجل الدفعات'.tr, style: Styles.headLineStyle1)),
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
                                print(Get.width / 10);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (index == 0)
                                        Text(
                                          studentController.studentMap[installmentStudent.keys.elementAt(parentIndex)]!.studentName!,
                                          style: Styles.headLineStyle2,
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
