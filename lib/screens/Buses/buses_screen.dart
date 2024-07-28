import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';
import 'package:vision_dashboard/controller/expenses_view_model.dart';
import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:vision_dashboard/screens/Buses/Buses_Detailes.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';
import 'package:vision_dashboard/screens/Widgets/header.dart';
import 'package:vision_dashboard/screens/expenses/expenses_input_form.dart';
import '../../constants.dart';

import '../../controller/Wait_management_view_model.dart';
import '../Student/Controller/Student_View_Model.dart';
import '../Widgets/AppButton.dart';
import '../Widgets/Custom_Pluto_Grid.dart';
import '../Widgets/Custom_Text_Filed.dart';

class BusesScreen extends StatefulWidget {
  @override
  State<BusesScreen> createState() => _BusesScreenState();
}

class _BusesScreenState extends State<BusesScreen> {
/*  List data = [
    "رقم الحافلة",
    "اسم الحافلة",
    "النوع",
    "عدد الطلاب",
    "عدد الموظفين",
    "المصروف",
    "تاريخ البداية",
    "الخيارات",
    ""
  ];
  List filterData = [
    "رقم الحافلة",
    "اسم الحافلة",
    "النوع",
  ];*/
  // TextEditingController searchController = TextEditingController();
  // String searchValue = '';
  // int searchIndex = 0;
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
            middleText:
                "تعرض معلومات الحافلات مع امكانية اضافة حافلة جديدة او اضافة مصروف الى حافلة موجودة سابقا"
                    .tr),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: GetBuilder<HomeViewModel>(builder: (hcontroller) {
            double size = max(
                    MediaQuery.sizeOf(context).width -
                        (hcontroller.isDrawerOpen ? 240 : 120),
                    1000) -
                60;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SizedBox(
                  height: Get.height-120,
                  width: size + 60,
                  child: CustomPlutoGrid(
                    controller: controller,
                    idName: "الرقم التسلسلي",
                    onSelected: (event) {
                      currentId = event.row?.cells["الرقم التسلسلي"]?.value;
                      setState(() {});
                    },
                    onRowDoubleTap: (event) {
                      if (event.cell.column.title == 'عدد الطلاب')
                        showDialog(
                          context: context,
                          builder: (context) => buildStudentDialog(controller
                                  .busesMap[
                                      event.row.cells["الرقم التسلسلي"]?.value]
                                  ?.students ??
                              []),
                        );
                      if (event.cell.column.title == 'عدد الموظفين')
                        showDialog(
                          context: context,
                          builder: (context) => buildEmployeeDialog(controller
                              .busesMap[
                          event.row.cells["الرقم التسلسلي"]?.value]
                              ?.employees ??
                              []),
                        );
                      if (event.cell.column.title == 'المصروف')
                        showDialog(
                          context: context,
                          builder: (context) => buildExpensesDialog(controller
                              .busesMap[
                          event.row.cells["الرقم التسلسلي"]?.value]
                              ?.expense ??
                              []),
                        );
                      print(event.cell.column.title);
                      print(event.rowIdx);
                    },
                  ),
                ),
              ),
            );
          }),
        ),
        floatingActionButton: GetBuilder<WaitManagementViewModel>(
          builder: (_) {
            return enableUpdate && currentId != ''&&controller
                .busesMap[currentId]!.isAccepted!
                ? SizedBox(
              width: Get.width,
              child: Wrap(
                // mainAxisAlignment: MainAxisAlignment.center,
                alignment: WrapAlignment.center,
                      children: [
                        FloatingActionButton(
                          backgroundColor: getIfDelete()
                              ? Colors.greenAccent.withOpacity(0.5)
                              : Colors.red.withOpacity(0.5),
                          onPressed: () {
                            if(    getIfDelete())

                                _.returnDeleteOperation(
                                    affectedId: controller
                                        .busesMap[currentId]!.busId
                                        .toString());
                                else

                            {
                              TextEditingController editController =
                              TextEditingController();

                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                widget:Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomTextField(controller: editController, title: "سبب الحذف".tr,size: Get.width/4,),
                                  ),
                                ),
                                text: 'قبول هذه العملية'.tr,
                                title: 'هل انت متأكد ؟'.tr,
                                onConfirmBtnTap: () async {
                                  addWaitOperation(
                                      type: waitingListTypes.delete
                                      ,details: editController.text,
                                      collectionName: busesCollection,
                                      affectedId: controller
                                          .busesMap[currentId]!.busId
                                          .toString());
                                  Get.back();
                                },
                                onCancelBtnTap: () => Get.back(),
                                confirmBtnText: 'نعم'.tr,
                                cancelBtnText: 'لا'.tr,
                                confirmBtnColor: Colors.redAccent,
                                showCancelBtn: true,
                              );
                            }

                          },
                          child: Icon(
                            getIfDelete()
                                ? Icons.restore_from_trash_outlined
                                : Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding,
                        ),
                        if(!getIfDelete())
                        FloatingActionButton(
                          backgroundColor: primaryColor.withOpacity(0.5),
                          onPressed: () {
                            showExpensesInputDialog(
                                context, controller.busesMap[currentId]!.busId!);
                          },
                          child: Icon(
                            Icons.add_chart_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding,
                        ),
                        if(!getIfDelete())
                        FloatingActionButton(
                          backgroundColor: primaryColor.withOpacity(0.5),
                          onPressed: () {
                            showBusInputDialog(
                                context, controller.busesMap[currentId]!);
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                )
                : Container();
          }
        ),
      );
    });
  }

  void showExpensesInputDialog(BuildContext context, String busId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
            ),
            height: Get.height / 2,
            width: Get.width / 1.5,
            child: ExpensesInputForm(busId: busId),
          ),
        );
      },
    );
  }

  AlertDialog buildStudentDialog(List<String> student) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      actions: [
        Container(
          width: Get.width / 3,
          height: min(student.length*70,Get.height / 3.5),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [
Spacer(),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: student.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: Text("الاسم الكامل: ",style: Styles.headLineStyle3.copyWith(),)),
                      SizedBox(width: 5,),
                      Flexible(
                        child: Text(

                          Get.find<StudentViewModel>()
                                  .studentMap[student[index]]
                                  ?.studentName
                                  .toString() ??
                              'sd',
                          maxLines: 1,
                          style: Styles.headLineStyle2,
                        ),
                      ),

                    ],
                  );
                },
              ),
              Spacer(),
              AppButton(
                text: "تم",
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
        )
      ],
    );
  }

  AlertDialog buildExpensesDialog(List<String> expenses) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      actions: [
        Column(
          children: [
            Container(
              width: Get.width / 2.5,
              height: Get.height / 3.5,
              child: ListView.builder(
                padding: EdgeInsets.all(15),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: (Get.width / 2) / 2.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text("العنوان: ", style: Styles.headLineStyle3),
                            Spacer(),
                            Text(
                              Get.find<ExpensesViewModel>()
                                  .allExpenses[expenses[index]]?.title.toString()??'',
                              style: Styles.headLineStyle2,
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: (Get.width / 2) / 3.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "القيمة: ",
                              style: Styles.headLineStyle3,
                            ),
                            Spacer(),
                            Text(
                              Get.find<ExpensesViewModel>()
                                  .allExpenses[expenses[index]]?.total.toString()??'',
                              style: Styles.headLineStyle2,
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            AppButton(
              text: "تم",
              onPressed: () {
                Get.back();
              },
            )
          ],
        )
      ],
    );
  }

  AlertDialog buildEmployeeDialog(List<String> employee) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      actions: [
        Container(
          width: Get.width / 3,
          height: min(employee.length*60,Get.height / 3.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              ListView.builder(
                itemCount: employee.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Text("الاسم الكامل: ",style: Styles.headLineStyle3.copyWith(),),
                      SizedBox(width: 5,),
                      Text(
                        Get.find<AccountManagementViewModel>()
                                .allAccountManagement[employee[index]]
                                ?.fullName
                                .toString() ??
                            'null',
                        maxLines: 1,
                        style: Styles.headLineStyle2,
                      ),

                    ],
                  );
                },
              ),
         Spacer(),
              AppButton(
                text: "تم",
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
        )
      ],
    );
  }

  void showBusInputDialog(BuildContext context, dynamic bus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
            ),
            height: Get.height / 2,
            width: Get.width / 1.5,
            child: BusInputForm(busModel: bus),
          ),
        );
      },
    );
  }

