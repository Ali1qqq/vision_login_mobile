import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Parents/Edite_Add_Parent/widgets/BuildParentAddContractButton.dart';
import 'package:vision_dashboard/screens/Parents/Edite_Add_Parent/widgets/EventParentContainer.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Insert_shape_Widget.dart';
import 'package:vision_dashboard/screens/Widgets/header.dart';
import '../../../constants.dart';
import '../../../core/Styling/app_style.dart';
import '../../../core/Utils/Strings.dart';
import '../../Widgets/Custom_Text_Filed.dart';

class ParentInputForm extends StatelessWidget {
  ParentInputForm();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentsViewModel>(builder: (parentController) {
      return Scaffold(
        appBar: Header(title: ConstString.addNewParent, middleText: "", context: context),
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
                bodyWidget: Wrap(
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
                      isNumeric: true,
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
                      controller: parentController.ageController,
                      title: 'العمر'.tr,
                      keyboardType: TextInputType.number,
                      isNumeric: true,
                    ),
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
                    if (parentController.parent != null) CustomTextField(controller: parentController.editController, title: 'سبب التعديل'.tr),
                    BuildParentAddContractButton(parentController),
                    AppButton(
                        text: 'حفظ'.tr,
                        onPressed: () {
                          parentController.saveParentData(context);
                        }),
                  ],
                ),
              ),
              SizedBox(height: defaultPadding),
              if (parentController.parent != null) ParentEventContainer()
            ],
          ),
        ),
      );
    });
  }
}
