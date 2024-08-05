import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/event_model.dart';

import '../../constants.dart';
import '../../core/Styling/app_style.dart';

class CustomDropDownWithValue extends StatelessWidget {
  CustomDropDownWithValue({super.key,required this.value,required this.mapValue,required this.label,required this.onChange,this.isFullBorder});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: max(150,Get.width/4.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style:  AppStyles.headLineStyle4,),
          SizedBox(height: 10,),
          DropdownButtonFormField<String>(
            decoration:  InputDecoration(
              // labelText: label,
              // labelStyle: TextStyle(color: primaryColor),
              enabledBorder:OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              disabledBorder:OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey,width: 2),
              ),

            ),
            value:value==''? null:value,
            iconEnabledColor: Colors.blue,
            hint: Text(label,style: AppStyles.headLineStyle4.copyWith(color: primaryColor.withOpacity(0.4)),),
            onChanged: onChange,
            items:  mapValue.map((e) {
              return DropdownMenuItem(
                value: e.id,
                child: Text(e.name),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

final String value,label ;
final bool? isFullBorder;
// final List<String> listValue ;
final List<EventModel> mapValue ;

final Function(String? value) onChange;
}
