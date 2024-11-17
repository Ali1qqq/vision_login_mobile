
import 'package:flutter/material.dart';
import 'package:vision_dashboard/models/event_record_model.dart';

import '../../../../core/constant/constants.dart';
import '../../../../core/Styling/app_style.dart';

Widget BuildParentEventRecordItem(EventRecordModel record,VoidCallback onPress) {
  return Container(
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
            style: AppStyles.headLineStyle1.copyWith(color: Colors.black),
          ),
          SizedBox(width: 10),
          Text(
            record.body,
            style: AppStyles.headLineStyle1.copyWith(color: Colors.black),
          ),
          SizedBox(width: 50),
          Text(
            record.date,
            style: AppStyles.headLineStyle3,
          ),
          Spacer(),
          IconButton(
            onPressed: onPress,
            icon: Icon(
              Icons.delete,
              color: primaryColor,
            ),
          ),
        ],
      ),
    ),
  );
}