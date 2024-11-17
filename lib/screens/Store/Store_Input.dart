import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';
import 'package:vision_dashboard/models/Store_Model.dart';
import 'package:vision_dashboard/screens/Store/Controller/Store_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Insert_shape_Widget.dart';
import 'package:vision_dashboard/screens/Widgets/header.dart';

import '../../core/constant/constants.dart';

import '../Widgets/Custom_Text_Filed.dart';

class StoreInputForm extends StatefulWidget {
  StoreInputForm();

  @override
  _StoreInputFormState createState() => _StoreInputFormState();
}

class _StoreInputFormState extends State<StoreInputForm> {
  final TextEditingController subNameController = TextEditingController();
  final TextEditingController subQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    subQuantityController.clear();
    subNameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header(title: "اضافة مادة جديدة", middleText: "", context: context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InsertShapeWidget(
              titleWidget: Text(
                "معلومات المادة",
                style: AppStyles.headLineStyle1,
              ),
              bodyWidget: Wrap(

                clipBehavior: Clip.hardEdge,
                direction: Axis.horizontal,
                runSpacing: 50,
                spacing: 50,
crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(controller: subNameController, title: 'اسم المادة'.tr),
                  CustomTextField(controller: subQuantityController, title: 'الكمية'.tr, keyboardType: TextInputType.number),
                  AppButton(
                    text: 'حفظ'.tr,
                    onPressed: () {
                      StoreModel store = StoreModel(
                        isAccepted: true,
                        subName: subNameController.text,
                        subQuantity: subQuantityController.text,
                        id: generateId("SUB"),
                      );

                      Get.find<StoreViewModel>().addStore(store);
                      // يمكنك تنفيذ الإجراءات التالية مثل إرسال البيانات إلى قاعدة البيانات
                      print('store Model: $store');
                    },
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
