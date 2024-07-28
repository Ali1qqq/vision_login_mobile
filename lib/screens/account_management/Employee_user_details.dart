import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/models/event_model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down.dart';

import '../../controller/account_management_view_model.dart';
import '../../controller/event_view_model.dart';
import '../../controller/home_controller.dart';
import '../../models/account_management_model.dart';
import '../../models/event_record_model.dart';
import '../../utils/Dialogs.dart';
import '../../utils/const.dart';
import '../Buses/Controller/Bus_View_Model.dart';
import '../Widgets/Custom_Drop_down_with_value.dart';
import '../Widgets/Custom_Text_Filed.dart';

class EmployeeInputForm extends StatefulWidget {
  @override
  _EmployeeInputFormState createState() => _EmployeeInputFormState();

  EmployeeInputForm({this.accountManagementModel, this.enableEdit = true});

  late final AccountManagementModel? accountManagementModel;
  final bool? enableEdit;
}

class _EmployeeInputFormState extends State<EmployeeInputForm> {
  final fullNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final addressController = TextEditingController();
  final nationalityController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final jobTitleController = TextEditingController();
  final salaryController = TextEditingController();
  final contractController = TextEditingController();
  final busController = TextEditingController();
  final startDateController = TextEditingController();
  final eventController = TextEditingController();
  final bodyEvent = TextEditingController();
  final dayWorkController = TextEditingController();
  final editController = TextEditingController();
  Map accountType = {
    "user": "مستخدم".tr,
    "admin": "مدير".tr,
    "superAdmin": "مالك".tr,
  };
  String busValue = '';
  String? role = '';
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPassController = TextEditingController();
  HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  AccountManagementViewModel accountManagementViewModel =
      Get.find<AccountManagementViewModel>();
  EventModel? selectedEvent;
  List<EventRecordModel> eventRecords = [];
  bool isUpdate = false;

  @override
  void initState() {
    accountManagementViewModel.initNFC(typeNFC.add);
    super.initState();
    init();
  }

  @override
  void dispose() {
    accountManagementViewModel.disposeNFC();
    fullNameController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    nationalityController.dispose();
    genderController.dispose();
    ageController.dispose();
    jobTitleController.dispose();
    salaryController.dispose();
    contractController.dispose();
    busController.dispose();
    startDateController.dispose();
    eventController.dispose();
    bodyEvent.dispose();
    super.dispose();
  }

  clearController() {
    fullNameController.clear();
    mobileNumberController.clear();
    addressController.clear();
    nationalityController.clear();
    genderController.clear();
    ageController.clear();
    jobTitleController.clear();
    salaryController.clear();
    contractController.clear();
    busController.clear();
    startDateController.clear();
    eventController.clear();
    bodyEvent.clear();
    dayWorkController.clear();
    bodyEvent.clear();
    userNameController.clear();
    userPassController.clear();
    editController.clear();
    eventRecords.clear();
    accountManagementViewModel.nfcController.clear();
    role = '';
  }

  init() {
    if (widget.accountManagementModel != null) {
      isUpdate = true;
      fullNameController.text =
          widget.accountManagementModel!.fullName.toString();
      mobileNumberController.text =
          widget.accountManagementModel!.mobileNumber.toString();
      addressController.text =
          widget.accountManagementModel!.address.toString();
      nationalityController.text =
          widget.accountManagementModel!.nationality.toString();
      genderController.text = widget.accountManagementModel!.gender.toString();
      ageController.text = widget.accountManagementModel!.age.toString();
      jobTitleController.text =
          widget.accountManagementModel!.jobTitle.toString();
      salaryController.text = widget.accountManagementModel!.salary.toString();
      contractController.text =
          widget.accountManagementModel!.contract.toString();
      busController.text = widget.accountManagementModel!.bus.toString();
      startDateController.text =
          widget.accountManagementModel!.startDate.toString();
      dayWorkController.text =
          widget.accountManagementModel!.dayOfWork.toString();
      bodyEvent.clear();
      userNameController.text =
          widget.accountManagementModel!.userName.toString();
      userPassController.text =
          widget.accountManagementModel!.password.toString();
      widget.accountManagementModel!.eventRecords?.forEach(
        (element) {
          eventRecords.add(element);
        },
      );
      accountManagementViewModel.nfcController.text =
          widget.accountManagementModel!.serialNFC.toString();
      role = widget.accountManagementModel!.type.toString();
      busValue = Get.find<BusViewModel>()
              .busesMap[widget.accountManagementModel!.bus]
              ?.name ??
          widget.accountManagementModel!.bus!;
    }
  }

