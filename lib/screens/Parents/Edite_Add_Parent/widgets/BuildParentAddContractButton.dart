import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../Controller/Parents_View_Model.dart';


Widget BuildParentAddContractButton(ParentsViewModel parentController) {
  return InkWell(
    onTap: () async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
      if (result != null) {

          parentController.contractsTemp.addAll(result.files.map((file) => file.bytes!));
          parentController.update();

      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
        height: 200,
        width: 200,
        child: Icon(Icons.add),
      ),
    ),
  );
}