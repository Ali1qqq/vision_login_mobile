import 'package:vision_dashboard/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/controller/NFC_Card_View_model.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';
import 'package:vision_dashboard/core/Utils/Strings.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/screens/Employee/Edite_Add_Employee/Widgets/AddIdImageButton.dart';
import 'package:vision_dashboard/screens/Employee/Edite_Add_Employee/Widgets/EventControllerWidget.dart';
import 'package:vision_dashboard/screens/Employee/Edite_Add_Employee/Widgets/IdImageListWidget.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down.dart';
import 'package:vision_dashboard/screens/Widgets/Insert_shape_Widget.dart';
import '../../Buses/Controller/Bus_View_Model.dart';
import '../../Widgets/Custom_Text_Filed.dart';
import '../../Widgets/header.dart';

class EmployeeInputForm extends StatelessWidget {
  final NfcCardViewModel cardViewModel = Get.find<NfcCardViewModel>();
  EmployeeInputForm({this. viewOnly=false});
  final bool viewOnly;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeViewModel>(builder: (empController) {
      return Scaffold(
        appBar: Header(context: context, title: empController.employeeModel == null ? ConstString.addNewEmployee : empController.employeeModel!.fullName!, middleText: "".tr),
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InsertShapeWidget(
                titleWidget: Text(
                  ConstString.employeeDetails,
                  style: AppStyles.headLineStyle1,
                ),
                bodyWidget: Wrap(
                  clipBehavior: Clip.hardEdge,
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceEvenly,
                  runSpacing: 50,
                  spacing: 25,
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
                          ['مع حافلة', 'بدون حافلة'],
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
                              if (element.value.nfcId != empController.selectedCardId)
                                return element.value.userId == null||element.value.userId == '';
                              else
                                return true;
                            },
                          )
                          .map(
                            (e) => e.value.nfcId.toString()??'',
                          )
                          .toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b))),
                      label: "رقم البطاقة".tr,
                      onChange: (value) {
                        if (value != null) {
                          print(value);
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("صورة الهوية".tr),
                        SizedBox(height: 15),
                        SizedBox(
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              if(!viewOnly)
                              buildAddIdImageButton(empController),

                              ...buildIdImageList(empController.imagesTempData, empController, true),
                              ...buildIdImageList(empController.imageLinkList, empController, false),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (empController.enableEdit&&!viewOnly) CustomTextField(controller: empController.editController, title: 'سبب التعديل'.tr, keyboardType: TextInputType.text),
                    if(!viewOnly)
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
              SizedBox(height: 16.0),
              if (empController.enableEdit) EmployeeEventContainer(),
            ],
          ),
        ),
      );
    });
  }


}
