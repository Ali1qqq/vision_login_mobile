import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';

import '../../../../constants.dart';

import '../../../../core/Styling/app_style.dart';
import 'BuildParentEventForm.dart';
import 'BuildParentEventRecordsList.dart';

class ParentEventContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ParentsViewModel parentsViewModel=Get.find<ParentsViewModel>();
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildParentEventForm(parentsViewModel),
          SizedBox(height: defaultPadding * 2),
          Text('سجل الأحداث:'.tr, style: AppStyles.headLineStyle1),
          SizedBox(height: defaultPadding),
          BuildParentEventRecordsList(parentsViewModel),
        ],
      ),
    );
  }



}
