import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class CustomDropDown extends StatelessWidget {
   CustomDropDown({super.key,required this.value,required this.listValue,required this.label,required this.onChange,this.isFullBorder,this.size,this.enable=true});
   final double? size;
 final bool? enable;
  @override
  Widget build(BuildContext context) {

    return  SizedBox(
      width:size?? max(150,Get.width/4.5),
      child: DropdownButtonFormField<String>(
        decoration:  InputDecoration(
          hintStyle:TextStyle(color: primaryColor,overflow: TextOverflow.ellipsis) ,
          hintText: label,
          labelText: label,
          enabled: enable??true,
          labelStyle: TextStyle(color: primaryColor,overflow: TextOverflow.ellipsis),
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

        hint: Text(label,style: Styles.headLineStyle4.copyWith(color: primaryColor.withOpacity(0.4)),overflow: TextOverflow.ellipsis),
        onChanged: onChange,
        items: listValue.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e,overflow: TextOverflow.ellipsis),
          );
        }).toList(),
      ),
    );
  }

final String value,label ;
final bool? isFullBorder;
final List<String> listValue ;

final Function(String? value) onChange;
}
