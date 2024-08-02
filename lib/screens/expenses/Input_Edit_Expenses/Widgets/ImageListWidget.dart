import 'package:flutter/material.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';

List<Widget> buildImageList(List<dynamic> imageList, ExpensesViewModel controller, bool isTemporary) {
  return List.generate(
    imageList.length,
        (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: 200,
                height: 200,
                child: isTemporary
                    ? Image.memory(
                  imageList[index],
                  height: 200,
                  width: 200,
                  fit: BoxFit.fitHeight,
                )
                    : Image.network(
                  imageList[index],
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: InkWell(
                  onTap: () {
                    if (isTemporary) {
                      controller.ImagesTempData.removeAt(index);
                    } else {
                      controller.imageLinkList.removeAt(index);
                    }
                    controller.update(); // Notify the UI
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
