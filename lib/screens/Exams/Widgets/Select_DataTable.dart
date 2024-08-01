import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controller/home_controller.dart';
import '../../../models/Student_Model.dart';
import '../../Parents/Controller/Parents_View_Model.dart';
import '../../Student/Controller/Student_View_Model.dart';

class SelectDataTable extends StatefulWidget {
  final HomeViewModel controller;
  final ScrollController firstScroll;
  final StudentViewModel studentViewModel;
  final String _selectedClass;
  Map<String, String> _selectedStudent = {};

  SelectDataTable({
    required this.controller,
    required this.firstScroll,
    required this.studentViewModel,
    required String selectedClass,
    required  Map<String, String> selectedStudent,
  })  : _selectedClass = selectedClass,
        _selectedStudent = selectedStudent;

  @override
  State<SelectDataTable> createState() => _SelectDataTableState();
}

class _SelectDataTableState extends State<SelectDataTable> {
  @override
  Widget build(BuildContext context) {
    double size = _calculateSize(context, widget.controller);

    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        width: size + 60,
        child: Scrollbar(
          controller: widget.firstScroll,
          child: SingleChildScrollView(
            controller: widget.firstScroll,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              clipBehavior: Clip.hardEdge,
              columns: _buildColumns(size),
              rows: _buildRows(widget.studentViewModel,size),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateSize(BuildContext context, HomeViewModel controller) {
    return max(MediaQuery.sizeOf(context).width - (controller.isDrawerOpen ? 240 : 120), 1000) - 60;
  }

  List<DataColumn> _buildColumns(double size) {
    return [
      _buildColumn("اسم الطالب", size),
      _buildColumn("رقم الطالب", size),
      _buildColumn("تاريخ البداية", size),
      _buildColumn("ولي الأمر", size),
      _buildColumn("موجود", size),
    ];
  }

  DataColumn _buildColumn(String label, double size) {
    return DataColumn(
      label: SizedBox(
        width: size / 5,
        child: Center(child: Text(label)),
      ),
    );
  }

  List<DataRow> _buildRows(StudentViewModel studentViewModel,size) {
    return studentViewModel.studentMap.values
        .where((element) => element.stdClass == widget._selectedClass && element.isAccepted == true)
        .map((e) {
      if (widget._selectedStudent.containsKey(e.studentID)) {
        e.available = true;
      }
      return studentDataRow(e, size / 5);
    }).toList();
  }

  DataRow studentDataRow(StudentModel student, size) {
    return DataRow(
      cells: [
        DataCell(SizedBox(width: size, child: Center(child: Text(student.studentName.toString())))),
        DataCell(SizedBox(width: size, child: Center(child: Text(student.studentNumber.toString())))),
        DataCell(SizedBox(width: size, child: Center(child: Text(student.startDate.toString())))),
        DataCell(SizedBox(width: size, child: Center(child: Text(Get.find<ParentsViewModel>().parentMap[student.parentId!]?.fullName ?? student.parentId!)))),
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
                  widget._selectedStudent.remove(student.studentID);
                } else {
                  student.available = v;
                  widget._selectedStudent[student.studentID!] = '0.0';
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
}
