import 'package:flutter/material.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';

import '../../../../constants.dart';
import '../../../../models/event_record_model.dart';

Widget buildEventRecordsList(EmployeeViewModel controller) {
  return Container(
    padding: EdgeInsets.all(0.0),
    alignment: Alignment.center,
    child: ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: controller.eventRecords.length,
      itemBuilder: (context, index) {
        final record = controller.eventRecords[index];
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
                  _buildRecordDetails(record),
                  Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
Widget _buildRecordDetails(EventRecordModel record) {
  return Row(
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
    ],
  );
}