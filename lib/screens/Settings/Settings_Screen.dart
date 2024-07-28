import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';
import 'package:vision_dashboard/controller/expenses_view_model.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';
import 'package:vision_dashboard/screens/Exams/controller/Exam_View_Model.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Store/Controller/Store_View_Model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';
import 'package:vision_dashboard/screens/account_management/Employee_user_details.dart';
import 'package:vision_dashboard/screens/classes/Controller/Class_View_Model.dart';
import 'package:vision_dashboard/utils/const.dart';

import '../../constants.dart';
import '../../controller/Wait_management_view_model.dart';
import '../../controller/home_controller.dart';

import '../../models/delete_management_model.dart';
import '../../utils/Dialogs.dart';
import '../Widgets/Data_Row.dart';
import '../Widgets/header.dart';
import 'Controller/Settings_View_Model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ScrollController _scrollDeleteController = ScrollController();
  final ScrollController _scrollLogController = ScrollController();

  List<String> deleteData = [
    "نوع العملية",
    "التفاصيل",
    "الرمز التسلسلي المتأثر",
    "التصنيف المتأثر",
    "العمليات",
  ];
  List<String> editeData = [
    "البيانات القديمة",
    "البيانات الجديدة",
    "التفاصيل",
    "التصنيف المتأثر",
    "العمليات",
  ];
  List logData = [
    "نوع العملية",
    "التاريخ",
    "التفاصيل",
    "الرمز التسلسلي المتأثر",
    "التصنيف المتأثر",
    "الحالة",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
          context: context,
          title: 'ادارة المنصة'.tr,
          middleText:
              "تقوم هذه الواجهة بعرض الامور الاساسية في المنصة وهي المستخدمين وامكانية اضافة او تعديل او حذف كما تعرض السجلات الممطلوب حذفها للموافقة عليها او استرجاعها كما يمكن ارشفة بيانات السنة الحالية او حذف البيانات او العودة الى نسخة سابقة"
                  .tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: GetBuilder<HomeViewModel>(builder: (controller) {
          double size = max(
                  MediaQuery.sizeOf(context).width -
                      (controller.isDrawerOpen ? 240 : 120),
                  1000) -
              60;
          return Padding(
            padding: const EdgeInsets.all(15),
            child:
                GetBuilder<AccountManagementViewModel>(builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: defaultPadding,
                  ),
                    Text(
                      "تأكيد العمليات".tr,
                      style: Styles.headLineStyle1,
                    ),
                    Container(
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: GetBuilder<WaitManagementViewModel>(
                          builder: (controller) {
                        return SizedBox(
                            width: size + 60,
                            child: Scrollbar(
                              controller: _scrollDeleteController,
                              child: SingleChildScrollView(
                                controller: _scrollDeleteController,
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 0,
                                  dividerThickness: 0.3,
                                  columns: _buildColumns(size, deleteData),
                                  rows: _buildWaitRows(
                                      size, deleteData, controller),
                                ),
                              ),
                            ));
                      }),
                    ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    "سجلات العمليات".tr,
                    style: Styles.headLineStyle1,
                  ),
                  Container(
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: GetBuilder<WaitManagementViewModel>(
                        builder: (controller) {
                      return SizedBox(
                        width: size + 60,
                        child: Scrollbar(
                          controller: _scrollLogController,
                          child: SingleChildScrollView(
                            controller: _scrollLogController,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columnSpacing: 0,
                                dividerThickness: 0.3,
                                columns: List.generate(
                                    logData.length,
                                    (index) => DataColumn(
                                        label: Container(
                                            width: size / logData.length,
                                            child: Center(
                                                child: Text(logData[index]
                                                    .toString()
                                                    .tr))))),
                                rows: [
                                  for (var deleteModel
                                      in controller.allWaiting.values.where(
                                    (element) => element.isAccepted != null,
                                  ).toList().reversed)
                                    DataRow(cells: [
                                      dataRowItem(size / logData.length,
                                          deleteModel.type.toString().tr),
                                      dataRowItem(
                                          size / logData.length,
                                          deleteModel.date!
                                                  .split(" ")[1]
                                                  .split(".")[0] +
                                              " " +
                                              deleteModel.date!
                                                  .split(" ")[0]
                                                  .toString()),
                                      dataRowItem(size / logData.length,
                                          deleteModel.details ?? "لا يوجد".tr),
                                      dataRowItem(size / logData.length,
                                          _getAffectedName(deleteModel)),
                                      dataRowItem(
                                          size / logData.length,
                                          deleteModel.collectionName
                                              .toString()),
                                      dataRowItem(
                                        size / logData.length,
                                        deleteModel.isAccepted!
                                            ? 'مقبول'.tr
                                            : 'مرفوض'.tr,
                                        color: deleteModel.isAccepted!
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ]),
                                ]),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                  Text(
                    "الارشفة وحذف البيانات".tr,
                    style: Styles.headLineStyle1,
                  ),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: GetBuilder<SettingsViewModel>(builder: (controller) {
                      return Column(
                        children: [
                          Wrap(
                            runSpacing: 20,
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: 50,
                            children: [
                              CustomDropDown(
                                value: 'الافتراضي'.tr,
                                listValue: controller.allArchive
                                    .map(
                                      (e) => e.toString().tr,
                                    )
                                    .toList(),
                                label: "السنة المختارة".tr,
                                onChange: (value) {
                                  if (value != null) {
                                    if (value != "الافتراضي".tr) {
                                      controller.getOldData(value);
                                      enableUpdate = false;
                                      controller.update();
                                    } else {
                                      controller.getDefaultData();
                                      enableUpdate = true;
                                      controller.update();
                                    }
                                  }
                                },
                              ),
                              CustomDropDown(
                                value: Get.locale.toString() != "en_US"
                                    ? 'عربي'
                                    : 'English',
                                listValue: ['عربي', 'English'],
                                label: 'اختر اللغة'.tr,
                                onChange: (value) {
                                  Get.find<SettingsViewModel>()
                                      .changeLanguage(value!);
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: defaultPadding * 2,
                          ),
                          Wrap(
                            runSpacing: 20,
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: 50,
                            children: [
                              AppButton(
                                  text: "ارشفة البيانات الحالية".tr,
                                  onPressed: () async {
                                    bool _validateYearFormat(
                                        BuildContext context, String value) {


                                      final yearFormat =
                                          RegExp(r'^\d{4}-\d{4}$');
                                      if (!yearFormat.hasMatch(value)) {
                                        QuickAlert.show(
                                          cancelBtnText: "موافق".tr,
                                          context: context,
                                          type: QuickAlertType.error,
                                          title: 'يجب أن يكون التنسيق مثل 2024-2025'
                                              .tr,
                                          text: "يجب التأكد من البيانات".tr,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'يجب أن يكون التنسيق مثل 2024-2025'
                                                    .tr),
                                          ),
                                        );
                                        return false;
                                      } else
                                        return true;
                                    }

                                    TextEditingController yearNameController =
                                        TextEditingController();
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      widget: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: CustomTextField(
                                          controller: yearNameController,
                                          title: "ادخل اسم السنة".tr,
                                        ),
                                      ),
                                      text: 'قبول هذه العملية'.tr,
                                      title: 'هل انت متأكد ؟'.tr,
                                      onConfirmBtnTap: () async {


                                          if (_validateYearFormat(
                                              context, yearNameController.text))
                                          {
                                          QuickAlert.show(
                                              width: Get.width / 2,
                                              context: context,
                                              type: QuickAlertType.loading,
                                              title: 'جاري التحميل'.tr,
                                              text: 'يتم العمل على الطلب'.tr,
                                              barrierDismissible: false);

                                          try{
                                            await controller.archive(yearNameController.text);
                                            Get.back();
                                            Get.back();
                                          } on Exception catch (e){
                                          await  getReedOnlyError(context,title: e.toString());
                                            Get.back();
                                            Get.back();
                                          }

                                        }
                                      },
                                      onCancelBtnTap: () => Get.back(),
                                      confirmBtnText: 'نعم'.tr,
                                      cancelBtnText: 'لا'.tr,
                                      confirmBtnColor: Colors.redAccent,
                                      showCancelBtn: true,
                                    );
                                  }),
                              AppButton(
                                  text: "بدأ عام دراسي جديد".tr,
                                  onPressed: () async {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      text: 'قبول هذه العملية'.tr,
                                      title:
                                          'سيتم حذف جميع البيانات الحالية'.tr,
                                      onConfirmBtnTap: () async {
                                        QuickAlert.show(
                                            width: Get.width / 2,
                                            context: context,
                                            type: QuickAlertType.loading,
                                            title: 'جاري التحميل'.tr,
                                            text: 'يتم العمل على الطلب'.tr,
                                            barrierDismissible: false);
                                        await controller.archive("s");
                                        Get.back();
                                        Get.back();
                                      },
                                      onCancelBtnTap: () => Get.back(),
                                      confirmBtnText: 'نعم'.tr,
                                      cancelBtnText: 'لا'.tr,
                                      confirmBtnColor: Colors.redAccent,
                                      showCancelBtn: true,
                                    );
                                  }),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              );
            }),
          );
        }),
      ),
    );
  }

  void showParentInputDialog(
      BuildContext context, dynamic accountManagementModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
            ),
            height: Get.height / 2,
            width: Get.width / 1.5,
            child: EmployeeInputForm(
                accountManagementModel: accountManagementModel),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildColumns(double size, List<String> deleteData) {
    return List.generate(
      deleteData.length,
      (index) => DataColumn(
        label: Container(
          width: size / deleteData.length,
          child: Center(
            child: Text(deleteData[index].toString().tr),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildWaitRows(
      double size, List<String> deleteData, controller) {
    List<WaitManagementModel> deleteModel = controller.allWaiting.values
        .where((element) => element.isAccepted == null)
        .toList();

    return List.generate(
      deleteModel.length,
      (index) {
        String affectedName = _getAffectedName(deleteModel[index]);
        return DataRow(
          cells: _buildWaitCells(
              size, deleteData, deleteModel[index], affectedName, controller),
        );
      },
    );
  }

  String _getAffectedName(WaitManagementModel model) {
    switch (model.collectionName) {
      case accountManagementCollection:
        return Get.find<AccountManagementViewModel>()
                .allAccountManagement[model.affectedId]
                ?.fullName ??
            model.affectedId;
      case parentsCollection:
        return Get.find<ParentsViewModel>()
                .parentMap[model.affectedId]
                ?.fullName ??
            model.affectedId;
      case studentCollection:
        return Get.find<StudentViewModel>()
                .studentMap[model.affectedId]
                ?.studentName ??
            model.affectedId;
      case classCollection:
        return Get.find<ClassViewModel>()
                .classMap[model.affectedId]
                ?.className ??
            model.affectedId;
      case installmentCollection:
        return Get.find<StudentViewModel>()
                .studentMap[model.relatedId]
                ?.studentName ??
            model.affectedId;
      case busesCollection:
        return Get.find<BusViewModel>().busesMap[model.affectedId]?.number ??
            model.affectedId;
      case Const.expensesCollection:
        return Get.find<ExpensesViewModel>()
                .allExpenses[model.affectedId]
                ?.title ??
            model.affectedId;
      case storeCollection:
        return Get.find<StoreViewModel>().storeMap[model.affectedId]?.subName ??
            model.affectedId;
      case examsCollection:
        return Get.find<ExamViewModel>().examMap[model.affectedId]?.subject ??
            model.affectedId;
      default:
        return "";
    }
  }

  List<DataCell> _buildWaitCells(
      double size,
      List<String> deleteData,
      WaitManagementModel model,
      String affectedName,
      WaitManagementViewModel controller) {
    return [
      dataRowItem(size / deleteData.length, model.type.toString().tr),
      dataRowItem(size / deleteData.length, model.details ?? "لا يوجد".tr),
      dataRowItem(size / deleteData.length, affectedName),
      dataRowItem(size / deleteData.length, model.collectionName.toString()),
      model.type == waitingListTypes.edite.name
          ? dataRowItem(size / deleteData.length, "عرض".tr, onTap: () {
              Map<String, Map<String, dynamic>> differences = compareMaps(
                model.newData ?? {},
                model.oldDate ?? {},
              );

              showData(context, differences, model);
            })
          : DataCell(
              Container(
                width: size / deleteData.length,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconButton(
                      Icons.check_circle_outline,
                      Colors.green,
                      "قبول".tr,
                      () {
                        if (enableUpdate)
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            text: 'قبول هذه العملية'.tr,
                            title: model.collectionName == parentsCollection
                                ? 'عند حذف ولي الامر سوف يتم حذف الاولاد الخاصة به'
                                    .tr
                                : 'هل انت متأكد ؟'.tr,
                            onConfirmBtnTap: () async {
                              await controller.doTheWait(model);
                              Get.back();
                            },
                            onCancelBtnTap: () => Get.back(),
                            confirmBtnText: 'نعم'.tr,
                            cancelBtnText: 'لا'.tr,
                            confirmBtnColor: Colors.redAccent,
                            showCancelBtn: true,
                          );

                      },
                    ),
                    _buildIconButton(
                      Icons.remove_circle_outline,
                      Colors.red,
                      "رفض".tr,
                      () {
                        if (enableUpdate)
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            text: 'رفض هذه العملية'.tr,
                            title: 'هل انت متأكد ؟'.tr,
                            onConfirmBtnTap: () {
                              controller.undoTheDelete(model);
                              Get.back();
                            },
                            onCancelBtnTap: () => Get.back(),
                            confirmBtnText: 'نعم'.tr,
                            cancelBtnText: 'لا'.tr,
                            confirmBtnColor: Colors.red,
                            showCancelBtn: true,
                          );

                      },
                    ),
                  ],
                ),
              ),
            ),
    ];
  }

  IconButton _buildIconButton(
      IconData icon, Color color, String label, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }

  showData(BuildContext context, Map<String, Map<String, dynamic>> differences,
      WaitManagementModel waitModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
            ),
            // height: Get.height / 2.5,
            width: Get.width / 1.5,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;

                return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: Get.width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          Text(
                            "البيانات القديمة".tr,
                            style: Styles.headLineStyle1,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            "البيانات الجديدة".tr,
                            style: Styles.headLineStyle1,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: differences.keys.length,

                      /* oldDate?.values.map(
                            (element) {
                              int count = 0;
                              for (int i = 0; i < oldDate.length; i++) {
*/ /*print(oldDate.values.elementAt(i).toString());
print("------------------------------------");
print(newDate!.values.elementAt(i).toString());*/ /*
                                if (oldDate.values.elementAt(i).toString() !=
                                    newDate!.values.elementAt(i).toString()) {
                                  count++;
                                }
                              }

                              return count;
                            },
                          ).firstOrNull ??
                          0,*/
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: width / 5,
                                child: Text(
                                  differences.keys
                                      .elementAt(index)
                                      .toString()
                                      .tr,
                                  /*   newDate?.entries
                                          .where(
                                            (element) {
                                     */ /*         print("${element.value.toString()}" +"!="+
                                                  "${oldDate!.values.elementAt(newDate.values.toList().indexOf(element.value)).toString()}");*/ /*
                                              return element.value.toString() !=
                                                  oldDate!.values
                                                      .elementAt(newDate
                                                          .keys
                                                          .toList()
                                                          .indexOf(element.key))
                                                      .toString();
                                            },
                                          )
                                          .elementAtOrNull(index)
                                          ?.key
                                          .toString()
                                          .tr ??
                                      '',*/
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.headLineStyle3,
                                )),
                            Text(":"),
                            Container(
                                width: width / 4.1,
                                child: Text(
                                  differences.values
                                      .elementAt(index)['oldData']
                                      .toString(),
                                  /*    newDate?.entries
                                          .where(
                                            (element) {
                                              return element.value.toString() !=
                                                  oldDate?.values
                                                      .elementAtOrNull(newDate
                                                          .keys
                                                          .toList()
                                                          .indexOf(element.key))
                                                      .toString();
                                            },
                                          )
                                          .elementAtOrNull(index)
                                          ?.value
                                          .toString()
                                          .tr ??
                                      '',*/
                                  style: Styles.headLineStyle3
                                      .copyWith(color: primaryColor),
                                )),
                            Spacer(),
                            Container(
                              width: 1,
                              color: Colors.grey,
                              height: 30,
                            ),
                            Spacer(),
                            Container(
                                width: width / 5,
                                child: Text(
                                  differences.keys
                                      .elementAt(index)
                                      .toString()
                                      .tr,
                                  /* oldDate?.entries
                                          .where(
                                            (element) {
                                              return element.value.toString() !=
                                                  newDate?.values
                                                      .elementAtOrNull(oldDate
                                                          .keys
                                                          .toList()
                                                          .indexOf(element.key))
                                                      .toString();
                                            },
                                          )
                                          .elementAtOrNull(index)
                                          ?.key
                                          .toString()
                                          .tr ??
                                      '',*/
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.headLineStyle3,
                                )),
                            Text(":"),
                            Container(
                                width: width / 4.1,
                                child: Text(
                                  differences.values
                                      .elementAt(index)['newData']
                                      .toString(),
                                  /*  oldDate?.entries
                                          .where(
                                            (element) {
                                              return element.value.toString() !=
                                                  newDate?.values
                                                      .elementAtOrNull(oldDate
                                                          .keys
                                                          .toList()
                                                          .indexOf(element.key))
                                                      .toString();
                                            },
                                          )
                                          .elementAtOrNull(index)
                                          ?.value
                                          .toString()
                                          .tr ??
                                      '',*/
                                  style: Styles.headLineStyle3
                                      .copyWith(color: primaryColor),
                                )),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Container(
                      // width: size / deleteData.length,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIconButton(
                            Icons.check_circle_outline,
                            Colors.green,
                            "قبول".tr,
                            () {
                              if (enableUpdate)
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  text: 'قبول هذه العملية'.tr,
                                  title: 'هل انت متأكد ؟'.tr,
                                  onConfirmBtnTap: () {
                                    // controller.doTheWait(model);
                                    Get.find<WaitManagementViewModel>()
                                        .approveEdite(waitModel);
                                    Get.back();
                                    Get.back();
                                  },
                                  onCancelBtnTap: () => Get.back(),
                                  confirmBtnText: 'نعم'.tr,
                                  cancelBtnText: 'لا'.tr,
                                  confirmBtnColor: Colors.redAccent,
                                  showCancelBtn: true,
                                );
                            },
                          ),
                          _buildIconButton(
                            Icons.remove_circle_outline,
                            Colors.red,
                            "رفض".tr,
                            () {
                              if (enableUpdate)
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  text: 'رفض هذه العملية'.tr,
                                  title: 'هل انت متأكد ؟'.tr,
                                  onConfirmBtnTap: () async {
                                    await Get.find<WaitManagementViewModel>()
                                        .declineEdit(waitModel);
                                    Get.back();
                                    Get.back();
                                  },
                                  onCancelBtnTap: () => Get.back(),
                                  confirmBtnText: 'نعم'.tr,
                                  cancelBtnText: 'لا'.tr,
                                  confirmBtnColor: Colors.red,
                                  showCancelBtn: true,
                                );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
/* for (var deleteModel
                                        in controller.allWaiting.values.where(
                                              (element) => element.isAccepted == null,
                                        ))
                                          DataRow(cells: [
                                            dataRowItem(
                                                size / deleteData.length,
                                                deleteModel.type.toString().tr),
                                            dataRowItem(
                                                size / deleteData.length,
                                                deleteModel.details ??
                                                    "لا يوجد".tr),
                                            dataRowItem(size / deleteData.length,
                                                deleteModel.collectionName==accountManagementCollection?
                                                    Get.find<AccountManagementViewModel>().allAccountManagement[deleteModel.affectedId]?.fullName
                                                    :""),
                                            dataRowItem(
                                                size / deleteData.length,
                                                deleteModel.collectionName
                                                    .toString()),
                                            DataCell(Container(
                                              width: size / deleteData.length,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        if (enableUpdate)
                                                          QuickAlert.show(
                                                              context: context,
                                                              type: QuickAlertType
                                                                  .confirm,
                                                              text:
                                                              'حذف هذا العنصر بشكل نهائي'
                                                                  .tr,
                                                              title: deleteModel
                                                                  .collectionName ==
                                                                  parentsCollection
                                                                  ? 'عند حذف ولي الامر سوف يتم حذف الاولاد الخاصة به'
                                                                  .tr
                                                                  : 'هل انت متأكد ؟'
                                                                  .tr
                                                                  .tr,
                                                              onConfirmBtnTap: () =>
                                                              {
                                                                controller
                                                                    .doTheWait(
                                                                    deleteModel),
                                                                Get.back()
                                                              },
                                                              onCancelBtnTap: () =>
                                                                  Get.back(),
                                                              confirmBtnText:
                                                              'نعم'.tr,
                                                              cancelBtnText:
                                                              'لا'.tr,
                                                              confirmBtnColor:
                                                              Colors.redAccent
                                                                  ,
                                                              showCancelBtn: true);
                                                      },
                                                      icon: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text("قبول".tr),
                                                        ],
                                                      )),
                                                  IconButton(
                                                      onPressed: () {
                                                        if (enableUpdate)
                                                          QuickAlert.show(
                                                              context: context,
                                                              type: QuickAlertType
                                                                  .confirm,
                                                              text:
                                                              'استرجاع هذه العنصر'
                                                                  .tr,
                                                              title:
                                                              'هل انت متأكد ؟'
                                                                  .tr,
                                                              onConfirmBtnTap: () =>
                                                              {
                                                                controller
                                                                    .undoTheDelete(
                                                                    deleteModel),
                                                                Get.back()
                                                              },
                                                              onCancelBtnTap: () =>
                                                                  Get.back(),
                                                              confirmBtnText:
                                                              'نعم'.tr,
                                                              cancelBtnText:
                                                              'لا'.tr,
                                                              confirmBtnColor:
                                                              Colors.red,
                                                              showCancelBtn: true);
                                                      },
                                                      icon: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .remove_circle_outline,
                                                            color: Colors.red,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text("رفض".tr),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            )),
                                            /*  dataRowItem(
                                              size / deleteData.length,
                                              deleteModel.collectionName
                                                  .toString()),
                                          dataRowItem(size / deleteData.length,
                                              "استرجاع".tr, color: Colors.teal,
                                              onTap: () {
                                            if (enableUpdate)
                                              controller
                                                  .undoTheDelete(deleteModel);
                                          }),
                                          dataRowItem(size / deleteData.length,
                                              "حذف نهائي".tr,
                                              color: Colors.red.shade700,
                                              onTap: () {


                                            if (enableUpdate)

                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.confirm,
                                                text: 'حذف هذا العنصر بشكل نهائي'.tr,
                                                title: 'هل انت متأكد ؟'.tr,
                                                onConfirmBtnTap: () =>
                                                {
                                                        controller.doTheDelete(
                                                            deleteModel),Get.back()
                                                      },
                                                onCancelBtnTap: () => Get.back(),
                                                confirmBtnText: 'نعم'.tr,
                                                cancelBtnText: 'لا'.tr,
                                                confirmBtnColor: Colors.redAccent.withOpacity(0.2),
                                                showCancelBtn: true
                                              );

                                          }),*/
                                          ]),
                                      ]),*/
