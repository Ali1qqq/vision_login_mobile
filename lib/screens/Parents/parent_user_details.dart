import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/screens/Parents/Controller/Parents_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Drop_down_with_value.dart';

import '../../constants.dart';
import '../../core/Utiles/service.dart';
import '../event/Controller/event_view_model.dart';

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
  final idNumController = TextEditingController();

  List<EventRecordModel> eventRecords = [];
  EventModel? selectedEvent;
  List<String> _contracts = [];
  List<Uint8List> _contractsTemp = [];

  @override
  void initState() {
    super.initState();
    initParent();
  }

  initParent() {
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
      idNumController.text = widget.parent!.parentID ?? '';
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
                  CustomTextField(controller: fullNameController, title: 'الاسم الكامل'.tr),
                  CustomTextField(
                    controller: idNumController,
                    title: 'رقم الهوية'.tr,
                    isNumeric: true,
                  ),
                  CustomTextField(
                    controller: numberController,
                    title: 'رقم الهاتف'.tr,
                    keyboardType: TextInputType.number,
                    isNumeric: true,
                  ),
                  CustomTextField(controller: addressController, title: 'العنوان'.tr),
                  CustomTextField(controller: nationalityController, title: 'الجنسية'.tr),
                  CustomTextField(
                    controller: ageController,
                    title: 'العمر'.tr,
                    keyboardType: TextInputType.number,
                    isNumeric: true,
                  ),
                  CustomTextField(
                    controller: motherPhoneNumberController,
                    title: 'رقم هاتف الام'.tr,
                    keyboardType: TextInputType.number,
                    isNumeric: true,
                  ),
                  CustomTextField(
                    controller: emergencyPhoneController,
                    title: 'رقم الطوارئ'.tr,
                    keyboardType: TextInputType.number,
                    isNumeric: true,
                  ),
                  CustomTextField(controller: workController, title: 'العمل'.tr),
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
                  buildContractImageSection(),

                  if (widget.parent != null) CustomTextField(controller: editController, title: 'سبب التعديل'.tr),
                  AppButton(
                    text: 'حفظ'.tr,
                    onPressed: (){saveParentData(context);}),
                ],
              ),
            ),
            SizedBox(height: defaultPadding ),
            if (widget.parent != null)
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
                                (element) => element.role == Const.eventTypeParent,
                          )
                              .map((e) => e)
                              .toList(),
                          label: "نوع الحدث".tr,
                          onChange: (selectedWay) {
                            if (selectedWay != null) {
                              setState(() {});
                              selectedEvent = eventController.allEvents[selectedWay];
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
                              getTime().then(
                                    (value) {
                                  if (value != null) {
                                    eventRecords.add(EventRecordModel(
                                      body: bodyEventController.text,
                                      type: selectedEvent!.name,
                                      date: value.dateTime.toString().split(" ")[0],
                                      color: selectedEvent!.color.toString(),
                                    ));
                                    bodyEventController.clear();
                                  }
                                },
                              );
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
                              color: Color(int.parse(record.color)).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
                              child: Row(
                                children: [
                                  Text(
                                    record.type,
                                    style: Styles.headLineStyle1.copyWith(color: Colors.black),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    record.body,
                                    style: Styles.headLineStyle1.copyWith(color: Colors.black),
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


  Widget buildContractImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("صورة العقد".tr),
        SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              buildAddContractButton(),
              ..._contractsTemp.map((contract) => buildContractImage(memoryImage: contract)).toList(),
              ..._contracts.map((contractUrl) => buildContractImage(networkImageUrl: contractUrl)).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAddContractButton() {
    return InkWell(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
        if (result != null) {
          setState(() {
            _contractsTemp.addAll(result.files.map((file) => file.bytes!));
          });
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
    );
  }

  Widget buildContractImage({Uint8List? memoryImage, String? networkImageUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
        width: 200,
        height: 200,
        child: memoryImage != null
            ? Image.memory(memoryImage, height: 200, width: 200, fit: BoxFit.fitHeight)
            : Image.network(networkImageUrl!, height: 200, width: 200, fit: BoxFit.fitHeight),
      ),
    );
  }


  Future<void> saveParentData(BuildContext context) async {
    // تحقق من صحة الحقول
    if (!validateFields(
      requiredControllers: [
        fullNameController,
        numberController,
        addressController,
        nationalityController,
        ageController,
        numberController,
        startDateController,
        motherPhoneNumberController,
        emergencyPhoneController,
        workController,
        idNumController,
      ],
      numericControllers: [
        numberController,
        ageController,
        motherPhoneNumberController,
        idNumController,
      ],
    )) {
      return;
    }

    loadingQuickAlert(context);
    try {
      // تحميل الصور
      List<String> uploadedContracts = await uploadImages(_contractsTemp, "contracts");
      _contracts.addAll(uploadedContracts);

      ParentModel parent = ParentModel(
        age: ageController.text,
        nationality: nationalityController.text,
        contract: _contracts,
        isAccepted: widget.parent == null ? true : false,
        parentID: idNumController.text,
        id: widget.parent == null ? generateId("PARENT") : widget.parent!.id.toString(),
        fullName: fullNameController.text,
        address: addressController.text,
        work: workController.text,
        emergencyPhone: emergencyPhoneController.text,
        motherPhone: motherPhoneNumberController.text,
        phoneNumber: numberController.text,
        eventRecords: eventRecords,
        startDate: startDateController.text,
        children: widget.parent == null ? null : widget.parent!.children,
      );

      // إضافة عملية الانتظار إذا كانت العملية تحديث
      if (widget.parent != null) {
        await addWaitOperation(
          collectionName: parentsCollection,
          affectedId: widget.parent!.id.toString(),
          type: waitingListTypes.edite,
          newData: parent.toJson(),
          oldData: widget.parent!.toJson(),
          details: editController.text,
        );

      }


      await Get.find<ParentsViewModel>().addParent(parent);

      clearController();

      // إخفاء حوارات التحميل والنجاح
      Get.back();

      Get.back();

    } catch (e) {
      print('Error: $e');
      getReedOnlyError(title: "حدث خطأ أثناء حفظ البيانات. حاول مرة أخرى.",context);
      Get.back();
    }
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
