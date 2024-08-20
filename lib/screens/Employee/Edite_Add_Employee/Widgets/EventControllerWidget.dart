import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/screens/Employee/Edite_Add_Employee/Widgets/BuildEventEmployeeRecordsList.dart';
import 'package:vision_dashboard/screens/Employee/Edite_Add_Employee/Widgets/EmployeeEventDropDown.dart';
import 'package:vision_dashboard/screens/Widgets/Insert_shape_Widget.dart';
import '../../../../constants.dart';
import '../../../../core/Styling/app_style.dart';
import '../../../Widgets/AppButton.dart';
import '../../../Widgets/Custom_Text_Filed.dart';
import '../../../event/Controller/event_view_model.dart';

class EmployeeEventContainer extends StatelessWidget {
  final empController = Get.find<EmployeeViewModel>();

  @override
  Widget build(BuildContext context) {
    return InsertShapeWidget(titleWidget: Text("سجل الاحداث",style: AppStyles.headLineStyle1,),bodyWidget: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetBuilder<EventViewModel>(builder: (eventController) {
          return Wrap(
            runAlignment: WrapAlignment.spaceAround,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 25,
            children: [
              BuildEmployeeEventTypeDropdown(eventController, empController),
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
                  empController.addEmployeeEvent();
                },
              ),
            ],
          );
        }),
        SizedBox(height: defaultPadding * 2),
        Text('سجل الأحداث:'.tr, style: AppStyles.headLineStyle1),
        SizedBox(height: defaultPadding),
        buildEventRecordsList(empController),
      ],
    ),);
  }
}
