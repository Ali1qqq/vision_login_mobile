import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/constant/const.dart';
import '../../../Widgets/Custom_Drop_down_with_value.dart';
import '../../../event/Controller/event_view_model.dart';
import '../../Controller/Employee_view_model.dart';

Widget BuildEmployeeEventTypeDropdown(EventViewModel eventController,EmployeeViewModel empController) {
  return CustomDropDownWithValue(
    value: '',
    mapValue: eventController.allEvents.values
        .toList()
        .where((element) => element.role == Const.eventTypeEmployee)
        .map((e) => e)
        .toList(),
    label: "نوع الحدث".tr,
    onChange: (selectedWay) {
      if (selectedWay != null) {
        empController.selectedEvent = eventController.allEvents[selectedWay];
        empController.update();
      }
    },
  );
}