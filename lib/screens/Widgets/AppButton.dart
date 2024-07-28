import 'package:flutter/material.dart';

import '../../constants.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,

    required this.text,
    required this.onPressed,
     this.color=primaryColor,
  });


  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.white), backgroundColor: WidgetStateProperty.all(color)),
      onPressed:onPressed,
      child: Text(text),
    );
  }
}