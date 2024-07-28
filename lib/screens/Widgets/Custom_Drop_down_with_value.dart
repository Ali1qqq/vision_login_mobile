import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/event_model.dart';

import '../../constants.dart';

class CustomDropDownWithValue extends StatelessWidget {
  CustomDropDownWithValue({super.key,required this.value,required this.mapValue,required this.label,required this.onChange,this.isFullBorder});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: max(150,Get.width/4.5),
      child: DropdownButtonFormField<String>(
        decoration:  InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: primaryColor),
          enabledBorder:isFullBorder!=null? OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor,width: 2),
            borderRadius: BorderRadius.circular(10),
          ):UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          disabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor,width: 2),
            borderRadius: BorderRadius.circular(10),
          ),

        ),
        value:value==''? null:value,
        iconEnabledColor: Colors.blue,
        hint: Text(label,style: Styles.headLineStyle4.copyWith(color: primaryColor.withOpacity(0.4)),),
        onChanged: onChange,
        items:  mapValue.map((e) {
          return DropdownMenuItem(
            value: e.id,
            child: Text(e.name),
          );
        }).toList(),
      ),
    );
  }

final String value,label ;
final bool? isFullBorder;
// final List<String> listValue ;
final List<EventModel> mapValue ;

final Function(String? value) onChange;
}
