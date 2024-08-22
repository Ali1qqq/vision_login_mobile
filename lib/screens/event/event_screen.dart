import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';
import 'package:vision_dashboard/screens/Widgets/Insert_shape_Widget.dart';
import 'package:vision_dashboard/screens/event/Controller/event_view_model.dart';

import '../../constants.dart';
import '../../controller/Wait_management_view_model.dart';
import '../../controller/home_controller.dart';

import '../../models/event_model.dart';
import '../../utils/const.dart';
import '../Widgets/AppButton.dart';
import '../Widgets/Custom_Pluto_Grid.dart';
import '../Widgets/Custom_Text_Filed.dart';
import '../Widgets/header.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  // final ScrollController _scrollController = ScrollController();
  // List data = ["الرمز التسلسلي", "الاسم", "المستهدف", "اللون", ""];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventViewModel>(builder: (controller) {
      return Scaffold(
        appBar: Header(context: context, title: 'الأحداث'.tr, middleText: "تعرض الواجهة انماط الاحداث التي يمكن ان تطبق لكل فئة من المشتركين داخل المنصة بالاضافة الى امكانية عمل نمط حدث جديد".tr),
        body: SingleChildScrollView(
          child: GetBuilder<HomeViewModel>(builder: (hController) {
            double size = max(MediaQuery.sizeOf(context).width - (hController.isDrawerOpen ? 240 : 120), 1000) - 60;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: (size / 2),
                      height: Get.height - 180,
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: CustomPlutoGrid(
                        controller: controller,
                        idName: "الرقم التسلسلي",
                        onSelected: (event) {
                          controller.selectedColor = Color(int.parse(event.row?.cells["اللون"]?.value));
                          controller.setCurrentId(event.row?.cells["الرقم التسلسلي"]?.value);
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: (size / 2),
                    // height: Get.height - 180,
                    // padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: InsertShapeWidget(
                      titleWidget: Text(controller.currentId == "" ? "إضافة حدث".tr : "تعديل الحدث ", style: AppStyles.headLineStyle1),
                      bodyWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 25,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextField(controller: controller.name, title: "اسم الحدث".tr),
                              SizedBox(
                                width: 50,
                              ),
                              Text("المستهدف".tr),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: DropdownButton(
                                    value: controller.role ?? Const.eventTypeStudent,
                                    isExpanded: true,
                                    onChanged: (_) {
                                      controller.role = _;
                                      setState(() {});
                                    },
                                    items: Const.allEventType.map((e) => DropdownMenuItem(value: e.toString(), child: Text(getEventTypeFromEnum(e)))).toList(),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: Get.width * 0.5,
                            child: MaterialColorPicker(
                                colors: [Colors.red, Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan, Colors.teal, Colors.green, Colors.lime, Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange, Colors.brown, Colors.blueGrey],
                                allowShades: false,
                                onMainColorChange: (ColorSwatch? color) {
                                  controller.selectedMatColor = color!.value;
                                  setState(() {});
                                },
                                selectedColor: Color(controller.selectedMatColor)),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Wrap(
                            spacing: 15,
                            runSpacing: 50,
                            children: [
                              AppButton(
                                text:controller.currentId!=""?"تعديل": "اضافة".tr,
                                onPressed: () {
                                  controller.role ??= Const.eventTypeStudent;
                                  EventModel model = EventModel(
                                    name: controller.name.text,
                                    id:controller.currentId==""? generateId("EVENT"):controller.currentId,
                                    role: controller.role!,
                                    color: controller.selectedMatColor,
                                  );
                                  controller.addEvent(model);
                                  controller.clearController();
                                  controller.update();
                                  setState(() {});
                                },
                              ),
                              if(controller.currentId!="")
                                ...[
                                  AppButton(
                                    text: "جديد".tr,
                                    onPressed: () {
                                      controller.clearController();
                                      controller.update();
                                    },
                                  ),
                                  GetBuilder<WaitManagementViewModel>(
                                      builder: (_) {
                                        return AppButton(
                                          color:  controller.getIfDelete() ? Colors.green : Colors.red,
                                          text: controller.getIfDelete() ? "استرجاع".tr : "حذف".tr,
                                          onPressed: () {
                                            if (controller.getIfDelete()) {
                                              _.returnDeleteOperation(affectedId: controller.currentId);
                                            } else {
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
                                                  addWaitOperation(type: waitingListTypes.delete,

                                                      userName: currentEmployee?.userName.toString()??"",
                                                      details: editController.text, collectionName: Const.eventCollection, affectedId: controller.currentId);
                                                  Get.back();
                                                },
                                                onCancelBtnTap: () => Get.back(),
                                                confirmBtnText: 'نعم'.tr,
                                                cancelBtnText: 'لا'.tr,
                                                confirmBtnColor: Colors.redAccent,
                                                showCancelBtn: true,
                                              );
                                            }
                                          },
                                        );
                                      }
                                  ),
                                ]

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
            /*  return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: GetBuilder<EventViewModel>(builder: (controller) {
                    return SizedBox(
                      width: size + 60,
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: GetBuilder<WaitManagementViewModel>(
                              builder: (_) {
                            return DataTable(
                                columnSpacing: 0,
                                dividerThickness: 0.3,

                                columns: List.generate(
                                    data.length,
                                    (index) => DataColumn(
                                        label: Container(
                                            width: size / data.length,
                                            child: Center(
                                                child: Text(data[index].toString().tr))))),
                                rows: [
                                  for (var event in controller.allEvents.values)
                                    DataRow(
                                        color: WidgetStatePropertyAll(
                                            checkIfPendingDelete(
                                                    affectedId: event.id)
                                                ? Colors.redAccent.withOpacity(0.2)
                                                : Colors.transparent),
                                        cells: [
                                          dataRowItem(size / data.length,
                                              event.id.toString()),
                                          dataRowItem(size / data.length,
                                              event.name.toString()),
                                          dataRowItem(size / data.length,
                                              getEventTypeFromEnum(event.role)),
                                          DataCell(
                                            Container(
                                              width: size / data.length,
                                              child: Center(
                                                  child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                              event.color),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)))),
                                            ),
                                          ),
                                          dataRowItem(
                                              size / data.length,
                                              checkIfPendingDelete(
                                                      affectedId: event.id)
                                                  ? "استرجاع".tr
                                                  : "حذف".tr,
                                              color: checkIfPendingDelete(
                                                      affectedId: event.id)
                                                  ? Colors.white
                                                  : Colors.red,
                                              onTap:  () {
                                                      if (enableUpdate) {
                                                        if (checkIfPendingDelete(
                                                            affectedId:
                                                                event.id))
                                                          _.returnDeleteOperation(
                                                              affectedId:
                                                                  event.id);
                                                        else

                                                        {
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
                                                                  type: waitingListTypes.delete,
        details: editController.text,
                                                                  collectionName: Const
                                                                      .eventCollection,
                                                                  affectedId:
                                                                  event.id);
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
                                                    }),
                                        ]),
                                ]);
                          }),
                        ),
                      ),
                    );
                  }),
                ),
              );*/
          }),
        ),
   /*     floatingActionButton: GetBuilder<WaitManagementViewModel>(builder: (_) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {
                  if (enableUpdate) {}
                },
                backgroundColor: controller.getIfDelete() ? Colors.green : Colors.red,
                child: Icon(
                  controller.getIfDelete() ? Icons.restore_from_trash_rounded : Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }),*/
      );
    });
  }
}