/*   child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 25,
                    children: [
                      CustomTextField(
                        size: Get.width / 6,
                        controller: searchController,
                        title: "ابحث",
                        onChange: (value) {
                          setState(() {});
                        },
                      ),
                      CustomDropDown(
                        size: Get.width / 6,
                        value: searchValue,
                        listValue: filterData
                            .map(
                              (e) => e.toString(),
                            )
                            .toList(),
                        label: "اختر فلتر البحث",
                        onChange: (value) {
                          searchValue = value ?? '';
                          searchIndex = filterData.indexOf(searchValue);
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: primaryColor.withOpacity(0.2),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GetBuilder<BusViewModel>(builder: (controller) {
                    return SizedBox(
                      width: size + 60,
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: GetBuilder<DeleteManagementViewModel>(
                              builder: (_) {
                            return DataTable(
                                columnSpacing: 0,
                                dividerThickness: 0.3,
                                columns: List.generate(
                                    data.length,
                                    (index) => DataColumn(
                                        label: Container(
                                            width: size / (data.length),
                                            child: Center(
                                                child: Text(data[index]
                                                    .toString()
                                                    .tr))))),
                                rows: [
                                  ...List.generate(
                                    controller.busesMap.values.where(
                                      (element) {
                                        if (searchController.text == '')
                                          return true;
                                        else
                                          switch (searchIndex) {
                                            case 0:
                                              return element.number!.contains(
                                                  searchController.text);
                                            case 1:
                                              return element.name!.contains(
                                                  searchController.text);
                                            case 2:
                                              return element.type!.contains(
                                                  searchController.text);

                                            default:
                                              return false;
                                          }
                                      },
                                    ).length,
                                    (index) {
                                      int expenses = 0;
                                      BusModel busModel =
                                          controller.busesMap.values.where(
                                        (element) {
                                          if (searchController.text == '')
                                            return true;
                                          else
                                            switch (searchIndex) {
                                              case 0:
                                                return element.number!.contains(
                                                    searchController.text);
                                              case 1:
                                                return element.name!.contains(
                                                    searchController.text);
                                              case 2:
                                                return element.type!.contains(
                                                    searchController.text);

                                              default:
                                                return false;
                                            }
                                        },
                                      ).elementAt(index);
                                      for (var ex in busModel.expense ?? []) {
                                        expenses +=
                                            Get.find<ExpensesViewModel>()
                                                .allExpenses[ex]!
                                                .total??0;
                                      }
                                      return DataRow(
                                          color: WidgetStatePropertyAll(
                                              checkIfPendingDelete(
                                                      affectedId:
                                                          busModel.busId!)
                                                  ? Colors.redAccent
                                                      .withOpacity(0.2)
                                                  : Colors.transparent),
                                          cells: [
                                            dataRowItem(size / (data.length),
                                                busModel.number.toString()),
                                            dataRowItem(size / (data.length),
                                                busModel.name.toString()),
                                            dataRowItem(size / (data.length),
                                                busModel.type.toString()),
                                            dataRowItem(
                                                size / (data.length),
                                                busModel.students!.length
                                                    .toString(), onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (builder) =>
                                                      buildStudentDialog(
                                                          busModel.students!));
                                            }),
                                            dataRowItem(
                                                size / (data.length),
                                                busModel.employees!.length
                                                    .toString(), onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (builder) =>
                                                      buildEmployeeDialog(
                                                          busModel.employees!));
                                            }),
                                            DataCell(
                                                GetBuilder<ExpensesViewModel>(
                                                    builder:
                                                        (expensesController) {
                                              return Container(
                                                width: size / (data.length),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          List<ExpensesModel>
                                                              expenses = [];
                                                          for (var expen
                                                              in busModel
                                                                      .expense ??
                                                                  []) {
                                                            expenses.add(
                                                                expensesController
                                                                        .allExpenses[
                                                                    expen]!);
                                                          }
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                buildExpensesDialog(
                                                                    expenses),
                                                          );
                                                        },
                                                        child: Text(expenses
                                                            .toString())),
                                                    IconButton(
                                                        onPressed: () {
                                                          showExpensesInputDialog(
                                                              context,
                                                              busModel.busId!);
                                                        },
                                                        icon: Icon(
                                                          Icons.add,
                                                          color: blueColor,
                                                        ))
                                                  ],
                                                ),
                                              );
                                            })),
                                            dataRowItem(
                                              size / (data.length),
                                              busModel.startDate
                                                  .toString()
                                                  .split(" ")[0],
                                            ),
                                            dataRowItem(size / (data.length),
                                                "تعديل".tr, color: Colors.green,
                                                onTap: () {
                                              showBusnputDialog(
                                                  context, busModel);
                                            }),
                                            DataCell(Container(
                                                width: size / (data.length),
                                                child: IconButton(
                                                    onPressed: () {
                                                      checkIfPendingDelete(
                                                              affectedId:
                                                                  busModel
                                                                      .busId!)
                                                          ? _.returnDeleteOperation(
                                                              affectedId:
                                                                  busModel
                                                                      .busId!)
                                                          : addDeleteOperation(
                                                              collectionName:
                                                                  busesCollection,
                                                              affectedId:
                                                                  busModel
                                                                      .busId!);
                                                    },
                                                    icon: Row(
                                                      children: [
                                                        Spacer(),
                                                        Icon(
                                                          checkIfPendingDelete(
                                                                  affectedId:
                                                                      busModel
                                                                          .busId!)
                                                              ? Icons.check
                                                              : Icons.delete,
                                                          color: checkIfPendingDelete(
                                                                  affectedId:
                                                                      busModel
                                                                          .busId!)
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(checkIfPendingDelete(
                                                                affectedId:
                                                                    busModel
                                                                        .busId!)
                                                            ? "استرجاع".tr
                                                            : "حذف".tr),
                                                        Spacer(),
                                                      ],
                                                    ))))
                                          ]);
                                    },
                                  )
                                ]);
                          }),
                        ),
                      ),
                    );
                  }),
                ],
              ),*/
}
