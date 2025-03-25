import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/Widgets/AppButton.dart';

class ImageOverlay extends StatelessWidget {
  const ImageOverlay({
    Key? key,
    this.imageUrl,      // لصور الإنترنت
    this.imageData,     // لصور Uint8List المحلية
  }) : super(key: key);

  final String? imageUrl;
  final Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    // اختيار مزود الصورة بناءً على البيانات المتوفرة
    ImageProvider<Object> imageProvider;
    if (imageData != null) {
      imageProvider = MemoryImage(imageData!);
    } else if (imageUrl != null) {
      imageProvider = NetworkImage(imageUrl!);
    } else {
      // صورة افتراضية في حال عدم توفر أي بيانات
      imageProvider = const AssetImage('assets/placeholder.png');
    }

    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
          title: "عرض الصورة",
          content: Container(
            width: Get.width,
            height: Get.height - 200,
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          actions: [
            AppButton(
              text: "تم",
              onPressed: () {
                Get.back();
              },
            )
          ],
        );
      },
      child: Stack(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
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
              opacity: 1,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: const Center(
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
      ),
    );
  }
}