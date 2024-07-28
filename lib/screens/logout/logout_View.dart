
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/main/main_screen.dart';

import '../../utils/Hive_DataBase.dart';
import '../Widgets/header.dart';
import '../login/login_screen.dart';

class LogoutView extends StatefulWidget {
  const LogoutView({super.key});

  @override
  State<LogoutView> createState() => _LogoutViewState();
}

class _LogoutViewState extends State<LogoutView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: Header(
          context: context,
          title: 'تسجيل الخروج'.tr,
          middleText:
          "يمكنك تسجيل الخروج في هذه الواجهة"
              .tr),
      body: Center(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset("assets/logotPng.png",height: 150),
            SizedBox(height: defaultPadding,),
            Text("هل انت متأكد؟".tr,style: Styles.headLineStyle1,),
            SizedBox(height: defaultPadding,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                AppButton(text: "نعم".tr, onPressed: (){

                  HiveDataBase.deleteUserData();
                  Get.offAll(LoginScreen());

                }),
                Spacer(),
                AppButton(text: "لا".tr, onPressed: (){

                  HiveDataBase.setCurrentScreen("0");
                  Get.offAll(MainScreen());

                }),
                Spacer(),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
