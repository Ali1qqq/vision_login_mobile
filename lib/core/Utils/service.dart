import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../dialogs/Dialogs.dart';

bool validateFields({
  required List<TextEditingController> requiredControllers,
  required List<TextEditingController> numericControllers,
}) {
  if (!_areFieldsFilled(requiredControllers)) {
    showErrorDialog("خطأ".tr, "يرجى ملء جميع الحقول.".tr);
    return false;
  }

  if (!_areNumericFieldsValid(numericControllers)) {
    showErrorDialog("خطأ".tr, "تأكد من أن الحقول الرقمية تحتوي على أرقام فقط.".tr);
    return false;
  }

  return true;
}

bool _areFieldsFilled(List<TextEditingController> controllers) {
  for (var controller in controllers) {
    if (controller.text.isEmpty) {
      return false;
    }
  }
  return true;
}

bool _areNumericFieldsValid(List<TextEditingController> controllers) {
  for (var controller in controllers) {
    if (!isNumeric(controller.text)) {
      return false;
    }
  }
  return true;
}
bool isNumeric(String str) {
  final number = num.tryParse(str);
  return number != null;
}





Future<List<String>> uploadImages(List<Uint8List> ImagesTempData, String folderName) async {
  List<String> imageLinkList = [];
  for (var i in ImagesTempData) {
    final storageRef = FirebaseStorage.instance.ref().child('images/$folderName/${DateTime.now().millisecondsSinceEpoch}.png');
    await storageRef.putData(i);
    final imageLink = await storageRef.getDownloadURL();
    imageLinkList.add(imageLink);
  }
  return imageLinkList;
}