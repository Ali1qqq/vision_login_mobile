import 'package:flutter/material.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';
import 'package:vision_dashboard/screens/Widgets/Insert_shape_Widget.dart';
import 'package:vision_dashboard/screens/Widgets/header.dart';

import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';
import 'package:get/get.dart';

import 'package:vision_dashboard/screens/Widgets/AppButton.dart';

import '../../../constants.dart';
import '../../Widgets/Custom_Text_Filed.dart';
import '../../Widgets/MultiLine_CustomTextField.dart';

import 'Widgets/AddImageButton.dart';
import 'Widgets/ImageListWidget.dart';

class ExpensesInputForm extends StatelessWidget {
  const ExpensesInputForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesViewModel>(builder: (controller) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: Header(title: controller.expensesModel==null?"اضافة مصروف جديد":"تعديل مصروف", middleText: "", context: context),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: InsertShapeWidget(
              titleWidget: Text(
                "معلومات المصروف",
                style: AppStyles.headLineStyle1,
              ),
              bodyWidget: Wrap(
                clipBehavior: Clip.hardEdge,
                direction: Axis.horizontal,
                runSpacing: 25,
                spacing: 25,
                children: [
                  CustomTextField(
                    controller: controller.titleController,
                    title: 'العنوان'.tr,
                  ),
                  CustomTextField(
                    controller: controller.totalController,
                    title: 'القيمة'.tr,
                    isNumeric: true,
                  ),
                  InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2100),
                      ).then((date) {
                        if (date != null) {
                          controller.dateController.text = date.toString().split(" ")[0];
                        }
                      });
                    },
                    child: CustomTextField(
                      controller: controller.dateController,
                      title: 'التاريخ'.tr,
                      enable: false,
                      keyboardType: TextInputType.datetime,
                      icon: Icon(
                        Icons.date_range_outlined,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  multiLineCustomTextField(
                    controller: controller.bodyController,
                    title: 'الوصف'.tr,
                  ),
                  buildAddImageButton(controller),
                  ...buildImageList(controller.ImagesTempData, controller, true),
                  ...buildImageList(controller.imageLinkList, controller, false),

                  AppButton(
                    text: "حفظ".tr,
                    onPressed: () async {
                      controller.saveExpenses(context);
                    },
                  ),
                ],
              ),
            )),
      );
    });
  }
}
