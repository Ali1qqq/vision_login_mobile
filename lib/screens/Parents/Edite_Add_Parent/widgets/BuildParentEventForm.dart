import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../utils/const.dart';
import '../../../Widgets/AppButton.dart';
import '../../../Widgets/Custom_Drop_down_with_value.dart';
import '../../../Widgets/Custom_Text_Filed.dart';
import '../../../event/Controller/event_view_model.dart';
import '../../Controller/Parents_View_Model.dart';

Widget BuildParentEventForm(ParentsViewModel parentsViewModel) {
  return GetBuilder<EventViewModel>(builder: (eventController) {
    return Wrap(
      runAlignment: WrapAlignment.spaceAround,
      runSpacing: 25,
      children: [
        CustomDropDownWithValue(
          value: '',
          mapValue: eventController.allEvents.values
              .toList()
              .where((element) => element.role == Const.eventTypeParent)
              .toList(),
          label: "نوع الحدث".tr,
          onChange: (selectedWay) {
            if (selectedWay != null) {
              parentsViewModel.selectedEvent = eventController.allEvents[selectedWay];
              parentsViewModel.update();
            }
          },
        ),
        SizedBox(width: 16.0),
        CustomTextField(
          controller:     parentsViewModel.bodyEventController,
          title: 'الوصف'.tr,
          enable: true,
          keyboardType: TextInputType.text,
        ),
        SizedBox(width: 16.0),
        AppButton(
          text: 'إضافة سجل حدث'.tr,
          onPressed: (){parentsViewModel.addEventRecord();},
        ),
      ],
    );
  });
}