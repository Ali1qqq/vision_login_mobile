
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/Styling/app_style.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.index,
    required this.svgSrc,
    required this.controller
  }) : super(key: key);

  final String title, svgSrc;
  final int index;
  final HomeViewModel controller;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale.toString() != "en_US" ? TextDirection.rtl : TextDirection.ltr,
      child: controller.isDrawerOpen
          ? Container(

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 20,),
            Image.asset(
              svgSrc,
              height: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                title,
                style: AppStyles.headLineStyle3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      )
          : Center(
        child: Image.asset(
          svgSrc,
          height: 26,
        ),
      ),
    );
  }
}