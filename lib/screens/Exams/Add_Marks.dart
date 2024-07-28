import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vision_dashboard/models/Exam_model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';
import 'package:vision_dashboard/utils/Dialogs.dart';

import '../../constants.dart';
import '../../controller/home_controller.dart';
import '../Widgets/AppButton.dart';
import '../Widgets/header.dart';
import 'controller/Exam_View_Model.dart';

class AddMarks extends StatefulWidget {
  const AddMarks({super.key, required this.examModel});

  @override
  State<AddMarks> createState() => _AddMarksState();

  final ExamModel examModel;
}

class _AddMarksState extends State<AddMarks> {
  final ScrollController _scrollController = ScrollController();
  List data = ["اسم الطالب", "العلامة"];
  int maxMark = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    maxMark = int.parse(widget.examModel.examMaxMark ?? "0");
    return Scaffold(
      appBar: Header(
          context: context,
          title: 'اضافة علامات للطلاب'.tr,
          middleText:
              'تتمكن في هذه الواجهة من اضافة علامات للطلاب المشتركين في هذا الامتحان (يجب ان يكون ارقاما فقط)'.tr),
      body: SingleChildScrollView(
        child: GetBuilder<HomeViewModel>(builder: (controller) {
          double size = max(
                  MediaQuery.sizeOf(context).width -
                      (controller.isDrawerOpen ? 240 : 120),
                  1000) -
              60;
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "كل الطلاب الذين يحق لهم دخول امتحان".tr+"${widget.examModel.subject}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(
                        width: size + 60,
                        child: Scrollbar(
                          controller: _scrollController,
                          child: GetBuilder<ExamViewModel>(
                              builder: (examController) {
                            return SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 0,
                                columns: List.generate(
                                  data.length,
                                  (index) => DataColumn(
                                    label: Container(
                                      width: size / data.length,
                                      child: Center(child: Text(data[index].toString().tr)),
                                    ),
                                  ),
                                ),
                                rows: [
                                  for (var exam
                                      in widget.examModel.marks?.keys ?? [])
                                    DataRow(
                                      cells: [
                                        dataRowItem(
                                            size / data.length,
                                            Get.find<StudentViewModel>()
                                                .studentMap[exam]!
                                                .studentName
                                                .toString()),
                                        dataRowItemText(
                                          size / data.length,
                                          _calculateMark(exam.toString()),
                                          onChange: (value) {
                                            _updateMark(exam.toString(), value);
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: defaultPadding),
                GetBuilder<ExamViewModel>(
                  builder: (controller) {
                    return AppButton(
                      text: 'حفظ'.tr,
                      onPressed: () async {
                        QuickAlert.show(
                            width: Get.width / 2,
                            context: context,
                            type: QuickAlertType.loading,
                            title: 'جاري التحميل'.tr,
                            text: 'يتم العمل على الطلب'.tr,
                            barrierDismissible: false);
                        await controller.addMarkExam(
                            widget.examModel.marks!, widget.examModel.id!);
                        controller.changeExamScreen();
                        Get.find<StudentViewModel>()
                            .getAllStudentWithOutListen();
                        Get.back();
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _calculateMark(String exam) {
    double examMark = double.parse(widget.examModel.marks?[exam] ?? '0');
    double maxExamMark = double.parse(widget.examModel.examMaxMark ?? '100');
    return ((examMark * maxExamMark) / 100).toString();
  }

  void _updateMark(String exam, String value) {
    double updatedMark = (double.parse(value) /
            double.parse(widget.examModel.examMaxMark.toString())) *
        100;
    widget.examModel.marks?[exam] = updatedMark.toString();
  }

  dataRowItem(size, text, {onTap, color}) {
    return DataCell(
      Container(
        width: size,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: color == null ? null : TextStyle(color: color),
            ),
          ),
        ),
      ),
    );
  }

  dataRowItemText(size, text, {color, onChange}) {
    TextEditingController controller = TextEditingController();
    controller.text = text;

    return DataCell(
      Container(
        width: size,
        padding: EdgeInsets.symmetric(horizontal: size / 4, vertical: 5),
        child: CustomTextField(
          title: "",
          controller: controller,
          hint: text,
          onChange: (value) {
            if (value!.isEmpty) {
              showErrorDialog("خطأ".tr, "لا يمكن أن تكون القيمة فارغة".tr);

              controller.clear();
            } else if (!isNumeric(value)) {
              showErrorDialog("خطأ".tr, "يجب أن تكون القيمة رقمية".tr);

              controller.clear();
            } else {
              onChange(value);
            }
          },
        ),
      ),
    );
  }
}
