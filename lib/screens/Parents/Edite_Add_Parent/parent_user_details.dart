import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/Installment_model.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Parents/Edite_Add_Parent/widgets/BuildParentAddContractButton.dart';
import 'package:vision_dashboard/screens/Parents/Edite_Add_Parent/widgets/BuildParentContractImage.dart';
import 'package:vision_dashboard/screens/Parents/Edite_Add_Parent/widgets/BuildParentContractImageSection.dart';
import 'package:vision_dashboard/screens/Parents/Edite_Add_Parent/widgets/EventParentContainer.dart';
import 'package:vision_dashboard/screens/Parents/Edite_Add_Parent/widgets/ParentAddIdImageButton.dart';
import 'package:vision_dashboard/screens/Parents/Edite_Add_Parent/widgets/ParentIdImageListWidget.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Insert_shape_Widget.dart';
import 'package:vision_dashboard/screens/Widgets/header.dart';
import '../../../constants.dart';
import '../../../core/Styling/app_style.dart';
import '../../../core/Utils/Strings.dart';
import '../../Widgets/Custom_Drop_down.dart';
import '../../Widgets/Custom_Text_Filed.dart';

class ParentInputForm extends StatelessWidget {
  ParentInputForm();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentsViewModel>(builder: (parentController) {
      return Scaffold(
        appBar: Header(title: parentController.parent == null ? ConstString.addNewParent : "تعديل ولي الامر", middleText: "", context: context, haveBack: parentController.parent == null ? false : true),
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InsertShapeWidget(
                titleWidget: Text(
                  ConstString.parentDetails,
                  style: AppStyles.headLineStyle1,
                ),
                bodyWidget: Column(
                  children: [
                    Wrap(
                      clipBehavior: Clip.hardEdge,
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceEvenly,
                      runSpacing: 50,
                      spacing: 25,
                      children: [
                        CustomTextField(controller: parentController.fullNameController, title: 'الاسم الكامل'.tr),
                        CustomTextField(
                          controller: parentController.idNumController,
                          title: 'رقم الهوية'.tr,
                          // isNumeric: true,
                        ),
                        CustomTextField(
                          controller: parentController.numberController,
                          title: 'رقم الهاتف'.tr,
                          keyboardType: TextInputType.number,
                          isNumeric: true,
                        ),
                        CustomTextField(controller: parentController.addressController, title: 'العنوان'.tr),
                        CustomTextField(controller: parentController.nationalityController, title: 'الجنسية'.tr),
                        CustomTextField(
                          controller: parentController.motherPhoneNumberController,
                          title: 'رقم هاتف الام'.tr,
                          keyboardType: TextInputType.number,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: parentController.emergencyPhoneController,
                          title: 'رقم الطوارئ'.tr,
                          keyboardType: TextInputType.number,
                          isNumeric: true,
                        ),
                        CustomTextField(controller: parentController.workController, title: 'العمل'.tr),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2100),
                            ).then((date) {
                              if (date != null) {
                                parentController.startDateController.text = date.toString().split(" ")[0];
                              }
                            });
                          },
                          child: CustomTextField(
                            controller: parentController.startDateController,
                            title: 'تاريخ البداية'.tr,
                            enable: false,
                            keyboardType: TextInputType.datetime,
                            icon: Icon(
                              Icons.date_range_outlined,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        CustomDropDown(
                          value: parentController.payWay.tr,
                          listValue: parentController.payWays
                              .map(
                                (e) => e.toString().tr,
                              )
                              .toList(),
                          label: "طريقة الدفع".tr,
                          onChange: (selectedWay) async {
                            if (selectedWay != null) {
                              parentController.payWay = selectedWay;
                            }
                          },
                        ),
                        // buildParentContractImageSection(parentController),
                        // BuildParentContractImage(memoryImage: parentController.contractsTemp),
                        buildParentAddIdImageButton(parentController),

                        ...buildParentIdImageList(parentController.contractsTemp, parentController, true),
                        ...buildParentIdImageList(parentController.contracts, parentController, false),
//Todo: هون بعرضها
                        Column(
                          children: [
                            SizedBox(height: defaultPadding * 2),
                            Text('سجل الدفعات:'.tr, style: AppStyles.headLineStyle1),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              shrinkWrap: true,
                              itemCount: parentController.instalmentMap.length,
                              itemBuilder: (context, index) {
                                var sortedValues = parentController.instalmentMap.values.toList()
                                  ..sort((a, b) {
                                    return a.installmentDate!.compareTo(b.installmentDate!);
                                  });
                                InstallmentModel oneInstallment = sortedValues[index];
                                bool cantEdite = oneInstallment.isPay ?? false;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 2.0,
                                      color: primaryColor,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            if (!cantEdite) {
                                              showDatePicker(
                                                context: context,
                                                firstDate: DateTime(2010),
                                                lastDate: DateTime(2100),
                                              ).then((date) {
                                                if (date != null) {
                                                  parentController.monthsController[index].text = date.toString().split(" ")[0];
                                                }
                                              });
                                            }
                                          },
                                          child: CustomTextField(
                                            controller: parentController.monthsController[index],
                                            title: 'تاريخ البداية'.tr,
                                            enable: false,
                                            keyboardType: TextInputType.datetime,
                                            icon: Icon(
                                              Icons.date_range_outlined,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                        /*       canEdite
                                            ? CustomTextField(
                                                enable: !canEdite,
                                                isFullBorder: !canEdite,
                                                controller: TextEditingController()
                                                  ..text = months.entries
                                                          .where(
                                                            (element) => element.value == parentController.monthsController[index].text,
                                                          )
                                                          .firstOrNull
                                                          ?.key ??
                                                      '',
                                                title: "الشهر".tr,
                                                size: Get.width / 5.5,
                                                keyboardType: TextInputType.number,
                                              )
                                            : CustomDropDown(
                                                value: months.entries
                                                        .where(
                                                          (element) {
                                                            if (parentController.monthsController.isEmpty) return false;
                                                            return element.value == parentController.monthsController[index].text;
                                                          },
                                                        )
                                                        .firstOrNull
                                                        ?.key ??
                                                    '',
                                                listValue: months.keys.map((e) => e.toString()).toList(),
                                                label: "الشهر".tr,
                                                size: Get.width / 5.5,
                                                isFullBorder: true,
                                                onChange: (value) {
                                                  if (value != null) {
                                                    parentController.monthsController[index].text = months[value]!;
                                                  }
                                                },
                                              ),*/
                                        Spacer(),
                                        CustomTextField(
                                          enable: !cantEdite,
                                          controller: parentController.costsController[index],
                                          title: "الدفعة".tr,
                                          isNumeric: true,
                                          size: Get.width / 5.5,
                                          keyboardType: TextInputType.number,
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              parentController.instalmentMap.remove(oneInstallment.installmentId);
                                              parentController.update();
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                                onPressed: () {
                                  parentController.addInstalment();
                                },
                                icon: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      "اضافة".tr,
                                      style: AppStyles.headLineStyle3,
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            /*   GetBuilder<StudentViewModel>(builder: (controller) {
                              return AppButton(
                                text: "حفظ".tr,
                                onPressed: () async {
                                  save(controller);
                                },
                              );
                            }),*/
                          ],
                        ),
                        if (parentController.parent != null) CustomTextField(controller: parentController.editController, title: 'سبب التعديل'.tr),
                      ],
                    ),
                    AppButton(
                        text: 'حفظ'.tr,
                        onPressed: () {
                          // print( parentController.instalmentMap.entries.map((e) => e.value.toJson(),).toList());
                          // print(  Map.fromEntries(parentController.instalmentMap!.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList()));
                          parentController.saveParentData(context);
                        }),
                  ],
                ),
              ),
              SizedBox(height: defaultPadding),
              if (parentController.parent != null) ParentEventContainer(),
            ],
          ),
        ),
      );
    });
  }
}
