import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/constants.dart';

class multiLineCustomTextField extends StatelessWidget {
  const multiLineCustomTextField({
    super.key,
    required this.controller,
    required this.title,
  });

  final TextEditingController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width ,
      height: 200,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white12, border: Border.all(color: primaryColor, width: 2), borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.tr, style: TextStyle(color: primaryColor)),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                controller: controller,
                maxLines: null,
                decoration: InputDecoration(
                  //labelText: title,
                    labelStyle: TextStyle(color: primaryColor),
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}