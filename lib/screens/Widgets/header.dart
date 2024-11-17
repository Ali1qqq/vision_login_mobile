import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';

import '../../core/constant/constants.dart';



AppBar Header({required String  title,required String middleText,required BuildContext context, bool haveBack=false}) {

  return AppBar(
    toolbarHeight: 60,
    backgroundColor: bgColor,
    elevation: 0,
    surfaceTintColor:bgColor ,
    leading: IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        HomeViewModel homeViewModel = Get.find<HomeViewModel>();
        homeViewModel.controlMenu();
      },
    ),

    centerTitle: false,
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            title,
            style:
            Get.width<500?AppStyles.headLineStyle2:
            AppStyles.headLineStyle1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
            onPressed: () {
              QuickAlert.show(
                  width: Get.width/2,
                  context: context,
                  type: QuickAlertType.info,
                title: middleText,
                confirmBtnText: "تم".tr
              );

            },
            icon: Icon(Icons.info_outline,color: primaryColor,))
      ],
    ),
    actions: [
      if(haveBack)
Directionality(
    textDirection: TextDirection.ltr,
    child: IconButton(onPressed: (){
      Get.back();
    }, icon: Icon(Icons.arrow_back_ios,color: Colors.blue,)))
    ],
  );
}


