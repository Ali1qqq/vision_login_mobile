
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/models/ClassModel.dart';
import 'package:vision_dashboard/models/Student_Model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';
import 'package:vision_dashboard/screens/classes/Controller/Class_View_Model.dart';

import '../../constants.dart';
import '../../controller/Wait_management_view_model.dart';

import '../../controller/home_controller.dart';
import '../Student/student_user_details.dart';

class ClassesView extends StatefulWidget {
  const ClassesView({super.key});

  @override
  State<ClassesView> createState() => _ClassesViewState();
}

class _ClassesViewState extends State<ClassesView> {
  ClassModel? SelectedClass;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ClassViewModel>(builder: (classController) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          child:  GetBuilder<HomeViewModel>(builder: (controller) {
            double size = max(
                MediaQuery.sizeOf(context).width -
                    (controller.isDrawerOpen ? 240 : 120),
                1000) -
                60;
              return SizedBox(
                width: size+120,
                child: Row(
                  children: [
                    SizedBox(
                      width: size / 6,
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Container(
                              height: 75,
                              child: Center(
                                  child: Text(
                                "الصفوف".tr,
                                style: Styles.headLineStyle2.copyWith(color: blueColor),
                              ))),
                          Container(
                            height: 6,

                            color: secondaryColor,
                          ),
                          Column(
                            children: [
                              GetBuilder<WaitManagementViewModel>(builder: (_) {
                                return ListView.builder(
                                  itemCount: classController.classMap.length,
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, listClassIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SwipeTo(
                                        leftSwipeWidget: Icon(
                                          Icons.edit,
                                          color: secondaryColor,
                                        ),
                                        rightSwipeWidget: Icon(
                                          Icons.delete,
                                          color: secondaryColor,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                         if(   classController.classMap.values
                                                .elementAt(listClassIndex).isAccepted!)
                                            SelectedClass = classController
                                                .classMap.values
                                                .elementAt(listClassIndex);
                                            setState(() {});
                                          },
                                          onLongPress: (){
                                            showEventDialog(context,()async {
                                              if (enableUpdate&&classController.classMap.values
                                                  .elementAt(listClassIndex).isAccepted!)
                                                await QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.confirm,
                                                  text: checkIfPendingDelete(
                                                      affectedId: classController
                                                          .classMap.values
                                                          .elementAt(listClassIndex)
                                                          .classId!)
                                                      ? 'التراجع عن الحذف'
                                                      : 'حذف هذا العنصر'.tr,
                                                  title: 'هل انت متأكد ؟'.tr,
                                                  onConfirmBtnTap: () {

                                                    String classId = classController
                                                        .classMap.values
                                                        .elementAt(listClassIndex)
                                                        .classId
                                                        .toString();
                                                    if (!checkIfPendingDelete(
                                                        affectedId: classId))
                                                      addWaitOperation(
                                                          type: waitingListTypes.delete,
                                                          collectionName: classCollection,
                                                          affectedId: classId);
                                                    else
                                                      _.returnDeleteOperation(
                                                          affectedId: classId);
                                                    Get.back();
                                                  },
                                                  onCancelBtnTap: () => Get.back(),
                                                  confirmBtnText: 'نعم'.tr,
                                                  cancelBtnText: 'لا'.tr,
                                                  confirmBtnColor: Colors.red,
                                                );
                                            },() {
                                              if (enableUpdate&&classController.classMap.values
                                                  .elementAt(listClassIndex).isAccepted!)
                                                showClassInputDialog(
                                                    context,
                                                    classController.classMap.values
                                                        .elementAt(listClassIndex),
                                                    classController);
                                            },classController
                                                .classMap.values
                                                .elementAt(listClassIndex).className);
                                          },
                                          child: AnimatedContainer(
                                              duration: Durations.long1,
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  color:classController
                                                      .classMap.values
                                                      .elementAt(listClassIndex)
                                                      .isAccepted==false?Colors.green.withOpacity(0.5) : checkIfPendingDelete(
                                                          affectedId: classController
                                                              .classMap.values
                                                              .elementAt(listClassIndex)
                                                              .classId!)
                                                      ? Colors.red.withOpacity(0.2)
                                                      : SelectedClass?.classId! ==
                                                              classController
                                                                  .classMap.values
                                                                  .elementAt(
                                                                      listClassIndex)
                                                                  .classId
                                                          ? primaryColor
                                                          : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(15)),
                                              child: Center(
                                                  child: Text(
                                                classController.classMap.values
                                                    .elementAt(listClassIndex)
                                                    .className
                                                    .toString(),
                                                style: SelectedClass?.classId! ==
                                                        classController.classMap.values
                                                            .elementAt(listClassIndex)
                                                            .classId
                                                    ? Styles.headLineStyle2
                                                        .copyWith(color: Colors.white)
                                                    : Styles.headLineStyle2
                                                        .copyWith(color: blueColor),
                                              ))),
                                        ),
                                        onLeftSwipe: (details) {
                                          if (enableUpdate&&classController.classMap.values
                                              .elementAt(listClassIndex).isAccepted!)
                                            showClassInputDialog(
                                                context,
                                                classController.classMap.values
                                                    .elementAt(listClassIndex),
                                                classController);
                                        },
                                        onRightSwipe: (details) async {
                                          if (enableUpdate&&classController.classMap.values
                                              .elementAt(listClassIndex).isAccepted!)
                                            await QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.confirm,
                                              text: checkIfPendingDelete(
                                                      affectedId: classController
                                                          .classMap.values
                                                          .elementAt(listClassIndex)
                                                          .classId!)
                                                  ? 'التراجع عن الحذف'
                                                  : 'حذف هذا العنصر'.tr,
                                              title: 'هل انت متأكد ؟'.tr,
                                              onConfirmBtnTap: () {

                                                String classId = classController
                                                    .classMap.values
                                                    .elementAt(listClassIndex)
                                                    .classId
                                                    .toString();
                                                if (!checkIfPendingDelete(
                                                    affectedId: classId))
                                                  addWaitOperation(
                                                      type: waitingListTypes.delete,
                                                      collectionName: classCollection,
                                                      affectedId: classId);
                                                else
                                                  _.returnDeleteOperation(
                                                      affectedId: classId);
                                                Get.back();
                                              },
                                              onCancelBtnTap: () => Get.back(),
                                              confirmBtnText: 'نعم'.tr,
                                              cancelBtnText: 'لا'.tr,
                                              confirmBtnColor: Colors.red,
                                            );
                                        },
                                      ),
                                    );
                                  },
                                );
                              }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    showClassInputDialog(
                                        context,
                                        ClassModel(
                                            className: '',
                                            classId: generateId("Class")),
                                        classController);
                                  },
                                  child: AnimatedContainer(
                                      duration: Durations.long1,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Center(
                                          child: Text(
                                        "اضافة".tr,
                                        style: Styles.headLineStyle2
                                            .copyWith(color: Colors.white),
                                      ))),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 5,
                      color: secondaryColor,
                    ),
                    if (SelectedClass == null)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                              child: Text(
                            "يرجى إختيار احد الصفوف لمشاهدة تفاصيله".tr,
                            style: Styles.headLineStyle2.copyWith(color: blueColor),
                            textAlign: TextAlign.center,
                          )),
                        ),
                      )
                    else
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    "عربي".tr,
                                    style: Styles.headLineStyle2
                                        .copyWith(color: blueColor),
                                  )),
                                ),
                              ),
                              Container(
                                height: 75,
                                width: 3,
                                color: Colors.grey.shade300,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    "لغات".tr,
                                    style: Styles.headLineStyle2
                                        .copyWith(color: blueColor),
                                  )),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5,
                            color: secondaryColor,
                          ),
                          Get.find<StudentViewModel>()
                                      .studentMap
                                      .values
                                      .where(
                                        (element) =>
                                            element.stdClass ==
                                                SelectedClass?.className &&
                                            (element.stdLanguage == 'لغات' ||
                                                element.stdLanguage == 'عربي'),
                                      )
                                      .toList()
                                      .length ==
                                  0
                              ? Expanded(
                                  child: Center(
                                      child: Text(
                                  "لايوجد طلاب".tr,
                                  style:
                                      Styles.headLineStyle2.copyWith(color: blueColor),
                                )))
                              : GetBuilder<StudentViewModel>(
                                  builder: (studentController) {
                                  return Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        studentController.studentMap.values
                                                    .where(
                                                      (element) =>
                                                          element.stdClass ==
                                                              SelectedClass
                                                                  ?.className &&
                                                          element.stdLanguage == 'عربي',
                                                    )
                                                    .toList()
                                                    .length ==
                                                0
                                            ? Expanded(
                                                child: Center(
                                                    child: Text("لايوجد طلاب".tr,
                                                        style: Styles.headLineStyle2
                                                            .copyWith(
                                                                color: blueColor))))
                                            : Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: ClampingScrollPhysics(),
                                                  itemCount: studentController
                                                      .studentMap.values
                                                      .where(
                                                        (element) =>
                                                            element.stdClass ==
                                                                SelectedClass
                                                                    ?.className &&
                                                            element.stdLanguage ==
                                                                'عربي',
                                                      )
                                                      .toList()
                                                      .length,
                                                  itemBuilder: (context, index) {
                                                    List<StudentModel> listStudent =
                                                        studentController
                                                            .studentMap.values
                                                            .where(
                                                              (element) =>
                                                                  element.stdClass ==
                                                                      SelectedClass
                                                                          ?.className &&
                                                                  element.stdLanguage ==
                                                                      'عربي',
                                                            )
                                                            .toList();
                                                    return Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            showStudentInputDialog(
                                                                context,
                                                                listStudent[index]);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    8.0),
                                                            child: Center(
                                                                child: Text(
                                                                    listStudent[index]
                                                                        .studentName!,
                                                                    style: Styles
                                                                        .headLineStyle3
                                                                        .copyWith(
                                                                            color:
                                                                                blueColor))),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 3,
                                                          color: secondaryColor,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                        Container(
                                          height: double.maxFinite,
                                          width: 3,
                                          color: Colors.grey.shade300,
                                        ),
                                        studentController.studentMap.values
                                                    .where(
                                                      (element) =>
                                                          element.stdClass ==
                                                              SelectedClass
                                                                  ?.className &&
                                                          element.stdLanguage == 'لغات',
                                                    )
                                                    .toList()
                                                    .length ==
                                                0
                                            ? Expanded(
                                                child: Center(
                                                    child: Text("لايوجد طلاب".tr,
                                                        style: Styles.headLineStyle2
                                                            .copyWith(
                                                                color: blueColor))))
                                            : Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: ClampingScrollPhysics(),
                                                  itemCount: studentController
                                                      .studentMap.values
                                                      .where(
                                                        (element) =>
                                                            element.stdClass ==
                                                                SelectedClass
                                                                    ?.className &&
                                                            element.stdLanguage ==
                                                                'لغات',
                                                      )
                                                      .toList()
                                                      .length,
                                                  itemBuilder: (context, index) {
                                                    List<StudentModel> listStudent =
                                                        studentController
                                                            .studentMap.values
                                                            .where(
                                                              (element) =>
                                                                  element.stdClass ==
                                                                      SelectedClass
                                                                          ?.className &&
                                                                  element.stdLanguage ==
                                                                      'لغات',
                                                            )
                                                            .toList();
                                                    return Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            showStudentInputDialog(
                                                                context,
                                                                listStudent[index]);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    8.0),
                                                            child: Center(
                                                                child: Text(
                                                                    listStudent[index]
                                                                        .studentName!,
                                                                    style: Styles
                                                                        .headLineStyle3
                                                                        .copyWith(
                                                                            color:
                                                                                blueColor))),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 3,
                                                          color: secondaryColor,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                      ],
                                    ),
                                  );
                                }),
                        ],
                      )),
                  ],
                ),
              );
            }
          ),
        );
      }),
    );
  }

  void showStudentInputDialog(BuildContext context, dynamic student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
            ),
            height: Get.height / 2,
            width: Get.width / 1.5,
            child: StudentInputForm(
              studentModel: student,
            ),
          ),
        );
      },
    );
  }

  void showEventDialog(BuildContext context,onDelete,onUpdate,className) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
            ),


            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(className,style: Styles.headLineStyle1,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                 AppButton(text: "حذف".tr, onPressed: onDelete),
                 SizedBox(width: 10,),
                 AppButton(text: "تعديل".tr, onPressed: onUpdate),


                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showClassInputDialog(
      BuildContext context, ClassModel classModel, ClassViewModel controller) {
    TextEditingController classNameController = TextEditingController()
      ..text = classModel.className!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                width: 300,
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: classNameController,
                        title: "اسم الصف",
                      ),
                      Spacer(),
                      AppButton(
                        onPressed: () {
                          if(classNameController.text!=classModel.className) {
                            if (classNameController.text.isNotEmpty) {
                              if (classModel.className != '') {
                                addWaitOperation(
                                    collectionName: classCollection,
                                    affectedId: classModel.classId!,
                                    type: waitingListTypes.edite,
                                    newData: ClassModel(
                                            className: classNameController.text,
                                            classId: classModel.classId,
                                            isAccepted: false)
                                        .toJson(),
                                    oldData: classModel.toJson());
                                controller.addClass(ClassModel(
                                    className: classNameController.text,
                                    classId: classModel.classId,
                                    isAccepted: false));
                              } else
                                controller.addClass(ClassModel(
                                    className: classNameController.text,
                                    classId: classModel.classId,
                                    isAccepted: true));
                              Get.back();
                            }
                          } else
                            Get.back();
                        },
                        text: "حفظ".tr,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
