import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

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
      child:TextFormField(
        onChanged: widget.onChange,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        enabled: widget.enable,
        decoration: InputDecoration(
          labelText: widget.title,
          hintText: widget.hint,

          suffixIcon:widget.icon ,
          labelStyle: TextStyle(color: primaryColor),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          disabledBorder:widget.isFullBorder!=null? OutlineInputBorder(
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