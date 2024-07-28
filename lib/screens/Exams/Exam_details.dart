import 'dart:math';
import 'dart:typed_data';

import 'package:quickalert/quickalert.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/models/Student_Model.dart';
import 'package:vision_dashboard/screens/Exams/controller/Exam_View_Model.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down.dart';
import 'package:vision_dashboard/utils/Dialogs.dart';

import '../../controller/home_controller.dart';
import '../../models/Exam_model.dart';
import '../Widgets/Custom_Text_Filed.dart';

class ExamInputForm extends StatefulWidget {
  ExamInputForm({super.key, this.examModel, required this.isEdite});

  @override
  _ExamInputFormState createState() => _ExamInputFormState();

  late final ExamModel? examModel;
  final bool isEdite;
}

class _ExamInputFormState extends State<ExamInputForm> {
  Map<String, String> _selectedStudent = {};
  final parentMap = Get.find<ParentsViewModel>().parentMap;
  ScrollController firstScroll = ScrollController();
  ScrollController secondScroll = ScrollController();

  String _selectedClass = "";

  initExam() {
    if (widget.examModel != null) {
      subjectController.text = widget.examModel!.subject ?? '';
      professorController.text = widget.examModel!.professor ?? '';
      dateController.text = widget.examModel!.date.toString();
      examPassMarkController.text = widget.examModel!.examPassMark.toString();
      examMaxMarkController.text = widget.examModel!.examMaxMark ?? '';
      examId = widget.examModel!.id!;
      _questionImageFile = widget.examModel!.questionImage;
      _answerImageFile = widget.examModel!.answerImage;
      widget.examModel!.marks?.forEach(
        (key, value) {
          _selectedStudent[key] = value;
        },
      );
    }
  }

  StudentViewModel studentViewModel = Get.find<StudentViewModel>();

  @override
  void initState() {
    super.initState();
    examId = generateId("EXAM");
    initExam();
  }

  List<String>? _questionImageFile = [], _answerImageFile = [];

  List<Uint8List> _questionImageFileTemp = [], _answerImageFileTemp = [];
  final subjectController = TextEditingController();
  final professorController = TextEditingController();
  final dateController = TextEditingController();
  final examPassMarkController = TextEditingController();
  final examMaxMarkController = TextEditingController();
  final editController = TextEditingController();
  String examId = "";

