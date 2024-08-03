
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';
import '../screens/Widgets/AppButton.dart';

getReedOnlyError(BuildContext context, {String title = "هذا العنصر للعرض فقط"}) {
  QuickAlert.show(context: context, type: QuickAlertType.error, title: title.tr, confirmBtnText: "تم".tr);
}

loadingQuickAlert(
  BuildContext context,
) {
  QuickAlert.show(
    width: Get.width / 2,
    context: context,
    type: QuickAlertType.loading,
    title: 'جاري التحميل'.tr,
    text: 'يتم العمل على الطلب'.tr,
    barrierDismissible: false,
  );
}


getConfirmDialog(BuildContext context, {String title = "هل انت متأكد؟", required VoidCallback onConfirm}) {
  QuickAlert.show(context: context, type: QuickAlertType.confirm, title: title.tr, onCancelBtnTap: () => Get.back(), onConfirmBtnTap: onConfirm, confirmBtnText: "نعم".tr, cancelBtnText: "لا".tr, cancelBtnTextStyle: AppStyles.headLineStyle2);
}

getSuccessDialog(
  BuildContext context,
) {
  QuickAlert.show(
    context: context,
    title: "تمت العملية بنجاح".tr,
    type: QuickAlertType.success,
    confirmBtnText: "تم".tr,
  );
}



void showErrorDialog(String title, String message) {
  Get.defaultDialog(
    title: title,
    titleStyle: AppStyles.headLineStyle2,
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



