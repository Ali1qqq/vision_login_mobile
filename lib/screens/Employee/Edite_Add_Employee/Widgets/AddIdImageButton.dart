import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';



Widget buildAddIdImageButton(EmployeeViewModel controller) {
  return InkWell(
    onTap: () async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null) {
        result.files.forEach((element) {
          controller.imagesTempData.add(element.bytes!);
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
        height: 200,
        width: 200,
        child: Icon(Icons.add),
      ),
    ),
  );
}