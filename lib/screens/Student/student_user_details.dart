import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';

import 'package:vision_dashboard/models/Student_Model.dart';
import 'package:vision_dashboard/models/event_record_model.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';
import 'package:vision_dashboard/screens/Student/widgets/AddSTIdImageButton.dart';
import 'package:vision_dashboard/screens/Student/widgets/STIdImageListWidget.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down_with_value.dart';
import 'package:vision_dashboard/screens/Widgets/Insert_shape_Widget.dart';
import 'package:vision_dashboard/screens/Widgets/header.dart';
import 'package:vision_dashboard/screens/classes/Controller/Class_View_Model.dart';
import '../../core/constant/constants.dart';
import '../../core/Utils/service.dart';
import '../event/Controller/event_view_model.dart';
import '../../models/event_model.dart';
import '../../core/constant/const.dart';
import '../Widgets/Custom_Text_Filed.dart';

class StudentInputForm extends StatefulWidget {
  @override
  _StudentInputFormState createState() => _StudentInputFormState();

  StudentInputForm({this.studentModel});

  final StudentModel? studentModel;
}

class _StudentInputFormState extends State<StudentInputForm> {
  EventModel? selectedEvent = EventModel(name: "name", id: "id", role: "role", color: 0);
  TextEditingController bodyEvent = TextEditingController();

  final studentNameController = TextEditingController();
  final studentNumberController = TextEditingController();

  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final classController = TextEditingController()
    ..text = '';

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final busController = TextEditingController();
  final guardianController = TextEditingController();
  final languageController = TextEditingController();
  final editController = TextEditingController();
  final gpaController = TextEditingController()
    ..text = "0";

  List<EventRecordModel> eventRecords = [];
  String parentName = '';


  ClassViewModel classViewModel = Get.find<ClassViewModel>();
  StudentViewModel studentViewModel = Get.find<StudentViewModel>();

