 import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down_with_value.dart';

import '../../constants.dart';
import '../../controller/event_view_model.dart';

import '../../models/Parent_Model.dart';
import '../../models/event_model.dart';
import '../../models/event_record_model.dart';
import '../../utils/Dialogs.dart';
import '../../utils/const.dart';
import '../Widgets/Custom_Text_Filed.dart';

class ParentInputForm extends StatefulWidget {
  ParentInputForm({this.parent});

  final ParentModel? parent;

  @override
  _ParentInputFormState createState() => _ParentInputFormState();
}

class _ParentInputFormState extends State<ParentInputForm> {
  final fullNameController = TextEditingController();
  final numberController = TextEditingController();
  final addressController = TextEditingController();
  final nationalityController = TextEditingController();
  final ageController = TextEditingController();
  final startDateController = TextEditingController();
  final motherPhoneNumberController = TextEditingController();
  final bodyEventController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final workController = TextEditingController();
  final editController = TextEditingController();

  List<EventRecordModel> eventRecords = [];
  EventModel? selectedEvent;
  List<String> _contracts = [];
  List<Uint8List> _contractsTemp = [];

  final idNumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.parent != null) {
      fullNameController.text = widget.parent!.fullName.toString();
      numberController.text = widget.parent!.phoneNumber.toString();
      addressController.text = widget.parent!.address.toString();
      nationalityController.text = widget.parent!.nationality.toString();
      ageController.text = widget.parent!.age.toString();
      startDateController.text = widget.parent!.startDate.toString();
      motherPhoneNumberController.text = widget.parent!.motherPhone.toString();
      emergencyPhoneController.text = widget.parent!.emergencyPhone.toString();
      workController.text = widget.parent!.work.toString();
      eventRecords = widget.parent!.eventRecords ?? [];
      idNumController.text=widget.parent!.parentID??'';
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    numberController.dispose();
    addressController.dispose();
    nationalityController.dispose();
    ageController.dispose();
    startDateController.dispose();
    motherPhoneNumberController.dispose();
    bodyEventController.dispose();
    emergencyPhoneController.dispose();
    workController.dispose();
    eventRecords.clear();
    super.dispose();
  }

  // Function to validate form fields
  bool _validateFields() {
    if (!validateNotEmpty(fullNameController.text, "الاسم الكامل".tr))
      return false;
    if (!validateNumericField(numberController.text, "رقم الهاتف".tr))
      return false;
    if (!validateNumericField(idNumController.text, "رقم الهوية".tr))
      return false;
    if (!validateNotEmpty(addressController.text, "العنوان".tr)) return false;
    if (!validateNotEmpty(nationalityController.text, "الجنسية".tr))
      return false;
    if (!validateNumericField(ageController.text, "العمر".tr)) return false;
    if (!validateNumericField(
        motherPhoneNumberController.text, "رقم هاتف الأم".tr)) return false;
    if (!validateNumericField(emergencyPhoneController.text, "رقم الطوارئ".tr))
      return false;
    if (!validateNotEmpty(workController.text, "العمل".tr)) return false;
    if (!validateNotEmpty(startDateController.text, "تاريخ البداية".tr))
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 25,
                spacing: 25,
                children: [
                  CustomTextField(
                      controller: fullNameController, title: 'الاسم الكامل'.tr),
                  CustomTextField(
                      controller: idNumController, title: 'رقم الهوية'.tr),
                  CustomTextField(
                      controller: numberController,
                      title: 'رقم الهاتف'.tr,
                      keyboardType: TextInputType.number),
                  CustomTextField(
                      controller: addressController, title: 'العنوان'.tr),
                  CustomTextField(
                      controller: nationalityController, title: 'الجنسية'.tr),
                  CustomTextField(
                      controller: ageController,
                      title: 'العمر'.tr,
                      keyboardType: TextInputType.number),
                  CustomTextField(
                      controller: motherPhoneNumberController,
                      title: 'رقم هاتف الام'.tr,
                      keyboardType: TextInputType.number),
                  CustomTextField(
                      controller: emergencyPhoneController,
                      title: 'رقم الطوارئ'.tr,
                      keyboardType: TextInputType.number),
                  CustomTextField(
                      controller: workController, title: 'العمل'.tr),
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
                  /* SizedBox(
                      width: Get.width / 4,
                      child: EasyInfiniteDateTimeLine(
                          selectionMode: const SelectionMode.autoCenter(),
                          headerBuilder: (context, date) {
                            return InkWell(
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2024),
                                  // focusDate: _selectedDate,
                                  lastDate: DateTime(2024, 12, 31),
                                ).then((date0) {
                                  if (date0 != null) {
                                    setState(() {
                                      startDateController.text =
                                      date0.toString().split(" ")[0];
                                      _selectedDate=date0;
date=date0;
                                    });

                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("تاريخ البداية"),
                                  Text(date.toIso8601String().split("T")[0])
                                ],
                              ),
                            );
                          },
                          firstDate: DateTime(2024),
                          focusDate: _selectedDate,
                          lastDate: DateTime(2024, 12, 31),

                          onDateChange: (selectedDate) {
                            setState(() {
                              _selectedDate=selectedDate;
                              startDateController.text=selectedDate.toString();
                              // _focusDate = selectedDate;
                            });
                          },
                          dayProps: const EasyDayProps(
                            width: 64.0,
                            height: 64.0,
                          ),
                          itemBuilder: (
                            BuildContext context,
                            DateTime date,
                            bool isSelected,
                            VoidCallback onTap,
                          ) {
                            return InkResponse(
                              // You can use `InkResponse` to make your widget clickable.
                              // The `onTap` callback responsible for triggering the `onDateChange`
                              // callback and animating to the selected date if the `selectionMode` is
                              // SelectionMode.autoCenter() or SelectionMode.alwaysFirst().
                              onTap: onTap,
                              child: CircleAvatar(
                                // use `isSelected` to specify whether the widget is selected or not.
                                backgroundColor: isSelected
                                    ? primaryColor
                                    : secondaryColor,
                                radius: 32.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(
                                          color:
                                              isSelected ? Colors.white : primaryColor,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        EasyDateFormatter.shortDayName(
                                            date, "ar_ar"),
                                        style: TextStyle(
                                          color:
                                              isSelected ? Colors.white : primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),*/
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("صورة العقد".tr),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            InkWell(
                              onTap: () async {
                                FilePickerResult? _ = await FilePicker.platform
                                    .pickFiles(
                                        type: FileType.image,
                                        allowMultiple: true);
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                      ),
                    ],
                  ),
                  if(widget.parent!=null)
                  CustomTextField(
                      controller: editController, title: 'سبب التعديل'.tr),
                  AppButton(
                    text: 'حفظ'.tr,
                    onPressed: () async {
                      if (_validateFields()) {
                        QuickAlert.show(
                            width: Get.width / 2,
                            context: context,
                            type: QuickAlertType.loading,
                            title: 'جاري التحميل'.tr,
                            text: 'يتم العمل على الطلب'.tr,
                            barrierDismissible: false);
                        await uploadImages(_contractsTemp, "contracts").then(
                          (value) => _contracts.addAll(value),
                        );

                        ParentModel parent = ParentModel(
                          age: ageController.text,
                          nationality: nationalityController.text,
                          contract: _contracts,
                          isAccepted: widget.parent == null
                              ?true:false,
                          parentID:idNumController.text,
                          id: widget.parent == null
                              ? generateId("PARENT")
                              : widget.parent!.id.toString(),
                          fullName: fullNameController.text,
                          address: addressController.text,
                          work: workController.text,
                          emergencyPhone: emergencyPhoneController.text,
                          motherPhone: motherPhoneNumberController.text,
                          phoneNumber: numberController.text,
                          eventRecords: eventRecords,
                          startDate: startDateController.text,
                          children:  widget.parent == null
                              ?null:widget.parent!.children
                        );
                        if (widget.parent != null) {
                       await   addWaitOperation(
                              collectionName: parentsCollection,
                              affectedId: widget.parent!.id.toString(),
                              type: waitingListTypes.edite,
                              newData: parent.toJson(),
                              oldData: widget.parent!.toJson(),details: editController.text);
                        }
                        await Get.find<ParentsViewModel>().addParent(parent);
                        clearController();
                        print('Parent Model: $parent');
                        Get.back();
                        Get.back();
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: defaultPadding * 2),
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
                                    element.role == Const.eventTypeParent,
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
                          controller: bodyEventController,
                          title: 'الوصف'.tr,
                          enable: true,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(width: 16.0),
                        AppButton(
                          text: 'إضافة سجل حدث'.tr,
                          onPressed: () {
                            setState(() {
                              getTime().then((value) {
                                if (value!=null)
                                  {
                                    eventRecords.add(EventRecordModel(
                                      body: bodyEventController.text,
                                      type: selectedEvent!.name,
                                      date: value.dateTime.toString().split(" ")[0],
                                      color: selectedEvent!.color.toString(),
                                    ));
                                    bodyEventController.clear();
                                  }

                              },);

                            });
                          },
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: defaultPadding * 2),
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

  void clearController() {
    fullNameController.clear();
    numberController.clear();
    addressController.clear();
    nationalityController.clear();
    ageController.clear();
    startDateController.clear();
    motherPhoneNumberController.clear();
    bodyEventController.clear();
    emergencyPhoneController.clear();
    workController.clear();
    eventRecords.clear();
    editController.clear();
  }
}
