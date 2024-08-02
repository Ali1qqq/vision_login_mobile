import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget BuildParentContractImage({Uint8List? memoryImage, String? networkImageUrl}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
      width: 200,
      height: 200,
      child: memoryImage != null
          ? Image.memory(memoryImage, height: 200, width: 200, fit: BoxFit.fitHeight)
          : Image.network(networkImageUrl!, height: 200, width: 200, fit: BoxFit.fitHeight),
    ),
  );
}