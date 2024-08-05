import 'package:vision_dashboard/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/controller/NFC_Card_View_model.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';
import 'package:vision_dashboard/core/Utils/Strings.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/screens/Employee/Edite_Add_Employee/Widgets/EventControllerWidget.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down.dart';
import '../../Buses/Controller/Bus_View_Model.dart';
import '../../Widgets/Custom_Text_Filed.dart';
import '../../Widgets/header.dart';

class EmployeeInputForm extends StatelessWidget {
  final NfcCardViewModel cardViewModel = Get.find<NfcCardViewModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeViewModel>(builder: (empController) {
      return Scaffold(
        appBar: Header(context: context, title: ConstString.addNewEmployee, middleText: "".tr),
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: secondaryColor, blurRadius: 10, spreadRadius: 0.2)],
                      color: secondaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          ConstString.employeeDetails,
                          style: AppStyles.headLineStyle1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: secondaryColor, blurRadius: 10, spreadRadius: 0.2)],
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(15),
                      ),
                    ),
                    child: Wrap(
                      clipBehavior: Clip.hardEdge,
                      direction: Axis.horizontal,
                      runSpacing: 50,
                      spacing: 25,
                      alignment: WrapAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomTextField(controller: empController.fullNameController, title: "الاسم الكامل".tr),
                        CustomTextField(
                          controller: empController.mobileNumberController,
                          title: 'رقم الموبايل'.tr,
                          keyboardType: TextInputType.phone,
                          isNumeric: true,
                        ),
                        CustomTextField(controller: empController.addressController, title: 'العنوان'.tr),
                        CustomTextField(controller: empController.nationalityController, title: 'الجنسية'.tr),
                        CustomDropDown(
                          value: empController.genderController.text.tr,
                          listValue: sexList
                              .map(
                                (e) => e.tr,
                              )
                              .toList(),
                          label: 'الجنس'.tr,
                          onChange: (value) {
                            if (value != null) {
                              empController.genderController.text = value.tr;
                              empController.update();
                            }
                          },
                        ),
                        CustomTextField(controller: empController.ageController, title: 'العمر'.tr, keyboardType: TextInputType.number, isNumeric: true),
                        CustomTextField(controller: empController.dayWorkController, title: 'عدد ايام العمل'.tr, keyboardType: TextInputType.number, isNumeric: true),
                        CustomDropDown(
                            value: empController.jobTitleController.text,
                            listValue: jobList
                                .map(
                                  (e) => e.tr,
                                )
                                .toList(),
                            label: 'الوظيفة'.tr,
                            onChange: (value) {
                              if (value != null) {
                                empController.jobTitleController.text = value.tr;
                                empController.update();
                              }
                            }),
                        CustomTextField(controller: empController.salaryController, title: 'الراتب'.tr, keyboardType: TextInputType.number, isNumeric: true),
                        CustomDropDown(
                          value: empController.contractController.text,
                          listValue: contractsList
                              .map(
                                (e) => e.tr,
                              )
                              .toList(),
                          label: 'العقد'.tr,
                          onChange: (value) {
                            if (value != null) {
                              empController.contractController.text = value.tr;
                              empController.update();
                            }
                          },
                        ),
                        CustomDropDown(
                          value: empController.busValue,
                          listValue: Get.find<BusViewModel>()
                                  .busesMap
                                  .values
                                  .map(
                                    (e) => e.name!,
                                  )
                                  .toList() +
                              ['بدون حافلة'],
                          label: 'الحافلة'.tr,
                          onChange: (value) {
                            if (value != null) {
                              empController.busValue = value;
                              final busViewController = Get.find<BusViewModel>();
                              if (busViewController.busesMap.isNotEmpty) {
                                empController.busController.text = busViewController.busesMap.values
                                        .where(
                                          (element) => element.name == value,
                                        )
                                        .firstOrNull
                                        ?.busId ??
                                    value;
                              } else
                                empController.busController.text = value;
                              empController.update();
                            }
                          },
                        ),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2100),
                            ).then((date) {
                              if (date != null) {
                                empController.startDateController.text = date.toString().split(" ")[0];
                              }
                            });
                          },
                          child: CustomTextField(
                            controller: empController.startDateController,
                            title: 'تاريخ البداية'.tr,
                            enable: false,
                            keyboardType: TextInputType.datetime,
                            icon: Icon(
                              Icons.date_range_outlined,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        CustomTextField(controller: empController.userNameController, title: 'اسم المستخدم'.tr, keyboardType: TextInputType.text),
                        CustomTextField(
                          controller: empController.userPassController,
                          title: 'كلمة المرور'.tr,
                          keyboardType: TextInputType.text,
                          isNumeric: true,
                        ),
                        CustomDropDown(
                          value: empController.selectedCardId,
                          enable: true,

                          ///get Available card (not used from user )
                          listValue: cardViewModel.nfcCardMap.entries
                              .where(
                                (element) {
                                  /// اذا لم تكن البطاقة المختارة
                                  if (element.key != empController.selectedCardId)
                                    return element.value.userId == null;
                                  else
                                    return true;
                                },
                              )
                              .map(
                                (e) => e.key,
                              )
                              .toList(),
                          label: "رقم البطاقة".tr,
                          onChange: (value) {
                            if (value != null) {
                              empController.selectedCardId = value;
                              empController.update();
                            }
                          },
                        ),
                        CustomDropDown(
                          value: empController.role.toString(),
                          listValue: accountType.entries.map((e) => e.value.toString().tr).toList(),
                          label: "الدور".tr,
                          onChange: (_) {
                            empController.role = _!;
                            empController.update();
                          },
                        ),
                        if (empController.enableEdit) CustomTextField(controller: empController.editController, title: 'سبب التعديل'.tr, keyboardType: TextInputType.text),
                        GetBuilder<EmployeeViewModel>(builder: (controller) {
                          return AppButton(
                              text: "حفظ".tr,
                              onPressed: () {
                                empController.saveEmployee(context);
                              });
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              if (empController.enableEdit) EmployeeEventContainer(),
              /* Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<EventViewModel>(builder: (eventController) {
                        return Wrap(
                          runAlignment: WrapAlignment.spaceAround,
                          runSpacing: 25,
                          children: [
                            CustomDropDownWithValue(
                              value: '',
                              mapValue: eventController.allEvents.values
                                  .toList()
                                  .where(
                                    (element) => element.role == Const.eventTypeEmployee,
                                  )
                                  .map((e) => e)
                                  .toList(),
                              label: "نوع الحدث".tr,
                              onChange: (selectedWay) {
                                if (selectedWay != null) {

                                 empController.selectedEvent = eventController.allEvents[selectedWay];
                                  empController.update();
                                }
                              },
                            ),
                            SizedBox(width: 16.0),
                            CustomTextField(
                              controller: empController.bodyEvent,
                              title: 'الوصف'.tr,
                              enable: true,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(width: 16.0),
                            AppButton(
                              text: 'إضافة سجل حدث'.tr,
                              onPressed: () {
                                setState(() {
                                  empController.eventRecords.add(EventRecordModel(
                                    body: empController.bodyEvent.text,
                                    type: empController.selectedEvent!.name,
                                    date: thisTimesModel!.dateTime.toString().split(".")[0],
                                    color: empController.selectedEvent!.color.toString(),
                                  ));
                                  empController.bodyEvent.clear();
                                });
                              },
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: defaultPadding * 2),
                      Text('سجل الأحداث:'.tr, style: Styles.headLineStyle1),
                      SizedBox(height: defaultPadding),
                      Container(
                        padding: EdgeInsets.all(0.0),
                        alignment: Alignment.center,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: empController.eventRecords.length,
                          itemBuilder: (context, index) {
                            final record = empController.eventRecords[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(int.parse(record.color)).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        record.type,
                                        style: Styles.headLineStyle1.copyWith(color: Colors.black),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        record.body,
                                        style: Styles.headLineStyle1.copyWith(color: Colors.black),
                                      ),
                                      SizedBox(width: 50),
                                      Text(
                                        record.date,
                                        style: Styles.headLineStyle3,
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )*/
            ],
          ),
        ),
      );
    });
  }

  EmployeeInputForm();
}
