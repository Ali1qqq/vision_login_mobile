import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/screens/expenses/View_Expenses/Widgets/EditButton.dart';
import '../../../constants.dart';
import '../../../controller/Wait_management_view_model.dart';
import '../../../controller/home_controller.dart';
import '../../Widgets/Custom_Pluto_Grid.dart';
import '../../Widgets/header.dart';
import 'Widgets/Delete_Button.dart';
import 'Widgets/Edite_Button.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeViewModel>(
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
                      Get.width -
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
                        controller.setCurrentId(event.row?.cells["الرقم التسلسلي"]?.value);

                      },
                    ),
                  ),
                ),
              );
            }),
          ),
          floatingActionButton: GetBuilder<WaitManagementViewModel>(
            builder: (_) {
              return enableUpdate && controller.currentId != ''&&controller.allAccountManagement[controller.currentId]!.isAccepted!
                  ? SizedBox(
                width: Get.width,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    buildEmployeeDeleteButton(_, context, controller),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    if(controller.allAccountManagement[controller.currentId]!.isAccepted==true&&!controller.getIfDelete())
                    buildEmployeeEditButton(context, controller)
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