  bool _validateFields() {
    if (fullNameController.text.isEmpty ||
        mobileNumberController.text.isEmpty ||
        addressController.text.isEmpty ||
        nationalityController.text.isEmpty ||
        genderController.text.isEmpty ||
        ageController.text.isEmpty ||
        jobTitleController.text.isEmpty ||
        salaryController.text.isEmpty ||
        contractController.text.isEmpty ||
        busController.text.isEmpty ||
        startDateController.text.isEmpty ||
        userNameController.text.isEmpty ||
        userPassController.text.isEmpty ||
        !isNumeric(ageController.text) ||
        !isNumeric(salaryController.text) ||
        !isNumeric(dayWorkController.text)) {
      showErrorDialog(
          "خطأ".tr,
          "يرجى ملء جميع الحقول وتأكد من أن الحقول الرقمية تحتوي على أرقام فقط."
              .tr);
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
                  borderRadius: BorderRadius.circular(15)),
              child: Wrap(
                clipBehavior: Clip.hardEdge,
                direction: Axis.horizontal,
                runSpacing: 50,
                spacing: 25,
                alignment: WrapAlignment.spaceEvenly,
                children: <Widget>[
                  CustomTextField(
                      controller: fullNameController, title: "الاسم الكامل".tr),
                  CustomTextField(
                      controller: mobileNumberController,
                      title: 'رقم الموبايل'.tr,
                      keyboardType: TextInputType.phone),
                  CustomTextField(
                      controller: addressController, title: 'العنوان'.tr),
                  CustomTextField(
                      controller: nationalityController, title: 'الجنسية'.tr),
                  CustomDropDown(
                    value: genderController.text.tr,
                    listValue: sexList
                        .map(
                          (e) => e.tr,
                        )
                        .toList(),
                    label: 'الجنس'.tr,
                    onChange: (value) {
                      if (value != null) {
                        genderController.text = value.tr;
                      }
                    },
                  ),
                  CustomTextField(
                      controller: ageController,
                      title: 'العمر'.tr,
                      keyboardType: TextInputType.number),
                  CustomTextField(
                      controller: dayWorkController,
                      title: 'عدد ايام العمل'.tr,
                      keyboardType: TextInputType.number),
                  CustomDropDown(
                      value: jobTitleController.text,
                      listValue: jobList
                          .map(
                            (e) => e.tr,
                          )
                          .toList(),
                      label: 'الوظيفة'.tr,
                      onChange: (value) {
                        if (value != null) {
                          jobTitleController.text = value.tr;
                        }
                      }),
                  CustomTextField(
                      controller: salaryController,
                      title: 'الراتب'.tr,
                      keyboardType: TextInputType.number),
                  CustomDropDown(
                    value: contractController.text,
                    listValue: contractsList
                        .map(
                          (e) => e.tr,
                        )
                        .toList(),
                    label: 'العقد'.tr,
                    onChange: (value) {
                      if (value != null) {
                        contractController.text = value.tr;
                      }
                    },
                  ),
                  CustomDropDown(
                    value: busValue,
                    listValue: Get.find<BusViewModel>()
                            .busesMap
                            .values
                            .map(
                              (e) => e.name!,
                            )
                            .toList() +
                        ['بدون حافلة'],
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
                  InkWell(
                    onTap: () {
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
                  CustomTextField(
                      controller: userNameController,
                      title: 'اسم المستخدم'.tr,
                      keyboardType: TextInputType.text),
                  CustomTextField(
                      controller: userPassController,
                      title: 'كلمة المرور'.tr,
                      keyboardType: TextInputType.text),
                  CustomTextField(
                      controller: accountManagementViewModel.nfcController,
                      title: 'بطاقة الدخول'.tr,
                      isFullBorder: true,
                      enable: false,
                      keyboardType: TextInputType.datetime),
                  CustomDropDown(
                    value: role.toString(),
                    listValue: accountType.entries
                        .map((e) => e.value.toString().tr)
                        .toList(),
                    label: "الدور".tr,
                    onChange: (_) {
                      role = _;
                      setState(() {});
                    },
                  ),
                  if (isUpdate && widget.enableEdit!)
                    CustomTextField(
                        controller: editController,
                        title: 'سبب التعديل'.tr,
                        keyboardType: TextInputType.text),
                  if (widget.enableEdit!)
                    GetBuilder<AccountManagementViewModel>(
                        builder: (controller) {
                      return AppButton(
                        text: "حفظ".tr,
                        onPressed: () async {
                          if (_validateFields()) {
                            QuickAlert.show(
                                width: Get.width / 2,
                                context: context,
                                type: QuickAlertType.loading,
                                title: 'جاري التحميل'.tr,
                                text: 'يتم العمل على الطلب'.tr,
                                barrierDismissible: false);
                            try {
                              role ??= accountType.keys.first;
                              AccountManagementModel model =
                                  AccountManagementModel(
                                id: !isUpdate
                                    ? generateId("EMPLOYEE")
                                    : widget.accountManagementModel!.id,
                                userName: userNameController.text,
                                fullName: fullNameController.text,
                                password: userPassController.text,
                                type: role!,
                                serialNFC: accountManagementViewModel
                                    .nfcController.text,
                                isActive: true,
                                isAccepted: false,
                                salary: int.parse(salaryController.text),
                                dayOfWork: int.parse(dayWorkController.text),
                                mobileNumber: mobileNumberController.text,
                                address: addressController.text,
                                nationality: nationalityController.text,
                                gender: genderController.text,
                                age: ageController.text,
                                jobTitle: jobTitleController.text,
                                contract: contractController.text,
                                bus: busController.text,
                                startDate: startDateController.text,
                                eventRecords: eventRecords,
                                discounts:
                                    widget.accountManagementModel?.discounts,
                                salaryReceived: widget
                                    .accountManagementModel?.salaryReceived,
                              );
                              if (busController.text.startsWith("BUS"))
                                Get.find<BusViewModel>()
                                    .addEmployee(busController.text, model.id);
                              if (isUpdate) {
                                addWaitOperation(
                                    collectionName: accountManagementCollection,
                                    affectedId:
                                        widget.accountManagementModel!.id,
                                    type: waitingListTypes.edite,
                                    oldData:
                                        widget.accountManagementModel!.toJson(),
                                    newData: model.toJson(),
                                    details: editController.text);

                                if (widget.accountManagementModel!.bus !=
                                    busController.text) {
                                  Get.find<BusViewModel>().deleteEmployee(
                                      widget.accountManagementModel!.bus!,
                                      widget.accountManagementModel!.id);
                                }
                              }

                              if (!isUpdate)
                                await addWaitOperation(
                                    collectionName: accountManagementCollection,
                                    affectedId: model.id,
                                    details: model.toJson(),
                                    type: waitingListTypes.add);

                              if (isUpdate) Get.back();
                              Get.back();
                              await controller.addAccount(model);
                              getSuccessDialog(context);
                              clearController();
                            } on Exception catch (e) {
                              await getReedOnlyError(context,
                                  title: e.toString());
                              print(e.toString());
                              Get.back();
                              Get.back();
                            }
                          }
                        },
                      );
                    }),
                ],
              ),
            ),
            SizedBox(height: 16.0),
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
                  if (widget.enableEdit!)
                    GetBuilder<EventViewModel>(builder: (eventController) {
                      return Wrap(
                        runAlignment: WrapAlignment.spaceAround,
                        runSpacing: 25,
                        children: [
                          CustomDropDownWithValue(

                            value: '',
                            mapValue: eventController.allEvents.values
                                .toList()
                                .where(
                                  (element) =>
                                      element.role == Const.eventTypeEmployee,
                                )
                                .map((e) => e)
                                .toList(),
                            label: "نوع الحدث".tr,
                            onChange: (selectedWay) {
                              if (selectedWay != null) {
                                setState(() {});
                                selectedEvent =
                                    eventController.allEvents[selectedWay];
                              }
                            },
                          ),
                          SizedBox(width: 16.0),
                          CustomTextField(
                            controller: bodyEvent,
                            title: 'الوصف'.tr,
                            enable: true,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(width: 16.0),
                          AppButton(
                            text: 'إضافة سجل حدث'.tr,
                            onPressed: () {
                              setState(() {
                                eventRecords.add(EventRecordModel(
                                  body: bodyEvent.text,
                                  type: selectedEvent!.name,
                                  date: thisTimesModel!.dateTime
                                      .toString()
                                      .split(".")[0],
                                  color: selectedEvent!.color.toString(),
                                ));
                                bodyEvent.clear();
                              });
                            },
                          ),
                        ],
                      );
                    }),
                  if (widget.enableEdit!) SizedBox(height: defaultPadding * 2),
                  Text('سجل الأحداث:'.tr, style: Styles.headLineStyle1),
                  SizedBox(height: defaultPadding),
                  Container(
                    padding: EdgeInsets.all(0.0),
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
                            decoration: BoxDecoration(
                              color: Color(int.parse(record.color))
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 10),
                              child: Row(
                                children: [
                                  Text(
                                    record.type,
                                    style: Styles.headLineStyle1
                                        .copyWith(color: Colors.black),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    record.body,
                                    style: Styles.headLineStyle1
                                        .copyWith(color: Colors.black),
                                  ),
                                  SizedBox(width: 50),
                                  Text(
                                    record.date,
                                    style: Styles.headLineStyle3,
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
