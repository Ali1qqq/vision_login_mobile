import 'package:flutter/material.dart';

import '../../constants.dart';

class InsertShapeWidget extends StatelessWidget {
  const InsertShapeWidget({super.key, required this.titleWidget, required this.bodyWidget,});

  final Widget titleWidget,bodyWidget;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: secondaryColor, blurRadius: 10, spreadRadius: 0.2)],
            color: secondaryColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: defaultPadding,
              ),

              titleWidget

            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: secondaryColor, blurRadius: 10, spreadRadius: 0.2)],
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          child:

          bodyWidget,


        ),
      ],
    );
  }
}
