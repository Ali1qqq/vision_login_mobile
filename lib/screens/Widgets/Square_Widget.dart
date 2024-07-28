import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class SquareWidget extends StatelessWidget {
  const SquareWidget({super.key, required this.title, required this.body, required this.png, required this.color});
 final String title, body, png;
 final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 275,
        width: 275,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: secondaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                    child: Text(
                      title.toString().tr,
                      textAlign: TextAlign.center,
                      style: Styles.headLineStyle2.copyWith(color:color==false?Colors.black: color),
                    )),
              ),
            ),
            Text(
              body,
              style: Styles.headLineStyle1.copyWith(color: color==false?Colors.black: color, fontSize: 40),
            ),
            SizedBox(
              height: 20,
            ),
            color==false?
            Image.asset(
              png,
              height: 100,
              // color: color==false?Colors.transparent: color,
            ):Image.asset(
              png,
              height: 70,
              color: color,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
