import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';

List<Widget> buildImageList(List<dynamic> imageList, ExpensesViewModel controller, bool isTemporary) {
  return List.generate(
    imageList.length,
    (index) {
      return GetBuilder<ExpensesViewModel>(builder: (logic) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              logic.imageHeight == 600 ? logic.imageHeight = 200 : logic.imageHeight = 600;
              logic.imageWidth == 600 ? logic.imageWidth = 200 : logic.imageWidth = 600;
              logic.update();
            },
            child: Container(
              width: logic.imageWidth,
              height: logic.imageHeight,
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: logic.imageWidth,
                    height: logic.imageHeight,
                    child: isTemporary
                        ? Image.memory(
                            imageList[index],
                            fit: logic.imageWidth == 600 ? BoxFit.contain : BoxFit.cover,
                          )
                        : Image.network(
                            imageList[index],
                            fit: logic.imageWidth == 600 ? BoxFit.contain : BoxFit.cover,
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
          ),
        );
      });
    },
  );
}
