import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vision_dashboard/screens/Exams/Add_Marks.dart';
import 'package:vision_dashboard/screens/Exams/controller/Exam_View_Model.dart';

import '../../constants.dart';
import '../../controller/Wait_management_view_model.dart';
import '../../controller/home_controller.dart';
import '../../models/Exam_model.dart';


import '../Widgets/Custom_Pluto_Grid.dart';

import '../Widgets/header.dart';
import 'Exam_details.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  List data = [
    "المقرر",
    "الأستاذ",
    "التاريخ",
    "الطلاب",
    "علامة النجاح",
    "نسبة النجاح",
    "اضافة علامات",
    ""
  ];

  bool addMarks = Get.find<ExamViewModel>().addMarks;
  ExamModel? examModel = ExamModel();

  // String examName="";

  List filterData = [
    "المقرر",
    "الأستاذ",
    "التاريخ",
  ];
  TextEditingController searchController = TextEditingController();
  String searchValue = '';
  int searchIndex = 0;
  String currentId = '';

  bool getIfDelete() {
    return checkIfPendingDelete(affectedId: currentId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExamViewModel>(builder: (examController) {
      return AnimatedCrossFade(
          firstChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: Scaffold(
              appBar: Header(
                  context: context,
                  title: 'الامتحانات'.tr,
                  middleText:
                      'تعرض هذه الواجهة بيانات الامتحانات السابقة مع امكانية اضافة امتحان جديد'
                          .tr),
              body: SingleChildScrollView(
                child: GetBuilder<HomeViewModel>(builder: (controller) {
                  double size = max(
                          MediaQuery.sizeOf(context).width -
                              (controller.isDrawerOpen ? 240 : 120),
                          1000) -
                      60;
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: SizedBox(
                        height: Get.height-120,
                        width: size + 60,
                        child: CustomPlutoGrid(
                          controller: examController,
                          idName: "الرقم التسلسلي",
                          onSelected: (event) {
                            currentId =
                                event.row?.cells["الرقم التسلسلي"]?.value;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
              floatingActionButton: enableUpdate && currentId != ''
                  ? SizedBox(
                width: Get.width,
                child: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.center,
                  alignment: WrapAlignment.center,
                        children: [
                          GetBuilder<WaitManagementViewModel>(builder: (_) {
                            return FloatingActionButton(
                              backgroundColor: primaryColor.withOpacity(0.5),
                              onPressed: () {
                                if (enableUpdate) {
                                  examModel = examController.examMap[currentId]!;
                                  examController.changeExamScreen();
                                }
                              },
                              child: Icon(
                                Icons.add_chart_outlined,
                                color: Colors.white,
                              ),
                            );
                          }),
                          SizedBox(
                            width: defaultPadding,
                          ),
                          FloatingActionButton(
                            backgroundColor:
                                examController.examMap[currentId]!.isDone!
                                    ? Colors.grey.withOpacity(0.5)
                                    : primaryColor.withOpacity(0.5),
                            onPressed: () {
                              if (enableUpdate) if (examController
                                  .examMap[currentId]!.isDone!) {
                                QuickAlert.show(
                                    width: Get.width / 2,
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: "لا يمكن تعديل الامتحان بعد التصحيح".tr,
                                    title: "خطأ",
                                    confirmBtnText: "تم");
                              } else
                                showExamInputDialog(
                                    context, examController.examMap[currentId]!,true);
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: defaultPadding,
                          ),
                          FloatingActionButton(
                            backgroundColor:primaryColor.withOpacity(0.5) ,
                            onPressed: () {
                                showExamInputDialog(
                                    context, examController.examMap[currentId]!,false);
                            },
                            child: Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                  )
                  : Container(),
            ),
          ),
          secondChild: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height),
              child: AddMarks(examModel: examModel!)),
          crossFadeState: examController.addMarks
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Durations.short4);
      // return examController.addMarks!=true? :;
    });
  }

  void showExamInputDialog(BuildContext context, ExamModel examModel,bool isEdit) {
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
            child: ExamInputForm(
              examModel: examModel,
              isEdite:isEdit,
            ),
          ),
        );
      },
    );
  }
}
/*          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Wrap(
                            spacing: 25,
                            children: [
                              CustomTextField(
                                size: Get.width / 6,
                                controller: searchController,
                                title: "ابحث",
                                onChange: (value) {
                                  setState(() {});
                                },
                              ),
                              CustomDropDown(
                                size: Get.width / 6,
                                value: searchValue,
                                listValue: filterData
                                    .map(
                                      (e) => e.toString(),
                                )
                                    .toList(),
                                label: "اختر فلتر البحث",
                                onChange: (value) {
                                  searchValue = value ?? '';
                                  searchIndex=filterData.indexOf(searchValue);

                                },
                              )
                            ],
                          ),
                          SizedBox(height: 5,),
                          Divider(color: primaryColor.withOpacity(0.2),),
                          SizedBox(height: 5,),
                          SizedBox(
                            width: size + 60,
                            child: Scrollbar(
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                    columnSpacing: 0,
                                    dividerThickness: 0.3,
                                    columns: List.generate(
                                        data.length,
                                        (index) => DataColumn(
                                            label: Container(
                                                width: size / data.length,
                                                child: Center(
                                                    child: Text(data[index]
                                                        .toString()
                                                        .tr))))),
                                    rows: [
                                      for (var exam
                                          in examController.examMap.values.where((element) {
                                        if (searchController.text == '')
                                          return true;
                                        else switch(searchIndex){
                                          case 0:
                                            return  element.subject!
                                                .contains(searchController.text);
                                          case 1:
                                            return  element.professor!
                                                .contains(searchController.text);
                                          case 2:
                                            return  element.date.toString()
                                                .contains(searchController.text);

                                          default:
                                            return false;
                                        }
                                          },))
                                        DataRow(cells: [
                                          dataRowItem(size / data.length,
                                              exam.subject.toString()),
                                          dataRowItem(size / data.length,
                                              exam.professor.toString()),
                                          dataRowItem(size / data.length,
                                              exam.date!.toString().split(" ")[0]),
                                          dataRowItem(size / data.length,
                                              exam.marks!.keys.length.toString()),
                                          dataRowItem(size / data.length,
                                              exam.examPassMark.toString()),
                                          dataRowItem(
                                              size / data.length,
                                              exam.isDone!
                                                  ? "${exam.passRate}%".toString()
                                                  : "لم يصحح بعد".tr),
                                          dataRowItem(
                                              size / data.length, "اضافة".tr,
                                              color: Colors.teal, onTap: () {
                                            if (enableUpdate) {
                                              examModel = exam;
                                              examController.changeExamScreen();
                                            }
                                          }),
                                          dataRowItem(
                                              size / data.length, "تعديل".tr,
                                              color: Colors.blue, onTap: () {
                                            if (enableUpdate) if (exam.isDone!) {
                                              QuickAlert.show(
                                                  width: Get.width / 2,
                                                  context: context,
                                                  type: QuickAlertType.error,
                                                  text:
                                                      "لا يمكن تعديل الامتحان بعد التصحيح"
                                                          .tr,
                                                  title: "خطأ",
                                                  confirmBtnText: "تم");
                                            } else
                                              showExamInputDialog(context, exam);
                                          }),
                                        ]),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),*/
