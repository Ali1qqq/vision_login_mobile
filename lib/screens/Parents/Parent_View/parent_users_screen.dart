import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Pluto_Grid.dart';
import '../../../core/constant/constants.dart';
import '../../Widgets/header.dart';
import '../Controller/Parents_View_Model.dart';
import 'Widgets/BuildParentDeleteOrRestoreButton.dart';
import 'Widgets/BuildParentEditButton.dart';

class ParentUsersScreen extends StatelessWidget {
  const ParentUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentsViewModel>(builder: (controller) {
      return Scaffold(
        appBar: Header(context: context, title: 'اولياء الامور'.tr, middleText: 'تقوم هذه الواجه بعرض معلومات تفصيلية عن الاباء ويمكن من خلالها اضافة اب جديد او تعديل اب موجود سابقا او حذفه'.tr),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: defaultPadding * 3),
          child: GetBuilder<HomeViewModel>(builder: (hController) {
            double size = max(MediaQuery.sizeOf(context).width - (hController.isDrawerOpen ? 240 : 120), 1000) - 60;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SizedBox(
                  height: Get.height - 180,
                  width: size + 60,
                  child: CustomPlutoGrid(
                    controller: controller,
                    selectedColor:  controller.selectedColor,
                    idName: "الرقم التسلسلي",
                    onSelected: (event) {
                      controller.selectedColor=Colors.white.withOpacity(0.5);
                      controller.setCurrentId(event.row?.cells["الرقم التسلسلي"]?.value);
                    },
                  ),
                ),
              ),
            );
          }),
        ),
        floatingActionButton: enableUpdate && controller.currentId != '' && controller.parentMap[controller.currentId]!.isAccepted == true
            ? GetBuilder<WaitManagementViewModel>(builder: (_) {
                return SizedBox(
                  width: Get.width,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      BuildParentDeleteOrRestoreButton(_, controller, context),
                      SizedBox(width: defaultPadding),
                      if (!controller.getIfDelete()) BuildParentEditButton(context),
                    ],
                  ),
                );
              })
            : Container(),
      );
    });
  }
}

/*        Wrap(
                      spacing: 25,
                      children: [
                        CustomTextField(
                          size: Get.width / 6,
                          controller: searchController,
                          title: "ابحث",
                          onChange: (value) {
                            setState(() {});
                          },
                        ),
                        CustomDropDown(
                          size: Get.width / 6,
                          value: searchValue,
                          listValue: filterData
                              .map(
                                (e) => e.toString(),
                              )
                              .toList(),
                          label: "اختر فلتر البحث",
                          onChange: (value) {
                            searchValue = value ?? '';
                            searchIndex=filterData.indexOf(searchValue);

                          },
                        )
                      ],
                    ),
                    SizedBox(height: 5,),
                    Divider(color: primaryColor.withOpacity(0.2),),
                    SizedBox(height: 5,),*/

/*        child: Scrollbar(
                      controller: _scrollController,
                      child: GetBuilder<DeleteManagementViewModel>(
                          builder: (_) {
                        return SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              dividerThickness: 0.3,
                              columnSpacing: 0,
                              columns: List.generate(
                                  data.length,
                                  (index) => DataColumn(
                                      label: Container(
                                          width: size / data.length,
                                          child: Center(
                                              child: Text(data[index]
                                                  .toString()
                                                  .tr))))),
                              rows: [
                                for (var parent
                                    in controller.parentMap.values.where(
                                  (element) {
                                    if (searchController.text == '')
                                      return true;
                                    else switch(searchIndex){
                                      case 0:
                                        return  element.fullName!
                                            .contains(searchController.text);
                                      case 1:
                                        return  element.address!
                                            .contains(searchController.text);
                                      case 2:
                                        return  element.nationality!
                                            .contains(searchController.text);
                                      case 3:
                                        return  element.age!
                                            .contains(searchController.text);
                                      case 4:
                                        return  element.work!
                                            .contains(searchController.text);
                                      case 5:
                                        return  element.startDate!
                                            .contains(searchController.text);

                                     default:
                                       return false;
                                    }

                                  },
                                ).toList())
                                  DataRow(
                                      color: WidgetStatePropertyAll(
                                        checkIfPendingDelete(
                                                affectedId:
                                                    parent.id.toString())
                                            ? Colors.redAccent
                                                .withOpacity(0.2)
                                                .withOpacity(0.2)
                                            : Colors.transparent,
                                      ),
                                      cells: [
                                        dataRowItem(size / data.length,
                                            parent.fullName.toString()),
                                        dataRowItem(size / data.length,
                                            parent.address.toString()),
                                        dataRowItem(size / data.length,
                                            parent.nationality.toString()),
                                        dataRowItem(size / data.length,
                                            parent.age.toString()),
                                        dataRowItem(size / data.length,
                                            parent.work.toString()),
                                        dataRowItem(size / data.length,
                                            parent.startDate.toString()),
                                        dataRowItem(size / data.length,
                                            parent.motherPhone.toString()),
                                        dataRowItem(
                                            size / data.length,
                                            parent.emergencyPhone
                                                .toString()),
                                        dataRowItem(
                                            size / data.length,
                                            parent.eventRecords?.length == 0
                                                ? "لايوجد".tr
                                                : "عرض  (${parent.eventRecords?.length})  حدث"
                                                    .toString(), onTap: () {
                                          if (parent.eventRecords!.length >
                                              0)
                                            showEventDialog(context,
                                                parent.eventRecords!);
                                        }),
                                        dataRowItem(
                                            size / data.length, "تعديل".tr,
                                            color: Colors.teal, onTap: () {
                                          if (enableUpdate == true)
                                            showParentInputDialog(
                                                context, parent);
                                        }),
                                        dataRowItem(
                                            size / data.length,
                                            checkIfPendingDelete(
                                                    affectedId: parent.id
                                                        .toString())
                                                ? 'استرجاع'.tr
                                                : "حذف".tr,
                                            color: checkIfPendingDelete(
                                                    affectedId: parent.id
                                                        .toString())
                                                ? Colors.white
                                                : Colors.red, onTap: () {
                                          if (enableUpdate == true) {
                                            if (checkIfPendingDelete(
                                                affectedId:
                                                    parent.id.toString()))
                                              _.returnDeleteOperation(
                                                  affectedId: parent.id!);
                                            else
                                              controller.deleteParent(
                                                  parent.id.toString(),
                                                  parent.children ?? []);
                                          }
                                        }),
                                      ]),
                              ]),
                        );
                      }),
                    ),*/
