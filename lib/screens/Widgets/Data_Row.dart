 import 'package:flutter/material.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';

import '../../core/Styling/app_colors.dart';

dataRowItem(size, text, {onTap, color}) {
    return DataCell(
      Container(
        width: size,
        child: InkWell(
            onTap: onTap,
            child: Center(
                child: Text(
                  textDirection:TextDirection.ltr ,
              text,
              textAlign: TextAlign.center,
              style: color == null
                  ? AppStyles.headLineStyle4.copyWith(color:  AppColors.textColor)
                  : AppStyles.headLineStyle4.copyWith(color:  color),
            ))),
      ),
    );
  }