import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:vision_dashboard/screens/Salary/controller/Salary_View_Model.dart';

import '../../../constants.dart';
import '../../../models/account_management_model.dart';
import '../../core/Styling/app_style.dart';
import '../Widgets/Custom_Text_Filed.dart';
import '../Widgets/AppButton.dart';

AlertDialog buildSignViewDialog(String text, EmployeeModel account, String date, GlobalKey<SfSignaturePadState> signatureGlobalKey, BuildContext context) {
  TextEditingController salaryReceived = TextEditingController();
  TextEditingController salaryMonth = TextEditingController();
  TextEditingController notsController = TextEditingController();
  return AlertDialog(
    backgroundColor: secondaryColor,
    actions: [
      GetBuilder<SalaryViewModel>(builder: (controller) {
        return Container(
          height: Get.height / 2,
          width: Get.width / 2,
          color: secondaryColor,
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Text(
                "يرجى التوقيع من قبل الموظف".tr,
                style: AppStyles.headLineStyle1,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              CustomTextField(
                controller: salaryMonth..text = text.toString(),
                title: "الراتب المستحق".tr,
                enable: false,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              CustomTextField(controller: salaryReceived..text = text.toString(), title: "الراتب الممنوح".tr),
              SizedBox(
                height: defaultPadding,
              ),
              CustomTextField(controller: notsController, title: "ملاحظات".tr),
              SizedBox(
                height: defaultPadding,
              ),
              Padding(padding: EdgeInsets.all(10), child: Container(child: SfSignaturePad(key: signatureGlobalKey, backgroundColor: Colors.white, strokeColor: Colors.black, minimumStrokeWidth: 1.0, maximumStrokeWidth: 4.0), decoration: BoxDecoration(border: Border.all(color: Colors.grey)))),
              SizedBox(height: 10),
              Row(children: <Widget>[
                AppButton(
                    text: "حفظ".tr,
                    onPressed: () {
                      controller.handleSaveButtonPressed(salaryReceived.text, account.id, date, account.salary.toString(), text, context, notsController.text);
                    }),
                AppButton(text: "اعادة".tr, onPressed: controller.handleClearButtonPressed),
              ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
            ],
          ),
        );
      })
    ],
  );
}

AlertDialog buildSignImageView(String image) {
  return AlertDialog(
    backgroundColor: secondaryColor,
    actions: [
      GetBuilder<SalaryViewModel>(builder: (controller) {
        return Container(
          height: Get.height / 3,
          width: Get.width / 3,
          color: secondaryColor,
          child: Column(children: [
            Text(
              "التوقيع",
              style: AppStyles.headLineStyle2,
            ),
            Expanded(
              child: Image.network(
                image,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {

                    return child;
                  } else {
                    // الصورة قيد التحميل - إظهار مؤشر تحميل
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  // في حالة حدوث خطأ أثناء تحميل الصورة
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            )

          ]),
        );
      })
    ],
  );
}
