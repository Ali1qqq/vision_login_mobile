import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:vision_dashboard/controller/account_management_view_model.dart';

import 'package:vision_dashboard/screens/account_management/Employee_user_details.dart';

import '../../constants.dart';
import '../../controller/Wait_management_view_model.dart';
import '../../controller/home_controller.dart';

import '../../utils/Dialogs.dart';
import '../Widgets/Custom_Pluto_Grid.dart';
import '../Widgets/Custom_Text_Filed.dart';
import '../Widgets/header.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
/*  final ScrollController _scrollController = ScrollController();

  List userData = [
    "User Name",
    "الاسم الكامل",
    "كامة السر",
    "الدور",
    "الحالة",
    "رقم الموبايل",
    "العنوان",
    "الجنسية",
    "الجنس",
    "العمر",
    "الوظيفة",
    "العقد",
    "الصفوف",
    "تاريخ البداية",
    "سجل الاحداث",
    "العمليات"
  ];*/

  String currentId = '';

  bool getIfDelete() {
    return checkIfPendingDelete(affectedId: currentId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountManagementViewModel>(
      builder: (controller) {
        return Scaffold(
          appBar: Header(
              context: context,
              title: 'ادارة الموظفين'.tr,
              middleText:
                  "تقوم هذه الواجهة بعرض الامور الاساسية في المنصة وهي المستخدمين وامكانية اضافة او تعديل او حذف كما تعرض السجلات الممطلوب حذفها للموافقة عليها او استرجاعها"
                      .tr),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.0),
            child: GetBuilder<HomeViewModel>(builder: (hController) {
              double size = max(
                      MediaQuery.sizeOf(context).width -
                          (hController.isDrawerOpen ? 240 : 120),
                      1000) -
                  60;
              return Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SizedBox(
                    height: Get.height-180,
                    width: size + 60,
                    child: CustomPlutoGrid(
                      controller: controller,
                      idName: "الرقم التسلسلي",
                      onSelected: (event) {
                        currentId = event.row?.cells["الرقم التسلسلي"]?.value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
          floatingActionButton: GetBuilder<WaitManagementViewModel>(
            builder: (_) {
              return enableUpdate && currentId != ''&&controller.allAccountManagement[currentId]!.isAccepted!
                  ? SizedBox(
                width: Get.width,
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    FloatingActionButton(
                      backgroundColor: getIfDelete()
                          ? Colors.greenAccent.withOpacity(0.5)
                          : Colors.red.withOpacity(0.5),
                      onPressed: () {
                        if (enableUpdate) {
                              if (checkIfPendingDelete(
                                  affectedId:controller.allAccountManagement[currentId]!.id.toString()))
                                _.returnDeleteOperation(affectedId:controller.allAccountManagement[currentId]!.id);
                              else {
                                TextEditingController editController =
                                TextEditingController();

                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  widget:Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomTextField(controller: editController, title: "سبب الحذف".tr,size: Get.width/4,),
                                    ),
                                  ),
                                  text: 'قبول هذه العملية'.tr,
                                  title: 'هل انت متأكد ؟'.tr,
                                  onConfirmBtnTap: () async {
                                    addWaitOperation(
                                   details: editController.text,
                                        collectionName: accountManagementCollection,
                                        affectedId: controller.allAccountManagement[currentId]!.id, type: waitingListTypes.delete);
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
                        else
                        getReedOnlyError(context);


                      },
                      child: Icon(
                        getIfDelete()
                            ? Icons.restore_from_trash_outlined
                            : Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    if(controller.allAccountManagement[currentId]!.isAccepted==true&&!getIfDelete())
                    FloatingActionButton(
                      backgroundColor: primaryColor.withOpacity(0.5),
                      onPressed: () {
                        // if(controller.allAccountManagement[currentId]!.isAccepted==true&&!getIfDelete())
                        showEmployeeInputDialog(
                            context, controller.allAccountManagement[currentId]!);
                        // else
                        //   getReedOnlyError(context);
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
                  : Container();
            }
          ),
        );
      }
    );
  }

  void showEmployeeInputDialog(
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
}
/*  child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: GetBuilder<DeleteManagementViewModel>(
                              builder: (_) {
                            return DataTable(
                                columnSpacing: 10,
                                dividerThickness: 0.3,
                                columns: List.generate(
                                    userData.length,
                                    (index) => DataColumn(
                                        label: Container(
                                            width: size / userData.length,
                                            child: Center(
                                                child: Text(userData[index]
                                                    .toString()
                                                    .tr))))),
                                rows: [
                                  for (var accountModel
                                      in controller.allAccountManagement.values)
                                    DataRow(
                                        color: WidgetStatePropertyAll(
                                          checkIfPendingDelete(affectedId: accountModel.id)?Colors.redAccent.withOpacity(0.2):Colors.transparent
                                        ),
                                        cells: [
                                      dataRowItem(size / userData.length,
                                          accountModel.userName.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.fullName.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.password.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.type.toString()),
                                      dataRowItem(
                                        size / userData.length,
                                        accountModel.isActive
                                            ? "فعال".tr
                                            : "ملغى".tr,
                                      ),
                                      dataRowItem(size / userData.length,
                                          accountModel.mobileNumber.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.address.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.nationality.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.gender.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.age.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.jobTitle.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.contract.toString()),
                                      dataRowItem(size / userData.length,
                                          accountModel.bus.toString()),
                                      dataRowItem(
                                          size / userData.length,
                                          accountModel.startDate
                                              .toString()
                                              .split(" ")[0]),
                                      dataRowItem(
                                          size / userData.length, "عرض".tr,
                                          color: Colors.teal, onTap: () {}),
                                      DataCell(Container(
                                        width: max(100, size / userData.length),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  if (enableUpdate)
                                                    if( checkIfPendingDelete(affectedId: accountModel.id))
                                                      returnPendingDelete(affectedId: accountModel.id);
                                                  else
                                                    addDeleteOperation(collectionName: accountManagementCollection, affectedId: accountModel.id);
                                                },
                                                icon: Icon(
                                                  checkIfPendingDelete(affectedId: accountModel.id)?CupertinoIcons.refresh_thick:    Icons.delete_forever_outlined,
                                                  color:checkIfPendingDelete(affectedId: accountModel.id)?Colors.green: Colors.red,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  showParentInputDialog(
                                                      context, accountModel);
                                                },
                                                icon: Icon(Icons
                                                    .remove_red_eye_outlined,color: primaryColor,)),
                                          ],
                                        ),
                                      ))
                                    ]),
                                ]);*/