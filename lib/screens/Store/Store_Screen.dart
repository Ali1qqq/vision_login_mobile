import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:vision_dashboard/screens/Store/Controller/Store_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';
import 'package:vision_dashboard/utils/Dialogs.dart';
import '../../constants.dart';
import '../../models/Store_Model.dart';
import '../Widgets/Custom_Pluto_Grid.dart';
import '../Widgets/Data_Row.dart';
import '../Widgets/header.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ScrollController _scrollController = ScrollController();
  List data = ["اسم المادة", "الكمية", "الخيارات", ""];
  String currentId = '';

  bool getIfDelete() {
    return checkIfPendingDelete(affectedId: currentId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreViewModel>(
      builder: (controller) {
        return Scaffold(
          appBar: Header(
              context: context,
              title: 'المستودع'.tr,
              middleText: 'تستخدم هذه الواجهة لعرض تفاصيل المواد داخل المستودع'.tr),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
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
         /*     return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<StoreViewModel>(builder: (controller) {
                        return SizedBox(
                          width: size + 60,
                          child: Scrollbar(
                            controller: _scrollController,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child:
                                  GetBuilder<WaitManagementViewModel>(builder: (_) {
                                return DataTable(
                                    columnSpacing: 0,
                                    dividerThickness: 0.3,
                                    columns: List.generate(
                                        data.length,
                                        (index) => DataColumn(
                                            label: Container(
                                                width: size / (data.length),
                                                child: Center(
                                                    child: Text(data[index]
                                                        .toString()
                                                        .tr))))),
                                    rows: [
                                      for (var storeModel
                                          in controller.storeMap.values.toList())
                                        DataRow(
                                            color: WidgetStatePropertyAll(storeModel
                                                        .isAccepted ==
                                                    false
                                                ? Colors.green.withOpacity(0.3)
                                                : checkIfPendingDelete(
                                                        affectedId: storeModel.id!)
                                                    ? Colors.red.withOpacity(0.2)
                                                    : Colors.transparent),
                                            cells: [
                                              dataRowItem(
                                                  size / (data.length),
                                                  storeModel.subQuantity
                                                      .toString()),
                                              dataRowItem(size / (data.length),
                                                  storeModel.subName.toString()),
                                              dataRowItem(
                                                  size / (data.length), "تعديل".tr,
                                                  color: Colors.teal, onTap: () {
                                                if (storeModel.isAccepted! &&
                                                    !checkIfPendingDelete(
                                                        affectedId: storeModel.id!))
                                                  buildEditDialog(
                                                      context, storeModel);
                                                else
                                                  getReedOnlyError(context);
                                              }),
                                              DataCell(Container(
                                                  width: size / (data.length),
                                                  child: IconButton(
                                                      onPressed: () {
                                                        if (storeModel
                                                            .isAccepted!) {
                                                          if (checkIfPendingDelete(
                                                              affectedId:
                                                                  storeModel.id!))
                                                            _.returnDeleteOperation(
                                                                affectedId:
                                                                    storeModel.id!);
                                                          else {
                                                            TextEditingController
                                                                editController =
                                                                TextEditingController();

                                                            QuickAlert.show(
                                                              context: context,
                                                              type: QuickAlertType
                                                                  .confirm,
                                                              widget: Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8.0),
                                                                  child:
                                                                      CustomTextField(
                                                                    controller:
                                                                        editController,
                                                                    title:
                                                                        "سبب الحذف"
                                                                            .tr,
                                                                    size:
                                                                        Get.width /
                                                                            4,
                                                                  ),
                                                                ),
                                                              ),
                                                              text:
                                                                  'قبول هذه العملية'
                                                                      .tr,
                                                              title:
                                                                  'هل انت متأكد ؟'
                                                                      .tr,
                                                              onConfirmBtnTap:
                                                                  () async {
                                                                addWaitOperation(
                                                                    details:
                                                                        editController
                                                                            .text,
                                                                    type:
                                                                        waitingListTypes
                                                                            .delete,
                                                                    collectionName:
                                                                        storeCollection,
                                                                    affectedId:
                                                                        storeModel
                                                                            .id!);
                                                                Get.back();
                                                              },
                                                              onCancelBtnTap: () =>
                                                                  Get.back(),
                                                              confirmBtnText:
                                                                  'نعم'.tr,
                                                              cancelBtnText:
                                                                  'لا'.tr,
                                                              confirmBtnColor:
                                                                  Colors.redAccent,
                                                              showCancelBtn: true,
                                                            );
                                                          }
                                                        } else
                                                          getReedOnlyError(context);
                                                      },
                                                      icon: Row(
                                                        children: [
                                                          Spacer(),
                                                          Icon(
                                                            checkIfPendingDelete(
                                                                    affectedId:
                                                                        storeModel
                                                                            .id!)
                                                                ? Icons.check
                                                                : Icons.delete,
                                                            color: checkIfPendingDelete(
                                                                    affectedId:
                                                                        storeModel
                                                                            .id!)
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(checkIfPendingDelete(
                                                                  affectedId:
                                                                      storeModel
                                                                          .id!)
                                                              ? "استرجاع".tr
                                                              : "حذف".tr),
                                                          Spacer(),
                                                        ],
                                                      ))))
                                            ]),
                                    ]);
                              }),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );*/
            }),
          ),

          floatingActionButton: enableUpdate &&
              currentId != '' &&
              controller.storeMap[currentId]!.isAccepted!
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
                                  .storeMap[currentId]!.id
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
                                controller.storeMap[currentId]!.id!,
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
                        buildEditDialog(
                            context, controller.storeMap[currentId]!);
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
      }
    );
  }

  Future<dynamic> buildEditDialog(BuildContext context, StoreModel storeModel) {
    final TextEditingController subNameController = TextEditingController();
    final TextEditingController subQuantityController = TextEditingController();
    final TextEditingController editingController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryColor,
        title: Text("تعديل المادة"),
        actions: [
          CustomTextField(
              controller: subQuantityController
                ..text = storeModel.subQuantity.toString(),
              title: data[0]),
          CustomTextField(
              controller: subNameController
                ..text = storeModel.subName.toString(),
              title: data[1]),
          CustomTextField(controller: editingController, title: "سبب التعديل"),
          AppButton(
            text: 'حفظ',
            onPressed: () {
              StoreModel store = StoreModel(
                isAccepted: false,
                subName: subNameController.text,
                subQuantity: subQuantityController.text,
                id: storeModel.id,
              );
              addWaitOperation(
                collectionName: storeCollection,
                affectedId: storeModel.id!,
                type: waitingListTypes.edite,
                oldData: storeModel.toJson(),
                newData: store.toJson(),
                details: editingController.text,
              );
              Get.find<StoreViewModel>().updateStore(store);
              print('store Model: $store');
              Get.back();
            },
          )
        ],
      ),
    );
  }
}