  String busValue = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    if (widget.studentModel != null) {
      studentNameController.text = widget.studentModel!.studentName ?? '';
      studentNumberController.text = widget.studentModel!.studentNumber ?? '';
      busController.text = widget.studentModel!.bus ?? '';
      busValue = Get
          .find<BusViewModel>()
          .busesMap[widget.studentModel!.bus]?.name ?? widget.studentModel!.bus!;
      genderController.text = widget.studentModel!.gender ?? '';
      gpaController.text = widget.studentModel!.grade.toString();
      ageController.text = widget.studentModel!.StudentBirthDay ?? '';
      classController.text = widget.studentModel!.stdClass ?? '';
      startDateController.text = widget.studentModel!.startDate ?? '';
      busController.text = widget.studentModel!.bus ?? '';
      guardianController.text = widget.studentModel!.parentId!;
      parentName = Get
          .find<ParentsViewModel>()
          .parentMap[widget.studentModel!.parentId!]?.fullName ?? "";
      languageController.text = widget.studentModel!.stdLanguage ?? '';

      eventRecords = widget.studentModel!.eventRecords ?? [];
      studentViewModel.contracts = widget.studentModel!.contractsImage ?? [];
    }
  }

  clearController() async {
    eventRecords.clear();
    studentNameController.clear();
    studentNumberController.clear();
    genderController.text = '';
    ageController.clear();
    classController.clear();
    startDateController.clear();
    busController.clear();
    guardianController.clear();
    gpaController.text = "0";
    endDateController.clear();
    parentName = '';
    languageController.text = '';
    busValue = '';
    studentViewModel.contracts.clear();
    studentViewModel.contractsTemp.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: "اضافة طالب جديد".tr, middleText: "", context: context),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InsertShapeWidget(
                titleWidget: Text(
                  "معلومات الطالب".tr,
                  style: AppStyles.headLineStyle1,
                ),
                bodyWidget: Wrap(
                  clipBehavior: Clip.hardEdge,
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceEvenly,
                  runSpacing: 50,
                  spacing: 25,
                  children: <Widget>[
                    CustomTextField(controller: studentNameController, title: "اسم الطالب".tr),
                    CustomDropDown(
                      value: parentName,
                      listValue: Get
                          .find<ParentsViewModel>()
                          .parentMap
                          .values
                          .map(
                            (e) => e.fullName!,
                      )
                          .toList(),
                      label: 'ولي الأمر'.tr,
                      onChange: (value) {
                        if (value != null) {
                          parentName = value;
                          guardianController.text = Get
                              .find<ParentsViewModel>()
                              .parentMap
                              .values
                              .where(
                                (element) => element.fullName == value,
                          )
                              .first
                              .id!;
                        }
                      },
                    ),
                    CustomTextField(controller: studentNumberController, title: 'رقم الطالب'.tr, keyboardType: TextInputType.phone),
                    CustomDropDown(
                      value: genderController.text,
                      listValue: sexList,
                      label: 'الجنس'.tr,
                      onChange: (value) {
                        if (value != null) {
                          genderController.text = value;
                        }
                      },
                    ),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                        ).then((date) {
                          if (date != null) {
                            ageController.text = date.toString().split(" ")[0];
                          }
                        });
                      },
                      child: CustomTextField(
                        controller: ageController,
                        title: 'الميلاد'.tr,
                        enable: false,
                        keyboardType: TextInputType.datetime,
                        icon: Icon(
                          Icons.date_range_outlined,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    CustomDropDown(
                      value: classController.text,
                      listValue: classViewModel.classMap.values
                          .map(
                            (e) => e.className!,
                      )
                          .toList(),
                      label: 'الصف'.tr,
                      onChange: (value) {
                        if (value != null) {
                          classController.text = value;
                          setState(() {});
                        }
                      },
                    ),
                    CustomDropDown(
                      value: languageController.text,
                      listValue: languageList,
                      label: 'اللغة'.tr,
                      onChange: (value) {
                        if (value != null) {
                          languageController.text = value;
                        }
                      },
                    ),
                    CustomDropDown(
                      value: busValue,
                      listValue: Get
                          .find<BusViewModel>()
                          .busesMap
                          .values
                          .map(
                            (e) => e.name!,
                      )
                          .toList() +
                          ['بدون حافلة', 'مع حافلة'],
                      label: 'الحافلة'.tr,
                      onChange: (value) {
                        if (value != null) {
                          busValue = value;
                          final busViewController = Get.find<BusViewModel>();
                          if (busViewController.busesMap.isNotEmpty) {
                            busController.text = busViewController.busesMap.values
                                .where(
                                  (element) => element.name == value,
                            )
                                .firstOrNull
                                ?.busId ??
                                value;
                          } else
                            busController.text = value;
                        }
                      },
                    ),
                    if (widget.studentModel != null)
                      CustomTextField(
                        controller: gpaController,
                        title: 'المعدل'.tr,
                        enable: true,
                        keyboardType: TextInputType.datetime,
                        icon: Icon(
                          Icons.date_range_outlined,
                          color: primaryColor,
                        ),
                      ),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                        ).then((date) {
                          if (date != null) {
                            startDateController.text = date.toString().split(" ")[0];
                          }
                        });
                      },
                      child: CustomTextField(
                        controller: startDateController,
                        title: 'تاريخ البداية'.tr,
                        enable: false,
                        keyboardType: TextInputType.datetime,
                        icon: Icon(
                          Icons.date_range_outlined,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    if (widget.studentModel != null)
                      InkWell(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2100),
                          ).then((date) {
                            if (date != null) {
                              endDateController.text = date.toString().split(" ")[0];
                            }
                          });
                        },
                        child: CustomTextField(
                          controller: endDateController,
                          title: 'تاريخ النهاية'.tr,
                          enable: false,
                          keyboardType: TextInputType.datetime,
                          icon: Icon(
                            Icons.date_range_outlined,
                            color: primaryColor,
                          ),
                        ),
                      ),

                    GetBuilder<StudentViewModel>(builder: (logic) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          StudentAddIdImageButton(studentViewModel),

                          ...StudentImageList(studentViewModel.contractsTemp, studentViewModel, true),
                          ...StudentImageList(studentViewModel.contracts, studentViewModel, false),
                          /*     SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? _ = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
                                  if (_ != null) {
                                    _.files.forEach(
                                      (element) async {
                                        _contractsTemp.add(element.bytes!);
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
                                _contractsTemp.length,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                                        width: 200,
                                        height: 200,
                                        child: Image.memory(
                                          (_contractsTemp[index]),
                                          height: 200,
                                          width: 200,
                                          fit: BoxFit.fitHeight,
                                        )),
                                  );
                                },
                              ),
                              ...List.generate(
                                _contracts.length,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                                        width: 200,
                                        height: 200,
                                        child: Image.network(
                                          _contracts[index],
                                          height: 200,
                                          width: 200,
                                          fit: BoxFit.fitHeight,
                                        )),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),*/
                        ],
                      );
                    }),
                    if (widget.studentModel != null) CustomTextField(controller: editController, title: 'سبب التعديل'.tr),
                    GetBuilder<StudentViewModel>(builder: (controller) {
                      return AppButton(
                        text: "حفظ".tr,
                        onPressed: () async {
                          save(controller);
                        },
                      );
                    }),
                  ],
                )),
            if (widget.studentModel != null) ...[
              SizedBox(
                height: defaultPadding,
              ),
              InsertShapeWidget(
                titleWidget: Text(
                  "معلومات الحداث",
                  style: AppStyles.headLineStyle1,
                ),
                bodyWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GetBuilder<EventViewModel>(builder: (eventController) {
                      return Wrap(
                        runAlignment: WrapAlignment.spaceEvenly,
                        alignment: WrapAlignment.spaceEvenly,

                        runSpacing: 25,
                        spacing: 25,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomDropDownWithValue(
                            value: '',
                            mapValue: eventController.allEvents.values
                                .toList()
                                .where(
                                  (element) => element.role == Const.eventTypeStudent,
                            )
                                .toList(),
                            label: "نوع الحدث".tr,
                            onChange: (selectedWay) {
                              if (selectedWay != null) {
                                setState(() {});
                                selectedEvent = Get
                                    .find<EventViewModel>()
                                    .allEvents[selectedWay];
                                // selectedEvent = selectedWay;
                              }
                            },
                          ),
                          CustomTextField(controller: bodyEvent, title: 'الوصف'.tr, enable: true, keyboardType: TextInputType.text),
                          AppButton(
                            text: 'إضافة سجل حدث'.tr,
                            onPressed: () {
                              // DateTime dateTime= await NTP.now();
                              eventRecords.add(EventRecordModel(body: bodyEvent.text, type: selectedEvent!.name, date: Timestamp.now().toDate().toIso8601String(), color: selectedEvent!.color.toString()));
                              bodyEvent.clear();
                              setState(() {});
                            },
                          )
                        ],
                      );
                    }),
                    SizedBox(height: defaultPadding * 2),
                    Text('سجل الأحداث'.tr, style: AppStyles.headLineStyle1),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: eventRecords.length,
                        itemBuilder: (context, index) {
                          final record = eventRecords[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(color: Color(int.parse(record.color)).withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      record.type,
                                      style: AppStyles.headLineStyle1.copyWith(color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      record.body,
                                      style: AppStyles.headLineStyle1.copyWith(color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      record.date,
                                      style: AppStyles.headLineStyle3,
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        eventRecords.removeAt(index);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                  ],
                ),
              ),
              /*           Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child:
            )*/
            ]
          ],
        ),
      ),
    );
  }

  save(StudentViewModel controller) async {
    if (validateFields(requiredControllers: [], numericControllers: [])) {
      QuickAlert.show(width: Get.width / 2,
          context: context,
          type: QuickAlertType.loading,
          title: 'جاري التحميل'.tr,
          text: 'يتم العمل على الطلب'.tr,
          barrierDismissible: false);

      await uploadImages(studentViewModel.contractsTemp, "contracts").then(
            (value) => studentViewModel.contracts.addAll(value),
      );
      final student = StudentModel(
        stdExam: widget.studentModel?.stdExam,
        studentID: widget.studentModel == null ? generateId("STD") : widget.studentModel!.studentID!,
        parentId: guardianController.text,
        stdLanguage: languageController.text,
        isAccepted: widget.studentModel == null ? true : false,
        studentNumber: studentNumberController.text,
        StudentBirthDay: ageController.text,
        studentName: studentNameController.text,
        stdClass: classController.text,
        contractsImage: studentViewModel.contracts,
        gender: genderController.text,
        grade: double.parse(gpaController.text),
        bus: busController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        eventRecords: eventRecords,
      );
      if (widget.studentModel != null) {
        addWaitOperation(collectionName: studentCollection,

            userName: currentEmployee?.userName.toString() ?? "",

            affectedId: widget.studentModel!.studentID!,
            type: waitingListTypes.edite,
            oldData: widget.studentModel!.toJson(),
            newData: student.toJson(),
            details: editController.text);

        if (widget.studentModel!.parentId != guardianController.text) {
          Get.find<ParentsViewModel>().deleteStudent(widget.studentModel!.parentId!, widget.studentModel!.studentID!);
        }
        if (widget.studentModel!.bus != busController.text) {
          Get.find<BusViewModel>().deleteStudent(widget.studentModel!.bus!, widget.studentModel!.studentID!);
        }
      }
      await controller.addStudent(student);
      clearController();
      setState(() {});
      if (widget.studentModel != null) Get.back();
      Get.back();
    }
  }
}
