import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,  this. keyboardType,this.enable,this.hint,this.onChange,this.size,this.isFullBorder,this.icon
  });
  final bool? isFullBorder;

  final TextEditingController controller;
  final String title;
  final String? hint;
  final TextInputType? keyboardType;
  final bool? enable;
  final Function(String? value)? onChange;
  final double? size;
  final Icon? icon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: max(150,size?? Get.width/4.5),

      child:TextFormField(
        onChanged: onChange,
        keyboardType: keyboardType,
        controller: controller,
        enabled: enable,
        decoration: InputDecoration(
          labelText: title,
          hintText: hint,

          suffixIcon:icon ,
          labelStyle: TextStyle(color: primaryColor),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          disabledBorder:isFullBorder!=null? OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor,width: 2),
            borderRadius: BorderRadius.circular(10),
          ):UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor,width: 2),
            borderRadius: BorderRadius.circular(10),
          ),

        ),
      ),
    );
  }
}