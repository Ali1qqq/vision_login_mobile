 import 'package:flutter/material.dart';

import '../../constants.dart';

dataRowItem(size, text, {onTap, color}) {
    return DataCell(
      Container(
        width: size,
        child: InkWell(
            onTap: onTap,
            child: Center(
                child: Text(
              text,
              textAlign: TextAlign.center,
              style: color == null
                  ? Styles.headLineStyle4.copyWith(color: primaryColor)
                  : Styles.headLineStyle4.copyWith(color: color),
            ))),
      ),
    );
  }