
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {

  static TextStyle textStyle =
  TextStyle(  fontFamily: 'Cairo',color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis);

  static TextStyle headLineStyle1 =
  TextStyle(  fontFamily: 'Cairo',fontSize: 26, color: AppColors.textColor, fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,);

  static TextStyle headLineStyle2 =
  TextStyle(  fontFamily: 'Cairo',fontSize: 21, color: AppColors.textColor, fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis);

  static TextStyle headLineStyle3 =  TextStyle(  fontFamily: 'Cairo',
      fontSize: 17, color: AppColors.textColor, fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis);

  static TextStyle headLineStyle4 =  TextStyle(  fontFamily: 'Cairo',
      fontSize: 14, color: AppColors.textColor , fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis);
}
