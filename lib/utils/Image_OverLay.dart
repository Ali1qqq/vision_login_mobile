import 'dart:ui';

import 'package:flutter/material.dart';

class ImageOverlay extends StatefulWidget {
  const ImageOverlay({super.key, required this.imageUrl,this.imageHeight = 200,this.imageWidth = 200});

  @override
  _ImageOverlayState createState() => _ImageOverlayState();

  final String imageUrl;
final  double imageHeight,imageWidth ;
}

class _ImageOverlayState extends State<ImageOverlay> {
  bool isOverlayVisible = true;

  double imageHeight=200;
  double imageWidth=200;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageHeight=widget.imageHeight;
    imageWidth=widget.imageWidth;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            isOverlayVisible = !isOverlayVisible;
            imageHeight == 600 ? imageHeight = widget.imageHeight : imageHeight = 600;
            imageWidth == 600 ? imageWidth = widget.imageWidth : imageWidth = 600;
          });
        },
        child: Stack(
          children: [
            Container(
              height: imageHeight,
              width:imageWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget
                        .imageUrl
                  ),
                  fit:imageHeight==widget.imageHeight? BoxFit.cover:BoxFit.contain,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              height: imageHeight,
              width: imageWidth,
              child: AnimatedOpacity(
                duration: Durations.short4,
                opacity: isOverlayVisible ? 1 : 0,
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