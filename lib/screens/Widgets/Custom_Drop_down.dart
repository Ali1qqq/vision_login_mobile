import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../core/Styling/app_style.dart';

class CustomDropDown extends StatelessWidget {
   CustomDropDown({super.key,required this.value,required this.listValue,required this.label,required this.onChange,this.isFullBorder,this.size,this.enable=true});
   final double? size;
 final bool? enable;
  @override
  Widget build(BuildContext context) {

    return  SizedBox(
      width:size?? max(150,Get.width/4.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style:  AppStyles.headLineStyle4,),
          SizedBox(height: 10,),
          DropdownButtonFormField<String>(
            decoration:  InputDecoration(
              hintStyle: AppStyles.headLineStyle3.copyWith(overflow: TextOverflow.ellipsis),
              hintText: label,
              // labelText: label,
              enabled: enable??true,
              labelStyle: AppStyles.headLineStyle3.copyWith(overflow: TextOverflow.ellipsis),
              enabledBorder:OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              disabledBorder:UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey,width: 2),
              ),

            ),
            value:value==''? null:value,
            iconEnabledColor: Colors.blue,

            hint: Text(label,style: AppStyles.headLineStyle4.copyWith(color: primaryColor.withOpacity(0.4)),overflow: TextOverflow.ellipsis),
            onChanged: onChange,
            items: listValue.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e,overflow: TextOverflow.ellipsis),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

final String value,label ;
final bool? isFullBorder;
final List<String> listValue ;

final Function(String? value) onChange;
}
