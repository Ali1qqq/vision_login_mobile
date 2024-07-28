import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';
import 'package:vision_dashboard/models/account_management_model.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import '../../constants.dart';
import '../../controller/home_controller.dart';
import '../../models/Bus_Model.dart';
import '../../models/Student_Model.dart';
import '../../models/event_record_model.dart';
import '../Widgets/Custom_Text_Filed.dart';

class BusInputForm extends StatefulWidget {
  BusInputForm({
    this.busModel,
  });

  @override
  _BusInputFormState createState() => _BusInputFormState();

  late final BusModel? busModel;
}

class _BusInputFormState extends State<BusInputForm> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final typeController = TextEditingController();
  final editController = TextEditingController();

  final startDateController = TextEditingController();

  List<String> selectedEmployee = [];
  List<EventRecordModel> eventRecords = [];
  List<String> selectedStudent = [];
  List dataStu = ["اسم الطالب", "الرقم", "الوالد", "موجود"];
  List dataEMP = ['اسم الموظف', "العنوان", "الجنس", "موجود"];

  Map<String, StudentModel> allSection =
      Get.find<StudentViewModel>().studentMap;
  Map<String, AccountManagementModel> allEmployee =
      Get.find<AccountManagementViewModel>().allAccountManagement;

  final ScrollController _scrollControllerStd = ScrollController();
  final ScrollController _scrollControllerEmp = ScrollController();

  initBus() {
    if (widget.busModel != null) {
      nameController.text = widget.busModel!.name.toString();
      numberController.text = widget.busModel!.number.toString();
      typeController.text = widget.busModel!.type.toString();
      startDateController.text =
          widget.busModel!.startDate.toString().split(" ")[0];

      allEmployee.forEach(
        (key, value) {
          if (widget.busModel!.employees!.contains(key)) {
            value.available = true;
            selectedEmployee.add(key);
          }
        },
      );
      allSection.forEach(
        (key, value) {
          if (widget.busModel!.students!.contains(key)) {
            value.available = true;
            selectedStudent.add(key);
          }
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBus();
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    typeController.dispose();
    startDateController.dispose();
    super.dispose();
  }

  clearControl() {
    nameController.clear();
    numberController.clear();
    typeController.clear();
    startDateController.clear();
    editController.clear();
    allSection.removeWhere((key, value) => value.available==true,);
    allEmployee.removeWhere((key, value) => value.available==true,);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.all(25.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Wrap(
                  clipBehavior: Clip.hardEdge,
                  direction: Axis.horizontal,
                  runSpacing: 50,
                  spacing: 25,
                  children: [
                    CustomTextField(
                        controller: nameController, title: 'اسم الحافلة'.tr),
                    CustomTextField(
                        controller: numberController, title: 'رقم الحافلة'.tr),
                    CustomTextField(
                        controller: typeController, title: 'نوع الحافلة'.tr),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          controller: startDateController,
                          title: 'تاريخ البداية'.tr,
                          enable: false,
                          keyboardType: TextInputType.datetime,
                        ),
                        IconButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2100),
                            ).then((date) {
                              if (date != null) {
                                startDateController.text =
                                    date.toString().split(" ")[0];
                              }
                            });
                          },
                          icon: Icon(
                            Icons.date_range_outlined,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    if(widget.busModel!=null)
                    CustomTextField(
                        controller: editController, title: 'سبب التعديل'.tr),
                    GetBuilder<BusViewModel>(builder: (busController) {
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
                          BusModel bus = BusModel(
                            name: nameController.text,
                            busId: widget.busModel == null
                                ? generateId("BUS")
                                : widget.busModel!.busId!,
                            number: numberController.text,
                            type: typeController.text,
                            employees: selectedEmployee,
                            students: selectedStudent,
                            isAccepted: widget.busModel == null
                                ? true:false,
                            eventRecords: [],
                            expense: [],
                            startDate: DateTime.parse(startDateController.text),
                          );
                          await busController.addBus(bus);


                            await Get.find<StudentViewModel>()
                                .setBus("بدون حافلة", widget.busModel?.students??[]);
                          await Get.find<AccountManagementViewModel>()
                              .setBus("بدون حافلة", widget.busModel?.employees??[]);
                            await Get.find<StudentViewModel>()
                                .setBus(bus.busId!, selectedStudent);
                            await Get.find<AccountManagementViewModel>()
                                .setBus(bus.busId!, selectedEmployee);

                          if (widget.busModel != null) {
                            addWaitOperation(
                              collectionName: busesCollection,
                              affectedId: widget.busModel!.busId!,
                              type: waitingListTypes.edite,
                              details: editController.text,
                              oldData: widget.busModel!.toJson(),
                              newData: bus.toJson(),
                            );
                            Get.back();
                          }
                          clearControl();
                          Get.back();
                        },
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GetBuilder<HomeViewModel>(builder: (controller) {
                  double size = max(
                          MediaQuery.sizeOf(context).width -
                              (controller.isDrawerOpen ? 240 : 120),
                          1000) -
                      60;
                  return SizedBox(
                      width: size + 60,
                      child: Scrollbar(
                        controller: _scrollControllerStd,
                        child: SingleChildScrollView(
                          controller: _scrollControllerStd,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            clipBehavior: Clip.hardEdge,
                            columns: List.generate(
                                dataStu.length,
                                (index) => DataColumn(
                                    label: Container(
                                        width: size / (dataStu.length),
                                        child: Center(
                                            child: Text(dataStu[index]
                                                .toString()
                                                .tr))))),
                            rows: allSection.values.where((element) => element.bus=="بدون حافلة"&&element.isAccepted==true,)
                                .map(
                                  (e) => studentDataRow(
                                    e,
                                    size / (dataStu.length),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ));
                }),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GetBuilder<HomeViewModel>(builder: (controller) {
                  double size = max(
                          MediaQuery.sizeOf(context).width -
                              (controller.isDrawerOpen ? 240 : 120),
                          1000) -
                      60;
                  return SizedBox(
                      width: size + 60,
                      child: Scrollbar(
                          controller: _scrollControllerEmp,
                          child: SingleChildScrollView(
                            controller: _scrollControllerEmp,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              clipBehavior: Clip.hardEdge,
                              columns: List.generate(
                                  dataStu.length,
                                  (index) => DataColumn(
                                      label: Container(
                                          width: size / (dataEMP.length),
                                          child: Center(
                                              child: Text(dataEMP[index]
                                                  .toString()
                                                  .tr))))),
                              rows: allEmployee.values.where((element) => element.bus=="بدون حافلة"&&element.isAccepted==true,)
                                  .map(
                                    (e) => employeeDataRow(
                                      e,
                                      size / (dataEMP.length),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )));
                }),
              ),
              SizedBox(height: 16.0),
            ])));
  }

  DataRow studentDataRow(StudentModel student, size) {
    return DataRow(
      cells: [
        DataCell(Container(
            alignment: Alignment.center,
            width: size,
            child: Text(student.studentName.toString()))),
        DataCell(Container(
            alignment: Alignment.center,
            width: size,
            child: Text(student.studentNumber.toString()))),
        DataCell(Container(
            alignment: Alignment.center,
            width: size,
            child: Text(student.parentId.toString()))),
        DataCell(Container(
          alignment: Alignment.center,
          width: size,
          child: Checkbox(
            fillColor: WidgetStateProperty.all(primaryColor),
            checkColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onChanged: (v) {
              student.available = v ?? false;
              selectedStudent.contains(student.studentID)
                  ? selectedStudent.remove(student.studentID)
                  : selectedStudent.add(student.studentID.toString());

              setState(() {});
            },
            value: student.available,
          ),
        )),
      ],
    );
  }

  DataRow employeeDataRow(AccountManagementModel employee, size) {
    return DataRow(
      cells: [
        DataCell(Container(
            alignment: Alignment.center,
            width: size,
            child: Text(employee.userName.toString()))),
        DataCell(Container(
            alignment: Alignment.center,
            width: size,
            child: Text(employee.address.toString()))),
        DataCell(Container(
            alignment: Alignment.center,
            width: size,
            child: Text(employee.startDate.toString()))),
        DataCell(Container(
          alignment: Alignment.center,
          width: size,
          child: Checkbox(
            fillColor: WidgetStateProperty.all(primaryColor),
            checkColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onChanged: (v) {
              employee.available = v ?? false;
              selectedEmployee.contains(employee.id)
                  ? selectedEmployee.remove(employee.id)
                  : selectedEmployee.add(employee.id.toString());
              setState(() {});
            },
            value: employee.available,
          ),
        )),
      ],
    );
  }
}
