import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';
import '../../../core/constant/constants.dart';
import '../../../controller/home_controller.dart';
import '../../Widgets/Custom_Pluto_Grid.dart';
import '../../Widgets/header.dart';
import 'Widgets/FloatingActionButton.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesViewModel>(builder: (controller) {
      return Scaffold(
        appBar: Header(context: context, title: 'المصاريف'.tr, middleText: "تعرض هذه الواجهة معلومات عن مصاريف هذه السنة مع امكانية اضافة مصروف جديد \n ملاحظة : مصاريف الحافلات تتم اضافتها من واجهة الحافلات".tr),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: GetBuilder<HomeViewModel>(builder: (homeController) {
            double size = max(Get.width - (homeController.isDrawerOpen ? 240 : 120), 1000) - 60;
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
                      controller.setCurrentId(event.row?.cells["الرقم التسلسلي"]?.value);
                    },
                  ),
                ),
              ),
            );
          }),
        ),

        floatingActionButton: buildFloatingActionButton(context,controller),
      );
    });
  }
}

/*     floatingActionButton: enableUpdate && currentId != '' && controller.allExpenses[currentId]!.isAccepted! && !getIfDelete()
            ? SizedBox(
                width: Get.width,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    GetBuilder<WaitManagementViewModel>(builder: (_) {
                      return FloatingActionButton(
                        backgroundColor: getIfDelete() ? Colors.greenAccent.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                        onPressed: () {
                          if (enableUpdate) {
                            if (getIfDelete())
                              _.returnDeleteOperation(affectedId: controller.allExpenses[currentId]!.id.toString());
                            else {
                              TextEditingController editController = TextEditingController();

                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                widget: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomTextField(
                                      controller: editController,
                                      title: "سبب الحذف".tr,
                                      size: Get.width / 4,
                                    ),
                                  ),
                                ),
                                text: 'قبول هذه العملية'.tr,
                                title: 'هل انت متأكد ؟'.tr,
                                onConfirmBtnTap: () async {
                                  if (controller.allExpenses[currentId]!.busId != null) {
                                    addWaitOperation(type: waitingListTypes.delete, details: editController.text, collectionName: Const.expensesCollection, affectedId: controller.allExpenses[currentId]!.id!, relatedId: controller.allExpenses[currentId]!.busId!);
                                  } else {
                                    addWaitOperation(type: waitingListTypes.delete, details: editController.text, collectionName: Const.expensesCollection, affectedId: controller.allExpenses[currentId]!.id!);
                                  }
                                  Get.back();
                                },
                                onCancelBtnTap: () => Get.back(),
                                confirmBtnText: 'نعم'.tr,
                                cancelBtnText: 'لا'.tr,
                                confirmBtnColor: Colors.redAccent,
                                showCancelBtn: true,
                              );
                            }
                          }
                        },
                        child: Icon(
                          getIfDelete() ? Icons.restore_from_trash_outlined : Icons.delete,
                          color: Colors.white,
                        ),
                      );
                    }),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    FloatingActionButton(
                      backgroundColor: primaryColor.withOpacity(0.5),
                      onPressed: () {
                        showParentInputDialog(context, controller.allExpenses[currentId]!);
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : Container(),*/

/*
Column(
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
searchIndex=filterData.indexOf(searchValue);

},
)
],
),
SizedBox(height: 5,),
Divider(color: primaryColor.withOpacity(0.2),),
SizedBox(height: 5,),

GetBuilder<ExpensesViewModel>(builder: (controller) {
return SizedBox(
width: size + 60,
child: Scrollbar(
controller: _scrollController,
child: SingleChildScrollView(
controller: _scrollController,
scrollDirection: Axis.horizontal,
child:
GetBuilder<DeleteManagementViewModel>(builder: (_) {
return DataTable(
columnSpacing: 0,
dividerThickness: 0.3,
columns: List.generate(
data.length,
(index) => DataColumn(
label: Container(
width: size / data.length,
child: Center(
child: Text(
data[index].toString().tr))))),
rows: [
for (var expense in controller.allExpenses.values.where((element) {

if (searchController.text == '')
return true;
else switch(searchIndex){
case 0:
return  element.title!
    .contains(searchController.text);
case 1:
return  element.userId!
    .contains(searchController.text);
case 2:
return  element.date!
    .contains(searchController.text);


default:
return false;
}
},))
DataRow(
color: WidgetStatePropertyAll(
checkIfPendingDelete(
affectedId: expense.id!)
? Colors.redAccent.withOpacity(0.2)
    : Colors.transparent),
cells: [
dataRowItem(size / data.length,
expense.id.toString()),
dataRowItem(size / data.length,
expense.title.toString()),
dataRowItem(size / data.length,
expense.total.toString()),
dataRowItem(size / data.length,
expense.userId.toString()),
dataRowItem(size / data.length,
expense.body.toString(), onTap: () {
Get.defaultDialog(
backgroundColor: Colors.white,
title: "التفاصيل".tr,
content: SizedBox(
width: Get.height / 2,

child: Center(
child: Text(
expense.body.toString(),
style: TextStyle(
fontSize: 20,
color: blueColor),
),
)));
}),
*/
/*            dataRowItem(
                                              size / data.length, "عرض التفاصيل".tr,
                                              color: Colors.teal),*/ /*

dataRowItem(size / data.length,
expense.images!.length.toString(),
onTap: () {
Get.defaultDialog(
backgroundColor: Colors.white,
title: "الصور".tr,
content: Container(
color: Colors.white,
width: Get.height / 1.5,
height: Get.height / 1.5,
child: PageView.builder(
itemCount:
expense.images!.length,
scrollDirection:
Axis.horizontal,
itemBuilder:
(context, index) {
return SizedBox(
width: Get.height / 1.5,
child: Image.network(
expense.images![index],
fit: BoxFit.fitWidth,
));
},
)));
}),
dataRowItem(
size / data.length, expense.date,
color: Colors.teal),
dataRowItem(
size / data.length,
checkIfPendingDelete(
affectedId: expense.id!)
? "استرجاع".tr
    : "حذف".tr,
color: checkIfPendingDelete(
affectedId: expense.id!)
? Colors.white
    : Colors.red, onTap: () {
if (enableUpdate) {
if (checkIfPendingDelete(
affectedId: expense.id!))
_.returnDeleteOperation(
affectedId: expense.id!);
else if (expense.busId != null) {
addDeleteOperation(
collectionName:
Const.expensesCollection,
affectedId: expense.id!,
relatedId: expense.busId!);
} else {
addDeleteOperation(
collectionName:
Const.expensesCollection,
affectedId: expense.id!);
}
}
}),
]),
]);
}),
),
),
);
}),
],
)*/