  @override
  void dispose() {
    subjectController.dispose();
    professorController.dispose();
    dateController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    if (subjectController.text.isEmpty || professorController.text.isEmpty || dateController.text.isEmpty || examPassMarkController.text.isEmpty || examMaxMarkController.text.isEmpty || !isNumeric(examPassMarkController.text) || !isNumeric(examMaxMarkController.text)) {
      showErrorDialog("خطأ", "يرجى ملء جميع الحقول وتأكد من أن الحقول الرقمية تحتوي على أرقام فقط.");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Wrap(
                clipBehavior: Clip.hardEdge,
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 25,
                spacing: 25,
                children: <Widget>[
                  CustomTextField(
                    controller: subjectController,
                    title: 'المقرر'.tr,
                    enable: widget.isEdite,
                  ),
                  CustomTextField(
                    controller: professorController,
                    title: 'الاستاذ'.tr,
                    enable: widget.isEdite,
                  ),
                  CustomTextField(
                    controller: examPassMarkController,
                    title: 'علامة النجاح'.tr,
                    enable: widget.isEdite,
                  ),
                  CustomTextField(
                    controller: examMaxMarkController,
                    title: 'العلامة الكاملة'.tr,
                    enable: widget.isEdite,
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.isEdite)
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                        ).then((date) {
                          if (date != null) {
                            dateController.text = date.toString().split(" ")[0];
                          }
                        });
                    },
                    child: CustomTextField(
                      controller: dateController,
                      title: 'تاريخ البداية'.tr,
                      enable: false,
                      keyboardType: TextInputType.datetime,
                      icon: Icon(
                        Icons.date_range_outlined,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  CustomDropDown(
                    value: _selectedClass,
                    enable: widget.isEdite,
                    listValue: classNameList,
                    label: 'اختر الصف'.tr,
                    onChange: (value) {
                      if (value != null) _selectedClass = value;
                      setState(() {});
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("صورة ورقة الاسئلة".tr),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            if (widget.isEdite)
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? _ = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
                                  if (_ != null) {
                                    _.files.forEach(
                                      (element) async {
                                        _questionImageFileTemp.add(element.bytes!);
                                        /*File(element.bytes).readAsBytes().then((value) {

                                        },);*/
                                      },
                                    );
                                    setState(() {});
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                                    height: 200,
                                    width: 200,
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ...List.generate(
                              _questionImageFileTemp.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                                      width: 200,
                                      height: 200,
                                      child: Image.memory(
                                        _questionImageFileTemp[index],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.fitHeight,
                                      )),
                                );
                              },
                            ),
                            ...List.generate(
                              _questionImageFile!.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                                      width: 200,
                                      height: 200,
                                      child: Image.network(
                                        _questionImageFile![index],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.fitHeight,
                                      )),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("صورة ورقة الاجابة".tr),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            if (widget.isEdite)
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? _ = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
                                  if (_ != null) {
                                    _.files.forEach(
                                      (element) async {
                                        _answerImageFileTemp.add(element.bytes!);
                                      },
                                    );
                                    setState(() {});
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                                    height: 200,
                                    width: 200,
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ...List.generate(
                              _answerImageFileTemp.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                                      width: 200,
                                      height: 200,
                                      child: Image.memory(
                                        _answerImageFileTemp[index],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.fitHeight,
                                      )),
                                );
                              },
                            ),
                            ...List.generate(
                              _answerImageFile!.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                                      width: 200,
                                      height: 200,
                                      child: Image.network(
                                        _answerImageFile![index],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.fitHeight,
                                      )),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.isEdite && widget.examModel != null)
                    CustomTextField(
                      controller: editController,
                      title: "سبب التعديل",
                    ),
                  if (widget.isEdite)
                    GetBuilder<ExamViewModel>(builder: (examController) {
                      return AppButton(
                        text: 'حفظ'.tr,
                        onPressed: () async {
                          if (_validateFields()) {
                            QuickAlert.show(width: Get.width / 2, context: context, type: QuickAlertType.loading, title: 'جاري التحميل'.tr, text: 'يتم العمل على الطلب'.tr, barrierDismissible: false);
                            await uploadImages(_answerImageFileTemp, "Exam_answer").then(
                              (value) => _answerImageFile!.addAll(value),
                            );
                            await uploadImages(_questionImageFileTemp, "Exam_question").then(
                              (value) => _questionImageFile!.addAll(value),
                            );
                            final exam = ExamModel(
                                id: examId,
                                isDone: false,
                                questionImage: _questionImageFile ?? [],
                                answerImage: _answerImageFile,
                                subject: subjectController.text,
                                professor: professorController.text,
                                examPassMark: examPassMarkController.text,
                                examMaxMark: examMaxMarkController.text,
                                date: DateTime.parse(dateController.text),
                                marks: _selectedStudent,
                                isAccepted: widget.examModel == null ? true : false);
                            if (widget.examModel != null) {
                              await studentViewModel.removeExam(widget.examModel!.id!, widget.examModel!.marks?.keys.toList() ?? []);

                              addWaitOperation(collectionName: examsCollection, affectedId: examId, type: waitingListTypes.edite, details: editController.text, oldData: widget.examModel!.toJson(), newData: exam.toJson());
                            }
                            studentViewModel.addExamToStudent(_selectedStudent.keys.toList(), examId);
                            await examController.addExam(exam);
                            if (widget.examModel != null) Get.back();
                            clearController();
                            Get.back();
                          }
                        },
                      );
                    }),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            if (widget.isEdite)
              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GetBuilder<HomeViewModel>(builder: (controller) {
                  double size = max(MediaQuery.sizeOf(context).width - (controller.isDrawerOpen ? 240 : 120), 1000) - 60;
                  return SizedBox(
                    width: size + 60,
                    child: Scrollbar(
                      controller: firstScroll,
                      child: SingleChildScrollView(
                        controller: firstScroll,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          clipBehavior: Clip.hardEdge,
                          columns: [
                            DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("اسم الطالب")))),
                            DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("رقم الطالب")))),
                            DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("تاريخ البداية")))),
                            DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("ولي الأمر")))),
                            DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("موجود")))),
                          ],
                          rows: studentViewModel.studentMap.values
                              .where(
                            (element) => element.stdClass == _selectedClass && element.isAccepted == true,
                          )
                              .map(
                            (e) {
                              if (_selectedStudent.keys
                                  .where(
                                    (element) => element == e.studentID,
                                  )
                                  .isNotEmpty) e.available = true;

                              return studentDataRow(e, size / 5);
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            SizedBox(
              height: defaultPadding,
            ),
            if (_selectedStudent.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "الطلاب المختارين".tr,
                      style: Styles.headLineStyle1,
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    GetBuilder<HomeViewModel>(builder: (controller) {
                      double size = max(MediaQuery.sizeOf(context).width - (controller.isDrawerOpen ? 240 : 120), 1000) - 60;
                      return SizedBox(
                        width: size + 60,
                        child: Scrollbar(
                          controller: secondScroll,
                          child: SingleChildScrollView(
                            controller: secondScroll,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(clipBehavior: Clip.hardEdge, columns: [
                              DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("اسم الطالب")))),
                              DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("رقم الطالب")))),
                              DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("تاريخ البداية")))),
                              DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("ولي الأمر")))),
                              DataColumn(label: SizedBox(width: size / 5, child: Center(child: Text("العمليات")))),
                            ], rows: [
                              ...List.generate(
                                _selectedStudent.length,
                                (index) => studentSelectedDataRow(studentViewModel.studentMap[_selectedStudent.keys.elementAt(index)]!, widget.isEdite, size / 5),
                              )
                            ]),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            SizedBox(
              height: defaultPadding,
            ),
            if (!widget.isEdite)
              Center(
                child: AppButton(
                    text: "تم".tr,
                    onPressed: () {
                      Get.back();
                    }),
              )
          ],
        ),
      ),
    );
  }

  DataRow studentDataRow(StudentModel student, size) {
    return DataRow(
      cells: [
        DataCell(SizedBox(width: size, child: Center(child: Text(student.studentName.toString())))),
        DataCell(SizedBox(width: size, child: Center(child: Text(student.studentNumber.toString())))),
        DataCell(SizedBox(width: size, child: Center(child: Text(student.startDate.toString())))),
        DataCell(SizedBox(width: size, child: Center(child: Text(parentMap[student.parentId!]?.fullName ?? student.parentId!)))),
        DataCell(SizedBox(
          width: size,
          child: Center(
            child: Checkbox(
              fillColor: WidgetStateProperty.all(primaryColor),
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onChanged: (v) {
                if (v == false) {
                  student.available = v;
                  _selectedStudent.remove(student.studentID);
                } else {
                  student.available = v;
                  _selectedStudent[student.studentID!] = '0.0';
                }

                setState(() {});
              },
              value: student.available,
            ),
          ),
        )),
      ],
    );
  }

  DataRow studentSelectedDataRow(StudentModel student, bool isEdit, size) {
    return DataRow(
      cells: [
        DataCell(SizedBox(width: size, child: Center(child: Text(student.studentName.toString())))),
        DataCell(SizedBox(width: size, child: Center(child: Text(student.studentNumber.toString())))),
        DataCell(SizedBox(width: size, child: Center(child: Text(student.startDate.toString())))),
        DataCell(SizedBox(width: size, child: Center(child: Text(parentMap[student.parentId!]?.fullName ?? student.parentId!)))),
        DataCell(SizedBox(
          width: size,
          child: Center(
            child: IconButton(
              onPressed: () {
                if (isEdit) {
                  student.available = false;

                  _selectedStudent.remove(student.studentID);
                  setState(() {});
                }
              },
              icon: isEdit
                  ? Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                    )
                  : Container(),
            ),
          ),
        )),
      ],
    );
  }

  clearController() {
    _questionImageFile = [];
    _answerImageFile = [];
    _answerImageFileTemp = [];
    _questionImageFileTemp = [];
    subjectController.clear();
    professorController.clear();
    dateController.clear();
    examPassMarkController.clear();
    examMaxMarkController.clear();
    examId = generateId("EXAM");
    _selectedStudent = {};
    _selectedClass = '';
    setState(() {});
  }
}
