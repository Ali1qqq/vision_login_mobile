// دالة لفرز الدفعات بناءً على تاريخ الدفعة
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';

import '../../../../core/constant/constants.dart';
import '../../../../models/Installment_model.dart';
import '../../../Widgets/Custom_Text_Filed.dart';

Widget buildInstallmentItem(BuildContext context, InstallmentModel oneInstallment, bool cantEdit, int index, ParentsViewModel parentController) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(width: 2.0, color: primaryColor),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Spacer(),
          InkWell(
            onTap: () => _selectDate(context, cantEdit, index, parentController),
            child: CustomTextField(
              controller: parentController.monthsController[index],
              title: 'تاريخ البداية'.tr,
              enable: false,
              keyboardType: TextInputType.datetime,
              icon: Icon(Icons.date_range_outlined, color: primaryColor),
            ),
          ),
          Spacer(),
          CustomTextField(
            enable: !cantEdit,
            controller: parentController.costsController[index],
            title: "الدفعة".tr,
            isNumeric: true,
            size: Get.width / 5.5,
            keyboardType: TextInputType.number,
          ),
          Spacer(),
          IconButton(
            onPressed: () => _removeInstallment(oneInstallment.installmentId, parentController),
            icon: Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
    ),
  );
}

void _selectDate(BuildContext context, bool cantEdit, int index, ParentsViewModel parentController) {
  if (!cantEdit) {
    showDatePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime(2100),
    ).then((date) {
      if (date != null) {
        parentController.monthsController[index].text = date.toString().split(" ")[0];
      }
    });
  }
}

void _removeInstallment(String? installmentId, ParentsViewModel parentController) {
  if (installmentId != null) {
    parentController.instalmentMap.remove(installmentId);
    parentController.update();
  }
}
