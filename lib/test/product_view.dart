
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/controller/expenses_view_model.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import '../utils/const.dart';

class AllExp extends StatefulWidget {
  const AllExp({super.key});

  @override
  State<AllExp> createState() => _AllExpState();
}

class _AllExpState extends State<AllExp> {
/*  @override
  Widget build(BuildContext context) {
    ExpensesViewModel expensesModel = Get.find<ExpensesViewModel>();
    // RxMap<String, ProductModel> data = Map.fromEntries(productViewModel.productDataMap.entries.where((element) => !element.value.prodIsGroup!).toList()).obs;
    RxMap<String, ExpensesModel> data = expensesModel.allExpenses;
    print(data.values.toList());
    return GetBuilder<ExpensesViewModel>(
      builder: (context) {
        GlobalKey _key = GlobalKey();
        return Scaffold(
          backgroundColor: Colors.white,

          body: GetBuilder<DeleteManagementViewModel>(
            builder: (_) {
              return FilteringDataGrid<ExpensesModel>(
                key: _key,
                title: "مواد",
                constructor: ExpensesModel(),
                dataGridSource:data,
                onCellTap: (index,id,row,init) {
                  print(index);
                  print(row);

                  addDeleteOperation(collectionName: Const.expensesCollection, affectedId: id);
                setState(() {

                });
                },
                init: ()async {
                  RxMap<String, ExpensesModel> data = expensesModel.allExpenses;
                  print(data.length);
                  List<DataGridRow> dataGridRow  = data.values
                      .map<DataGridRow>((order) => DataGridRow(cells: [
                    DataGridCell(columnName: order.affectedKey()!, value: order.affectedId()),
                    ...order
                        .toAR()
                        .entries
                        .map((mapEntry) {
                      return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());
                    }).cast<DataGridCell<dynamic>>().toList()
                  ])).toList();
                  InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
                  print(dataGridRow);
                  infoDataGridSource.dataGridRows =dataGridRow;
                  return infoDataGridSource;

                },
              );
            }
          ),
        );
      }
    );
  }*/

  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "العنوان": PlutoColumnType.text(),
    "المبلغ": PlutoColumnType.currency(),
    "اسم الموظف": PlutoColumnType.text(),
    "الوصف": PlutoColumnType.text(),
    "الفواتير المدخلة": PlutoColumnType.number(),
    "تاريخ": PlutoColumnType.date(),
  };



  late final PlutoGridStateManager stateManager;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // columns.addAll(ExpensesModel().toAR(data));
/*    eController.allExpenses.entries.forEach(
      (element) {
        rows.add(
          PlutoRow(
            cells: {
              data.keys.elementAt(0): PlutoCell(value: element.value.id),
              data.keys.elementAt(1): PlutoCell(value: element.value.title),
              data.keys.elementAt(2): PlutoCell(value: element.value.total),
              data.keys.elementAt(3): PlutoCell(value:uController.allAccountManagement[element.value.userId]?.fullName??'' ),
              data.keys.elementAt(4): PlutoCell(value: element.value.body),
              data.keys.elementAt(5): PlutoCell(value: element.value.images?.length??0),
              data.keys.elementAt(6): PlutoCell(value: element.value.date),
            },
          ),
        );
      },
    );*/
  }

  String currentId='';


  bool getIfDelete(){
    return checkIfPendingDelete(
        affectedId:currentId);
  }
/*
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];*/

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesViewModel>(builder: (controller) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<ExpensesViewModel>(builder: (controller) {
                return Container(
                  padding: const EdgeInsets.all(15),
              /*    child: CustomPlutoGrid(controller, (event) {
                    currentId=event.row?.cells["الرقم التسلسلي"]?.value;
                    setState(() {

                    });
                  },stateManager,"الرقم التسلسلي")*/
                );
              }),
            ),
            AppButton(
                text: "ref",
                onPressed: () {

                })
          ],
        ),
        floatingActionButton:
            enableUpdate && currentId != ''
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetBuilder<WaitManagementViewModel>(
                        builder: (_) {
                          return FloatingActionButton(
                            backgroundColor:getIfDelete()? Colors.greenAccent.withOpacity(0.5):Colors.red.withOpacity(0.5),
                            onPressed: () {

                              if (enableUpdate) {
                                if (getIfDelete())
                                  _.returnDeleteOperation(
                                      affectedId:controller.allExpenses[currentId]!.id.toString());
                                else if (controller.allExpenses[currentId]!.busId != null) {
                                  addWaitOperation(
                                      type: waitingListTypes.delete,

                                      collectionName:
                                      Const.expensesCollection,
                                      affectedId: controller.allExpenses[currentId]!.id!,
                                      relatedId: controller.allExpenses[currentId]!.busId!);
                                } else {
                                  addWaitOperation(
                                      type: waitingListTypes.delete,

                                      collectionName:
                                      Const.expensesCollection,
                                      affectedId: controller.allExpenses[currentId]!.id!);
                                }
                              }
                            },
                            child: Icon(getIfDelete()
                                ? Icons.restore_from_trash_outlined
                                : Icons.delete,color: Colors.white,),
                          );
                        }
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      FloatingActionButton(
                        backgroundColor: primaryColor,
                        onPressed: () {
                          setState(() {});
                        },
                        child: Icon(Icons.edit,color: Colors.white,),
                      ),
                    ],
                  )
                : Container(),
      );
    });
  }


}
