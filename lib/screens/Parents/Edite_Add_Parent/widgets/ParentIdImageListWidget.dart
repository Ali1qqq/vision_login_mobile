
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';


List<Widget> buildParentIdImageList(List<dynamic> imageList, ParentsViewModel controller, bool isTemporary) {
  return List.generate(
    imageList.length,
        (index) {
      return GetBuilder<ParentsViewModel>(builder: (logic) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
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

              // logic.isOverlayVisible = !logic.isOverlayVisible;
              // logic.imageHeight == 600 ?  logic. imageHeight = 200 :   logic.imageHeight = 600;
              // logic.imageWidth == 600 ?   logic.imageWidth = 200 :   logic.imageWidth = 600;
              // logic.update();
            },
            child: Container(
              width: logic.imageHeight*1.0,
              height:  logic.imageWidth*1.0,
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                      width: logic.imageHeight*1.0,
                      height:  logic.imageWidth*1.0,
                    child: isTemporary
                        ? Image.memory(
                      imageList[index],

                      fit: logic.imageWidth == 600 ?BoxFit.contain: BoxFit.cover,
                    )
                        :
                    Image.network(
                      imageList[index],

                      fit: logic.imageWidth == 600 ?BoxFit.contain: BoxFit.cover,
                    )


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
