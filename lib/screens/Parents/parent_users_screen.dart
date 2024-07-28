import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:vision_dashboard/screens/Parents/parent_user_details.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Pluto_Grid.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';
import '../../constants.dart';
import '../Widgets/header.dart';
import 'Controller/Parents_View_Model.dart';

class ParentUsersScreen extends StatefulWidget {
  const ParentUsersScreen({super.key});

  @override
  State<ParentUsersScreen> createState() => _ParentUsersScreenState();
}

class _ParentUsersScreenState extends State<ParentUsersScreen> {
  /*final ScrollController _scrollController = ScrollController();

  List data = [
    "الاسم الكامل",
    "العنوان",
    "الجنسية",
    "العمر",
    "العمل",
    "تاريخ البداية",
    "رقم الام",
    "رقم الطوارئ",
    "سجل الأحداث",
    "الخيارات",
    ""
  ];

  List filterData=[
    "الاسم الكامل",
    "العنوان",
    "الجنسية",
    "العمر",
    "العمل",
    "تاريخ البداية",
  ];
  TextEditingController searchController = TextEditingController();
  String searchValue = '';
  int searchIndex = 0;*/
  String currentId = '';

  bool getIfDelete() {
    return checkIfPendingDelete(affectedId: currentId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentsViewModel>(builder: (controller) {
      return Scaffold(
        appBar: Header(
            context: context,
            title: 'اولياء الامور'.tr,
            middleText:
                'تقوم هذه الواجه بعرض معلومات تفصيلية عن الاباء ويمكن من خلالها اضافة اب جديد او تعديل اب موجود سابقا او حذفه'
                    .tr),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: defaultPadding*3),
          child: GetBuilder<HomeViewModel>(builder: (hController) {
            double size = max(
                    MediaQuery.sizeOf(context).width -
                        (hController.isDrawerOpen ? 240 : 120),
                    1000) -
                60;
            return Padding(
              padding: const EdgeInsets.all(8),
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
        floatingActionButton: enableUpdate &&
                currentId != '' &&
                controller.parentMap[currentId]!.isAccepted!
            ? GetBuilder<WaitManagementViewModel>(builder: (_) {
                return SizedBox(
                  width: Get.width,
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      FloatingActionButton(
                        backgroundColor: getIfDelete()
                            ? Colors.greenAccent.withOpacity(0.5)
                            : Colors.red.withOpacity(0.5),
                        onPressed: ()async {
                          if (enableUpdate) {
                            if (getIfDelete())
                              _.returnDeleteOperation(
                                  affectedId: controller
                                      .parentMap[currentId]!.id
                                      .toString());
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

                                  await addWaitOperation(
                                    type: waitingListTypes.delete,

                                    collectionName: parentsCollection,
                                    affectedId:
                                        controller.parentMap[currentId]!.id!,
                                    details: editController.text,
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
                      if (!getIfDelete())
                        FloatingActionButton(
                          backgroundColor: primaryColor.withOpacity(0.5),
                          onPressed: () {
                            showParentInputDialog(
                                context, controller.parentMap[currentId]!);
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                );
              })
            : Container(),
      );
    });
  }

  void showParentInputDialog(BuildContext context, dynamic parent) {
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
            child: ParentInputForm(parent: parent),
          ),
        );
      },
    );
  }

  void showEventDialog(BuildContext context, dynamic eventRecords) {
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
            width: Get.width / 2,
            child: Column(
              children: [
                Text('سجل الأحداث', style: Styles.headLineStyle1),
                SizedBox(height: defaultPadding),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: eventRecords.length,
                  itemBuilder: (context, index) {
                    final record = eventRecords[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Color(int.parse(record.color)).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                "نوع الحدث: ",
                                style: Styles.headLineStyle2,
                              ),
                              Text(
                                record.type,
                                style: Styles.headLineStyle1
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "تفاصيل الحدث: ",
                                style: Styles.headLineStyle2,
                              ),
                              Text(
                                record.body,
                                style: Styles.headLineStyle1
                                    .copyWith(color: Colors.black),
                              ),
                              Spacer(),
                              Text(
                                "تاريخ الحدث: ",
                                style: Styles.headLineStyle4,
                              ),
                              Text(
                                record.date,
                                style: Styles.headLineStyle3,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
