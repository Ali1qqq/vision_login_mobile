import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageViewDialog extends StatelessWidget {
  const ImageViewDialog({super.key,required this.child});
final  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height - 200,
      child: InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        child:child
      ),
    );
  }
}
