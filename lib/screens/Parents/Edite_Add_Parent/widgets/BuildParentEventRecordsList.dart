import 'package:flutter/material.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';

import 'BuildParentEventRecordItem.dart';

Widget BuildParentEventRecordsList(ParentsViewModel parentsViewModel) {
  return Container(
    padding: EdgeInsets.all(0.0),
    alignment: Alignment.center,
    child: ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: parentsViewModel.eventRecords.length,
      itemBuilder: (context, index) {
        final record = parentsViewModel.eventRecords[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: BuildParentEventRecordItem(record),
        );
      },
    ),
  );
}