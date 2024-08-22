import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/models/ClassModel.dart';

import '../../../constants.dart';
import '../../../controller/Wait_management_view_model.dart';
import '../../../core/Styling/app_style.dart';
import '../../Student/student_user_details.dart';
import '../../Widgets/AppButton.dart';
import '../../Widgets/Custom_Text_Filed.dart';

class ClassViewModel extends GetxController {
  final classCollectionRef = FirebaseFirestore.instance.collection(classCollection);
  final firebaseFirestore = FirebaseFirestore.instance;

  ClassViewModel() {
/*    classNameList.forEach(
      (element) {
        addClass(ClassModel(
            classId: generateId("Class"),
            className: element,
            isAccepted: true));
      },
    );*/
    getAllClass();
  }

  Map<String, ClassModel> _classMap = {};

  Map<String, ClassModel> get classMap => _classMap;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;

  getAllClass() async {
    listener = await classCollectionRef.snapshots().listen((value) {
      _classMap.clear();
      for (var element in value.docs) {
        _classMap[element.id] = ClassModel.fromJson(element.data());
      }
      print("class :${_classMap.values.length}");
      update();
    });
  }

  addStudentToClass(String classId, String stdId) {
    classCollectionRef.doc(classId).set({
      "classStudent": FieldValue.arrayUnion([stdId])
    }, SetOptions(merge: true));
  }

  addClass(ClassModel classModel) {
    classCollectionRef.doc(classModel.classId).set(classModel.toJson(), SetOptions(merge: true));
    update();
  }

  updateClass(ClassModel classModel) async {
    await classCollectionRef.doc(classModel.classId).set(classModel.toJson(), SetOptions(merge: true));
    update();
  }

  getOldClass(String value) async {
    await firebaseFirestore.collection(archiveCollection).doc(value).collection(classCollection).get().then((value) {
      _classMap.clear();
      for (var element in value.docs) {
        _classMap[element.id] = ClassModel.fromJson(element.data());
      }
      print("Class :${_classMap.values.length}");
      listener.cancel();
      update();
    });
  }

  void showClassOptions(BuildContext context, ClassModel currentClass, WaitManagementViewModel waitManagementController) {
    showOptionDialog(
        onDelete: () async {
          ///press Delete Button in class option Dialog
          if (enableUpdate && currentClass.isAccepted!) {
            await showDeleteConfirmation(context, currentClass, waitManagementController);
          }
        },
        onUpdate: () {
          ///press Edit Button in class option Dialog
          if (enableUpdate && currentClass.isAccepted!) {
            showClassInputDialog(context, currentClass);
          }
        },
        className: currentClass.className,
        context: context);
  }

  Future<void> showDeleteConfirmation(BuildContext context, ClassModel currentClass, WaitManagementViewModel waitManagementController) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: checkIfPendingDelete(affectedId: currentClass.classId!) ? 'التراجع عن الحذف' : 'حذف هذا العنصر'.tr,
      title: 'هل انت متأكد ؟'.tr,
      onConfirmBtnTap: () {
        String classId = currentClass.classId.toString();
        if (!checkIfPendingDelete(affectedId: classId)) {
          addWaitOperation(
            userName: currentEmployee?.userName.toString()??"",

            type: waitingListTypes.delete,
            collectionName: classCollection,
            affectedId: classId,
          );
        } else {
          waitManagementController.returnDeleteOperation(affectedId: classId);
        }
        Get.back();
      },
      onCancelBtnTap: () => Get.back(),
      confirmBtnText: 'نعم'.tr,
      cancelBtnText: 'لا'.tr,
      confirmBtnColor: Colors.red,
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

  void showOptionDialog({required BuildContext context, required onDelete, required onUpdate, required className}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: secondaryColor,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  className,
                  style: AppStyles.headLineStyle1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton(
                      text: "حذف".tr,
                      onPressed: onDelete,
                      color: Colors.red,
                    ),
                    SizedBox(width: 20),
                    AppButton(
                      text: "تعديل".tr,
                      onPressed: onUpdate,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showClassInputDialog(BuildContext context, ClassModel classModel) {
    TextEditingController classNameController = TextEditingController()..text = classModel.className!;

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
                          if (classNameController.text != classModel.className) {
                            if (classNameController.text.isNotEmpty) {
                              if (classModel.className != '') {
                                addWaitOperation(collectionName: classCollection,

                                    userName: currentEmployee?.userName.toString()??"",
                                    affectedId: classModel.classId!, type: waitingListTypes.edite, newData: ClassModel(className: classNameController.text, classId: classModel.classId, isAccepted: false).toJson(), oldData: classModel.toJson());
                                addClass(ClassModel(className: classNameController.text, classId: classModel.classId, isAccepted: false));
                              } else
                                addClass(ClassModel(className: classNameController.text, classId: classModel.classId, isAccepted: true));
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
