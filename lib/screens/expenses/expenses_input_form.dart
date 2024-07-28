import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/controller/expenses_view_model.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/expenses_model.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/utils/Dialogs.dart';
import 'package:vision_dashboard/utils/const.dart';

import '../../constants.dart';
import '../../utils/Hive_DataBase.dart';
import '../Widgets/Custom_Text_Filed.dart';

class ExpensesInputForm extends StatefulWidget {
  const ExpensesInputForm({super.key, this.busId, this.expensesModel});

  @override
  _ExpensesInputFormState createState() => _ExpensesInputFormState();

  final String? busId;
  final ExpensesModel? expensesModel;
}

class _ExpensesInputFormState extends State<ExpensesInputForm> {
  final titleController = TextEditingController();
  final totalController = TextEditingController();
  final bodyController = TextEditingController();
  final dateController = TextEditingController();
  List imageLinkList = [];
  List<Uint8List> ImagesTempData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateController.text = thisTimesModel!.dateTime.toString().split(" ")[0];
    initController();
  }

  Map<bool, String> validateInputs() {
    // تحقق من أن جميع المت Controllers ليست فارغة
    if (titleController.text.isEmpty) {
      return {false: "يرجى إدخال عنوان.".tr};
    }
    if (!isNumeric(totalController.text)) {
      return {false: "يرجى إدخال المبلغ.".tr};
    }

    if (dateController.text.isEmpty) {
      return {false: "يرجى إدخال التاريخ.".tr};
    }

    return {true: ""};
  }

  initController() {
    print(widget.expensesModel?.toJson());
    if (widget.expensesModel != null) {
      titleController.text = widget.expensesModel!.title.toString();
      totalController.text = widget.expensesModel!.total.toString();
      bodyController.text = widget.expensesModel!.body.toString();
      dateController.text = widget.expensesModel!.date.toString();
      imageLinkList.addAll(widget.expensesModel!.images ?? []);
    }
  }

  clearController() {
    titleController.clear();
    totalController.clear();
    bodyController.clear();
    dateController.clear();
    imageLinkList = [];
    ImagesTempData = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesViewModel>(builder: (controller) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Wrap(
            clipBehavior: Clip.hardEdge,
            direction: Axis.horizontal,
            runSpacing: 25,
            spacing: 25,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(controller: titleController, title: 'العنوان'.tr),
              CustomTextField(controller: totalController, title: 'القيمة'.tr),
              InkWell(
                onTap: () {
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
                  title: 'التاريخ'.tr,
                  enable: false,
                  keyboardType: TextInputType.datetime,
                  icon: Icon(
                    Icons.date_range_outlined,
                    color: primaryColor,
                  ),
                ),
              ),
              multiLineCustomTextField(
                  controller: bodyController, title: 'تاريخ البداية'.tr),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("صورة الفاتورة".tr),
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
                                    type: FileType.image, allowMultiple: true);
                            if (_ != null) {
                              _.files.forEach(
                                (element) async {
                                  ImagesTempData.add(element.bytes!);
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
                          ImagesTempData.length,
                          (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                  width: 200,
                                  height: 200,
                                  child: Image.memory(
                                    (ImagesTempData[index]),
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.fitHeight,
                                  )),
                            );
                          },
                        ),
                        ...List.generate(
                          imageLinkList.length,
                          (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                  width: 200,
                                  height: 200,
                                  child: Image.network(
                                    imageLinkList[index],
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
              AppButton(
                text: "حفظ".tr,
                onPressed: () async {
                  if (validateInputs().keys.first) {
                    QuickAlert.show(
                        width: Get.width / 2,
                        context: context,
                        type: QuickAlertType.loading,
                        title: 'جاري التحميل'.tr,
                        text: 'يتم العمل على الطلب'.tr,
                        barrierDismissible: false);
                    await uploadImages(ImagesTempData, "expenses").then(
                      (value) => imageLinkList.addAll(value),
                    );
                    String expId = widget.expensesModel == null
                        ? generateId("ExP")
                        : widget.expensesModel!.id!;
                    BusViewModel busController = Get.find<BusViewModel>();
                    ExpensesModel model = ExpensesModel(
                      date: dateController.text,
                      isAccepted: widget.expensesModel == null ? true : false,
                      id: expId,
                      busId: widget.busId,
                      title: titleController.text,
                      body: widget.busId != null
                          ? "مصروف الحافلة ${busController.busesMap[widget.busId]!.name}\n ${bodyController.text}"
                          : bodyController.text,
                      total: int.parse(totalController.text),
                      userId: HiveDataBase.getAccountManagementModel()!.id,
                      images: imageLinkList,
                    );

                    await controller.addExpenses(model);
                    if (widget.expensesModel != null)
                      addWaitOperation(
                          collectionName: Const.expensesCollection,
                          oldData: widget.expensesModel!.toJson(),
                          newData:model.toJson() ,
                          affectedId: expId,
                          type: waitingListTypes.edite);
                    if (widget.busId != null)
                      await busController.addExpenses(widget.busId!, expId);
                    clearController();

                    if (widget.busId != null || widget.expensesModel != null)
                      Get.back();
                    Get.back();
                  } else {
                    QuickAlert.show(
                        width: Get.width / 2,
                        context: context,
                        type: QuickAlertType.error,
                        title: 'خطأ'.tr,
                        text: "${validateInputs().values.first}",
                        barrierDismissible: false);
                  }
                },
              )
            ],
          ),
        ),
      );
    });
  }
}

class multiLineCustomTextField extends StatelessWidget {
  const multiLineCustomTextField({
    super.key,
    required this.controller,
    required this.title,
  });

  final TextEditingController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 1,
      height: 200,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white12,
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الوصف'.tr, style: TextStyle(color: primaryColor)),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                controller: controller,
                maxLines: null,
                decoration: InputDecoration(
                    //labelText: title,
                    labelStyle: TextStyle(color: primaryColor),
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
