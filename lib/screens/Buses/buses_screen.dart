import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';
import 'package:vision_dashboard/screens/Employee/Controller/Employee_view_model.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';
import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:vision_dashboard/screens/Buses/Buses_Detailes.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/header.dart';
import '../../core/constant/constants.dart';

import '../../controller/Wait_management_view_model.dart';
import '../Student/Controller/Student_View_Model.dart';
import '../Widgets/AppButton.dart';
import '../Widgets/Custom_Pluto_Grid.dart';
import '../Widgets/Custom_Text_Filed.dart';
import '../expenses/Input_Edit_Expenses/expenses_input_form.dart';

class BusesScreen extends StatefulWidget {
  @override
  State<BusesScreen> createState() => _BusesScreenState();
}

class _BusesScreenState extends State<BusesScreen> {
  final TextEditingController subNameController = TextEditingController();
  final TextEditingController subQuantityController = TextEditingController();
  String currentId = '';

  bool getIfDelete() {
    return checkIfPendingDelete(affectedId: currentId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusViewModel>(builder: (controller) {
      return Scaffold(
        appBar: Header(
            context: context,
            title: 'الحافلات'.tr,
            middleText: "تعرض معلومات الحافلات مع امكانية اضافة حافلة جديدة او اضافة مصروف الى حافلة موجودة سابقا".tr),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: GetBuilder<HomeViewModel>(builder: (hcontroller) {
            double size = max(MediaQuery.sizeOf(context).width - (hcontroller.isDrawerOpen ? 240 : 120), 1000) - 60;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SizedBox(
                  height: Get.height - 180,
                  width: size + 60,
                  child: CustomPlutoGrid(
                    controller: controller,
                    idName: "الرقم التسلسلي",
                    onSelected: (event) {
                      controller.selectedColor=Colors.white.withOpacity(0.5);
                      currentId = event.row?.cells["الرقم التسلسلي"]?.value;
                      setState(() {});
                    },
                    onRowDoubleTap: (event) {
                      handleRowDoubleTap(event, controller);
                    },
                  ),
                ),
              ),
            );
          }),
        ),
        floatingActionButton: buildFloatingActionButton(controller),
      );
    });
  }

  void handleRowDoubleTap(event, BusViewModel controller) {
    final cellTitle = event.cell.column.title;
    final cellValue = event.row.cells["الرقم التسلسلي"]?.value;

    if (cellTitle == 'عدد الطلاب') {
      showDialog(
        context: context,
        builder: (context) => buildStudentDialog(controller.busesMap[cellValue]?.students ?? []),
      );
    } else if (cellTitle == 'عدد الموظفين') {
      showDialog(
        context: context,
        builder: (context) => buildEmployeeDialog(controller.busesMap[cellValue]?.employees ?? []),
      );
    } else if (cellTitle == 'المصروف') {
      showDialog(
        context: context,
        builder: (context) => buildExpensesDialog(controller.busesMap[cellValue]?.expense ?? []),
      );
    }
  }

  Widget buildFloatingActionButton(BusViewModel controller) {
    return GetBuilder<WaitManagementViewModel>(
      builder: (_) {
        return enableUpdate && currentId != '' && controller.busesMap[currentId]!.isAccepted!
            ? SizedBox(
          width: Get.width,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              /// زر الحذف او الاسترجاع
              buildDeleteButton(_,controller),
              ///اذا لم يكون العنصر في قائمة الانتظار
              if (!getIfDelete()) ...[
                SizedBox(width: defaultPadding),
                /// اضافة مصروف للحافلة
                buildAddExpenseButton(controller),
                SizedBox(width: defaultPadding),
                /// تعديل الحافلة
                buildEditBusButton(controller),
              ],
            ],
          ),
        )
            : Container();
      },
    );
  }

  FloatingActionButton buildDeleteButton(WaitManagementViewModel _,controller) {
    return FloatingActionButton(
      backgroundColor: getIfDelete() ? Colors.greenAccent.withOpacity(0.5) : Colors.red.withOpacity(0.5),
      onPressed: () {
        if (getIfDelete()) {
          _.returnDeleteOperation(affectedId: controller.busesMap[currentId]!.busId.toString());
        } else {
          showDeleteConfirmationDialog(controller);
        }
      },
      child: Icon(getIfDelete() ? Icons.restore_from_trash_outlined : Icons.delete, color: Colors.white),
    );
  }

  void showDeleteConfirmationDialog(controller) {
    TextEditingController editController = TextEditingController();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      widget: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(controller: editController, title: "سبب الحذف".tr, size: Get.width / 4),
        ),
      ),
      text: 'قبول هذه العملية'.tr,
      title: 'هل انت متأكد ؟'.tr,
      onConfirmBtnTap: () async {

        await addWaitOperation(
            type: waitingListTypes.delete,
            details: editController.text,
            collectionName: busesCollection,
            userName: currentEmployee?.userName.toString()??"",

            affectedId: controller.busesMap[currentId]!.busId.toString());


        Get.back();
      },
      onCancelBtnTap: () => Get.back(),
      confirmBtnText: 'نعم'.tr,
      cancelBtnText: 'لا'.tr,
      confirmBtnColor: Colors.redAccent,
      showCancelBtn: true,
    );
  }

  FloatingActionButton buildAddExpenseButton(controller) {
    return FloatingActionButton(
      backgroundColor: primaryColor.withOpacity(0.5),
      onPressed: () {
        Get.find<ExpensesViewModel>().busId= controller.busesMap[currentId]!.busId!;
        showExpensesInputDialog(context);
      },
      child: Icon(Icons.add_chart_outlined, color: Colors.white),
    );
  }

  FloatingActionButton buildEditBusButton(controller) {
    return FloatingActionButton(
      backgroundColor: primaryColor.withOpacity(0.5),
      onPressed: () {

        showBusInputDialog(context, controller.busesMap[currentId]!);
      },
      child: Icon(Icons.edit, color: Colors.white),
    );
  }

  void showExpensesInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
            height: Get.height / 2,
            width: Get.width / 1.5,
            child: ExpensesInputForm(),
          ),
        );
      },
    );
  }



  AlertDialog buildExpensesDialog(List<String> expenses) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      actions: [
        buildListDialog(
          title: "العنوان: ",
          items: expenses,
          itemBuilder: (context, index) {
            final expense = Get.find<ExpensesViewModel>().allExpenses[expenses[index]];
            return "${expense?.title ?? ''}, القيمة: ${expense?.total ?? ''}";
          },
        ),
      ],
    );
  }

  Widget buildEmployeeDialog(List<String> employees) {
    return buildListDialog(
      title: "الاسم الكامل: ",
      items: employees,
      itemBuilder: (context, index) => Get.find<EmployeeViewModel>()
          .allAccountManagement[employees[index]]
          ?.fullName ??
          'N/A',
    );
  }

  Widget buildStudentDialog(List<String> students) {
    return buildListDialog(
      title: "الاسم الكامل: ",
      items: students,
      itemBuilder: (context, index) => Get.find<StudentViewModel>()
          .studentMap[students[index]]
          ?.studentName ??
          'N/A',
    );
  }

  Widget buildListDialog({
    required String title,
    required List<String> items,
    required String Function(BuildContext, int) itemBuilder,
  }) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Container(
        width: Get.width / 3,
        height: min(items.length * 100.0, Get.height / 3.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppStyles.headLineStyle3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            itemBuilder(context, index),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.headLineStyle2.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            AppButton(text: "تم", onPressed: () => Get.back())

          ],
        ),
      ),
    );
  }
  void showBusInputDialog(BuildContext context, dynamic bus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
            height: Get.height / 2,
            width: Get.width / 1.5,
            child: BusInputForm(busModel: bus),
          ),
        );
      },
    );
  }
}