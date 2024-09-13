import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/expenses_view_model.dart';


Widget buildAddImageButton(ExpensesViewModel controller) {
  return Column(
    children: [
      Text("صورة الفاتورة".tr),
      InkWell(
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.image,
            allowMultiple: true,
          );
          if (result != null) {
            result.files.forEach((element) {
              controller.ImagesTempData.add(element.bytes!);
            });
            controller.update(); // Notify the UI
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 150,
            width: 150,
            child: Icon(Icons.add),
          ),
        ),
      ),
    ],
  );
}