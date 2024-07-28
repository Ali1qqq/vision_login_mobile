import 'dart:async';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/models/TimeModel.dart';
import 'package:http/http.dart' as http;
import '../screens/Widgets/AppButton.dart';

getReedOnlyError(BuildContext context,
    {String title = "هذا العنصر للعرض فقط"}) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title.tr,
      confirmBtnText: "تم".tr);
}

getConfirmDialog(BuildContext context,
    {String title = "هل انت متأكد؟", required VoidCallback onConfirm}) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    title: title.tr,
    onCancelBtnTap: () => Get.back(),
    onConfirmBtnTap: onConfirm,
    confirmBtnText: "نعم".tr,
    cancelBtnText: "لا".tr,
      cancelBtnTextStyle:Styles.headLineStyle2
  );
}
getSuccessDialog(BuildContext context,) {
  QuickAlert.show(
    context: context,
    title: "تمت العملية بنجاح".tr,
    type: QuickAlertType.success,
    confirmBtnText: "تم".tr,
  );
}

Future<List<String>> uploadImages(List<Uint8List> ImagesTempData,
    String folderName) async {
  List<String> imageLinkList = [];
  for (var i in ImagesTempData) {
    final storageRef = FirebaseStorage.instance.ref().child(
        'images/$folderName/${DateTime
            .now()
            .millisecondsSinceEpoch}.png');
    await storageRef.putData(i);
    final imageLink = await storageRef.getDownloadURL();
    imageLinkList.add(imageLink);
  }
  return imageLinkList;
}

void showErrorDialog(String title, String message) {
  Get.defaultDialog(
    title: title,
    titleStyle: Styles.headLineStyle2,
    backgroundColor: secondaryColor,
    middleText: message,
    confirmTextColor: Colors.white,
    confirm: AppButton(
      text: "موافق",
      onPressed: () {
        Get.back();
      },
    ),
    /*   textConfirm: "موافق",
    onConfirm: () {
      Get.back();
    },*/
    barrierDismissible: false,
  );
}

bool isNumeric(String str) {
  final number = num.tryParse(str);
  return number != null;
}

bool validateNotEmpty(String value, String fieldName) {
  if (value.isEmpty) {
    showErrorDialog("خطأ", "$fieldName لا يمكن أن يكون فارغًا");
    return false;
  }
  return true;
}

bool validateNumericField(String value, String fieldName) {
  if (value.isEmpty || !isNumeric(value)) {
    showErrorDialog("خطأ", "$fieldName يجب أن يحتوي على أرقام فقط");
    return false;
  }
  return true;
}

Future<TimesModel?> getTime() async {
  TimesModel? timesModel;
  try {

    final response = await http.get(Uri.parse(
        "http://worldtimeapi.org/api/timezone/Asia/Dubai"));
    print("response statusCode  ${response.statusCode}");
    // print(response.body);
    // final response = await http.get(uri,);
    if (response.statusCode == 200) {
      timesModel = TimesModel.fromJson(jsonDecode(response.body));
    }

    else {
      timesModel = TimesModel(year: DateTime
          .now()
          .year,
          month: DateTime
              .now()
              .month,
          day: DateTime
              .now()
              .day,
          hour:DateTime.now(). hour,
          minute:DateTime.now(). minute,
          seconds: DateTime.now().second,
          milliSeconds:DateTime.now(). millisecond,
          dateTime: DateTime.now(),
          date:DateTime.now(). toString().split(" ")[0],
          // time:DateTime.now(). toString().split(" ")[1],
          timeZone:DateTime.now(). timeZoneName,
          dayOfWeek:DateTime.now().day.toString(),
          // dstActive: true

      );
    }
  } on Exception catch (e) {
    // TODO
    print(e.toString());
    timesModel = TimesModel(year: DateTime
        .now()
        .year,
        month: DateTime
            .now()
            .month,
        day: DateTime
            .now()
            .day,
        hour:DateTime.now(). hour,
        minute:DateTime.now(). minute,
        seconds: DateTime.now().second,
        milliSeconds:DateTime.now(). millisecond,
        dateTime: DateTime.now(),
        date:DateTime.now(). toString().split(" ")[0],
        // time:DateTime.now(). toString().split(" ")[1],
        timeZone:DateTime.now(). timeZoneName,
        dayOfWeek:DateTime.now().day.toString(),
        // dstActive: true
    );
  }
  thisTimesModel=timesModel;
  return timesModel;
}
