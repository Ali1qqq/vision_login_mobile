import 'package:flutter/material.dart';

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

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Wrap(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("صورة الفاتورة".tr),
              SizedBox(height: 15),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildAddImageButton(controller),
                    ...buildImageList(controller.ImagesTempData, controller, true),
                    ...buildImageList(controller.imageLinkList, controller, false),
                  ],
                ),
              ),
            ],
          ),
              AppButton(
                text: "حفظ".tr,
                onPressed: () async {
                  controller.saveExpenses(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }


}

