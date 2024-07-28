
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/Store_Model.dart';
import 'package:vision_dashboard/screens/Store/Controller/Store_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';

import '../../constants.dart';


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
    // TODO: implement initState
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
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // clipBehavior: Clip.hardEdge,
                // direction: Axis.horizontal,
                // runSpacing: 80,
                // alignment: WrapAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(controller: subNameController, title: 'اسم المادة'.tr),
                  CustomTextField(controller: subQuantityController, title: 'الكمية'.tr,keyboardType: TextInputType.number),


                ],
              ),
            ),

            SizedBox(height: defaultPadding * 2),
            AppButton(text: 'حفظ'.tr,   onPressed: () {

              StoreModel store = StoreModel(
                isAccepted: true,
                subName:  subNameController.text,
                subQuantity: subQuantityController.text,
                id: generateId("SUB"),

              );

              Get.find<StoreViewModel>().addStore(store);
              // يمكنك تنفيذ الإجراءات التالية مثل إرسال البيانات إلى قاعدة البيانات
              print('store Model: $store');
            },)

          ],
        ),
      ),
    );

  }
}

