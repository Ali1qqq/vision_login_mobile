import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/core/Styling/app_colors.dart';
import 'package:vision_dashboard/models/ClassModel.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:vision_dashboard/screens/classes/Controller/Class_View_Model.dart';
import '../../constants.dart';
import '../../controller/Wait_management_view_model.dart';
import '../../controller/home_controller.dart';
import '../../core/Styling/app_style.dart';
import 'Widgets/BuildAddClassButton.dart';
import 'Widgets/BuildNoClassSelectedMessage.dart';
import 'Widgets/BuildStudentLists.dart';

class ClassesView extends StatefulWidget {
  const ClassesView({super.key});

  @override
  State<ClassesView> createState() => _ClassesViewState();
}

class _ClassesViewState extends State<ClassesView> {
  ClassModel? selectedClass;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ClassViewModel>(builder: (classController) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          child: GetBuilder<HomeViewModel>(builder: (controller) {
            double size = max(Get.width - (controller.isDrawerOpen ? 240 : 120), 1000) - 60;
            return SizedBox(
              width: size + 120,
              child: Row(
                children: [
                  ///class section
                  SizedBox(
                    width: size / 6,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        buildHeader(),
                        Divider(
                          color: secondaryColor,
                          height: 6,
                          thickness: 3,
                        ),
                        buildClassList(classController, selectedClass ?? ClassModel()),
                        buildAddClassButton(context, classController),
                      ],
                    ),
                  ),
                  Container(
                    width: 5,
                    color: secondaryColor,
                  ),

                  ///Student section
                  Expanded(
                    child: selectedClass == null

                        ///if not selected any class
                        ? buildNoClassSelectedMessage()
                        : buildStudentLists(classController, selectedClass ?? ClassModel()),
                  ),
                ],
              ),
            );
          }),
        );
      }),
    );
  }

  Widget buildClassList(ClassViewModel classController, ClassModel selectedClass) {
    return GetBuilder<WaitManagementViewModel>(builder: (_) {
      return ListView.builder(
        itemCount: classController.classMap.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, listClassIndex) {
          var currentClass = classController.classMap.values.elementAt(listClassIndex);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildSwipeAbleClassTile(context, currentClass, listClassIndex, classController, _),
          );
        },
      );
    });
  }

  Widget buildSwipeAbleClassTile(BuildContext context, ClassModel currentClass, int listClassIndex, ClassViewModel classController, WaitManagementViewModel waitManagementController) {
    return SwipeTo(
      leftSwipeWidget: Icon(Icons.edit, color: secondaryColor),
      rightSwipeWidget: Icon(Icons.delete, color: secondaryColor),
      onLeftSwipe: (_) {
        if (enableUpdate && currentClass.isAccepted!) {
          classController.showClassInputDialog(context, currentClass);
        }
      },
      onRightSwipe: (_) async {
        if (enableUpdate && currentClass.isAccepted!) {
          await classController.showDeleteConfirmation(context, currentClass, waitManagementController);
        }
      },
      child: InkWell(
        onTap: () {
          if (currentClass.isAccepted!) {
            selectedClass = currentClass;
            setState(() {});
          }
        },
        onLongPress: () {
          classController.showClassOptions(context, currentClass, waitManagementController);
        },
        child: AnimatedContainer(
          duration: Durations.long1,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: determineTileColor(currentClass),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              currentClass.className!,
              style: determineTileTextStyle(currentClass),
            ),
          ),
        ),
      ),
    );
  }

  Color determineTileColor(ClassModel currentClass) {
    if (currentClass.isAccepted == false) {
      return Colors.green.withOpacity(0.5);
    }
    if (checkIfPendingDelete(affectedId: currentClass.classId!)) {
      return Colors.red.withOpacity(0.2);
    }
    if (selectedClass?.classId == currentClass.classId) {
      return primaryColor;
    }
    return Colors.transparent;
  }

  TextStyle determineTileTextStyle(ClassModel currentClass) {
    if (selectedClass?.classId == currentClass.classId) {
      return AppStyles.headLineStyle2.copyWith(color: Colors.white);
    }
    return AppStyles.headLineStyle2.copyWith(color: AppColors.textColor);
  }

  Widget buildHeader() {
    return Container(
      height: 75,
      child: Center(
        child: Text(
          "الصفوف".tr,
          style: AppStyles.headLineStyle2.copyWith(color:  AppColors.textColor),
        ),
      ),
    );
  }
}
