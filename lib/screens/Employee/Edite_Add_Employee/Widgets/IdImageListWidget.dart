import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/core/dialogs/image_view_dialog.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';

import '../../../Widgets/AppButton.dart';

List<Widget> buildIdImageList(List<dynamic> imageList, EmployeeViewModel controller, bool isTemporary) {
  return List.generate(
    imageList.length,
        (index) {
      return GetBuilder<EmployeeViewModel>(builder: (logic) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: (){
              Get.defaultDialog(
                  title:"عرض الصورة",
                  content: ImageViewDialog( child: isTemporary
                      ? Image.memory(
                    imageList[index],
                    fit: BoxFit.contain,
                  )
                      : Image.network(
                    imageList[index],
                    fit: BoxFit.contain,
                  ),),actions: [AppButton(text: "تم", onPressed: (){
                Get.back();
              })]
              );
            },
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
                    width:200,
                    height: 200,
                    child: isTemporary
                        ? Image.memory(
                      imageList[index],

                 fit:  BoxFit.cover,

                    )
                        : Image.network(
                      imageList[index],

                      fit:  BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: InkWell(
                      onTap: () {
                        if (isTemporary) {
                          controller.imagesTempData.removeAt(index);
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
