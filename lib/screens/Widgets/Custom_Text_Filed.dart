import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';


class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,  this. keyboardType,this.enable,this.hint,this.onChange,this.size,this.isFullBorder,this.icon,
    this.isNumeric = false,

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
  final bool isNumeric;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_convertArabicNumbersToEnglish);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_convertArabicNumbersToEnglish);
    super.dispose();
  }

  void _convertArabicNumbersToEnglish() {
    if(widget.isNumeric) {
      final text = widget.controller.text;
      final convertedText = text.replaceAllMapped(
        RegExp(r'[٠-٩]'),
        (match) => (match.group(0)!.codeUnitAt(0) - 0x660).toString(),
      );

      if (text != convertedText) {
        widget.controller.value = widget.controller.value.copyWith(
          text: convertedText,
          selection: TextSelection.collapsed(offset: convertedText.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: max(150,widget.size?? Get.width/4.5),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,style:  AppStyles.headLineStyle3,),
          SizedBox(height: 10,),
          TextFormField(
            onChanged: widget.onChange,
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            enabled: widget.enable,
            decoration: InputDecoration(
              hintText: widget.hint,
              suffixIcon:widget.icon ,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:secondaryColor,width: 2),
              ),
              disabledBorder:OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor,width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor,width: 4),
                // borderRadius: BorderRadius.circular(10),
              ),

            ),
          ),
        ],
      ),
    );
  }
}