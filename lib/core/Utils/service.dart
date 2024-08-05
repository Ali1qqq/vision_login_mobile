import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../utils/Dialogs.dart';

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



/*Future<TimesModel?> getTime() async {
  TimesModel? timesModel;
  try {
    final response = await http.get(Uri.parse("https://worldtimeapi.org/api/timezone/Asia/Dubai"));
    print("response statusCode  ${response.statusCode}");
    if (response.statusCode == 200) {
      timesModel = TimesModel.fromJson(jsonDecode(response.body));
    } else {
      timesModel = TimesModel(
        year: DateTime.now().year,
        month: DateTime.now().month,
        day: DateTime.now().day,
        hour: DateTime.now().hour,
        minute: DateTime.now().minute,
        seconds: DateTime.now().second,
        milliSeconds: DateTime.now().millisecond,
        dateTime: DateTime.now(),
        date: DateTime.now().toString().split(" ")[0],
        timeZone: DateTime.now().timeZoneName,
        dayOfWeek: DateTime.now().day.toString(),
      );
    }
  } on Exception catch (e) {
    // TODO
    print(e.toString());
    timesModel = TimesModel(
      year: DateTime.now().year,
      month: DateTime.now().month,
      day: DateTime.now().day,
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
      seconds: DateTime.now().second,
      milliSeconds: DateTime.now().millisecond,
      dateTime: DateTime.now(),
      date: DateTime.now().toString().split(" ")[0],
      // time:DateTime.now(). toString().split(" ")[1],
      timeZone: DateTime.now().timeZoneName,
      dayOfWeek: DateTime.now().day.toString(),
      // dstActive: true
    );
  }
  thisTimesModel = timesModel;
  return timesModel;
}*/

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