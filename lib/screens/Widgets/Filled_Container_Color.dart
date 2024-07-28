import 'package:flutter/material.dart';

class FilledContainerColor extends StatelessWidget {
  const FilledContainerColor({super.key,required this.color});
final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          border:
          Border.all(color: Colors.black.withOpacity(0.1)),
          color:color,
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
