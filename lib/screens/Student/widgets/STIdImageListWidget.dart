import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';

import '../../Widgets/AppButton.dart';

List<Widget> StudentImageList(List<dynamic> imageList, StudentViewModel controller, bool isTemporary) {
  return List.generate(
    imageList.length,
        (index) {
      return GetBuilder<StudentViewModel>(builder: (logic) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: (){
              Get.defaultDialog(
                  title:"عرض الصورة",
                  content: Container(
                    width: Get.width,
                    height: Get.height - 200,
                    child: InteractiveViewer(
                      panEnabled: true, // يسمح بالسحب
                      scaleEnabled: true, // يسمح بالتكبير
                      child: isTemporary
                          ? Image.memory(
                        imageList[index],
                        fit: BoxFit.contain,
                      )
                          : Image.network(
                        imageList[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),actions: [AppButton(text: "تم", onPressed: (){
                Get.back();
              })]
              );
            },
            child: Container(
              width:   200,
              height:   200,
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width:   200,
                    height:   200,
                    child: isTemporary
                        ? Image.memory(
                      imageList[index],

                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      imageList[index],

                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: InkWell(
                      onTap: () {
                        if (isTemporary) {
                          controller.contractsTemp.removeAt(index);
                        } else {
                          controller.contracts.removeAt(index);
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
