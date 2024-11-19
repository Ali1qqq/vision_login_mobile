import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/Widgets/AppButton.dart';

class ImageOverlay extends StatelessWidget {
  const ImageOverlay({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.defaultDialog(
            title:"عرض الصورة",
              content: Container(
                width: Get.width,
                height: Get.height - 200,
                child: InteractiveViewer(
                  panEnabled: true, // يسمح بالسحب
                  scaleEnabled: true, // يسمح بالتكبير
                  child:        Container(

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            imageUrl
                        ),
                        fit:BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),actions: [AppButton(text: "تم", onPressed: (){
            Get.back();
          })]
          );

        },
        child: Stack(
          children: [
            Container(
              height: 200,
              width:200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    imageUrl
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              height: 200,
              width: 200,
              child: AnimatedOpacity(
                duration: Durations.short4,
                opacity:1,
                child: Container(
                  clipBehavior: Clip.hardEdge,

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }



}