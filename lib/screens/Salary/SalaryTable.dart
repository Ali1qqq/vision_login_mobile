import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../constants.dart';
import '../../../controller/account_management_view_model.dart';
import '../../../controller/Wait_management_view_model.dart';
import '../../../models/account_management_model.dart';
import '../../../models/Salary_Model.dart';
import '../Widgets/Data_Row.dart';
import 'SignViewDialog.dart';
import 'controller/Salary_View_Model.dart';

enum TableType { Payable, Received }

class SalaryTable extends StatelessWidget {
  final double size;
  final String selectedMonth;
  final TableType type;
  final GlobalKey<SfSignaturePadState> signatureGlobalKey;
  final Function(String, String, String, String, String) handleSaveButtonPressed;
  final VoidCallback handleClearButtonPressed;
final  ScrollController scrollController;
  SalaryTable({
    required this.size,
    required this.selectedMonth,
    required this.type,
    required this.signatureGlobalKey,
    required this.handleSaveButtonPressed,
    required this.handleClearButtonPressed, required this. scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SizedBox(
        width: size / 2.5 + 30,
        child: Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: GetBuilder<WaitManagementViewModel>(builder: (_) {
              return GetBuilder<AccountManagementViewModel>(
                  builder: (controller) {
                    return GetBuilder<SalaryViewModel>(builder: (salaryController) {
                      return DataTable(
                          columnSpacing: 0,
                          dividerThickness: 0.3,

                          columns: _buildDataColumns(type),
                          rows: _buildDataRows(controller, salaryController,context));
                    });
                  });
            }),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildDataColumns(TableType type) {
    List<String> columns = type == TableType.Payable
        ? ["الاسم الكامل", "الراتب المستحق", "الراتب الكلي", "العمليات"]
        : ["الاسم الكامل", "الراتب المستحق", "الراتب الكلي", "الراتب المستلم"];

    return List.generate(
        columns.length,
            (index) => DataColumn(
            label: Container(
                width: size / 2.5 / columns.length,
                child: Center(child: Text(columns[index].toString().tr)))));
  }

  List<DataRow> _buildDataRows(AccountManagementViewModel accountController,
      SalaryViewModel salaryController,context) {

    List<MapEntry<String, AccountManagementModel>> employees = accountController
        .allAccountManagement.entries
        .where((element) =>
    element.value.employeeTime.keys.where((element0) => element0.toString().split("-")[1]=='${months[selectedMonth]}',).isNotEmpty
        &&element.value.salaryReceived!.where((element) {
          return element.toString().split(" ")[0] ==
              '${thisTimesModel!.year}-${months[selectedMonth]}';
        },).isEmpty)
        .toList();

    if (type == TableType.Payable) {
      return List.generate(
          employees.length,
              (index) {
            AccountManagementModel accountModel = employees[index].value;
            int totalLate = accountModel.employeeTime.isEmpty
                ? 0
                : accountModel.employeeTime.values
                .map((e) => e.totalLate ?? 0)
                .reduce((value, element) => value + element);
            int totalEarlier = accountModel.employeeTime.isEmpty
                ? 0
                : accountModel.employeeTime.values
                .map((e) => e.totalEarlier ?? 0)
                .reduce((value, element) => value + element);
            int totalTime = totalLate + totalEarlier;
            return DataRow(cells: [
              dataRowItem(size / 2.5 / 4, accountModel.fullName.toString()),
              dataRowItem(
                size / 2.5 / 4,
                ((accountModel.salary!) -
                    ((accountModel.salary! / accountModel.dayOfWork!) *
                        ((totalTime / 60).floor() * 0.5)))
                    .toString(),
              ),
              dataRowItem(size / 2.5 / 4, accountModel.salary.toString()),
              dataRowItem(
                size / 2.5 / 4,
                "تسليم الراتب".tr,
                color: Colors.green,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => buildSignViewDialog(
                        ((accountModel.salary!) -
                            ((accountModel.salary! / accountModel.dayOfWork!) *
                                ((totalTime / 60).floor() * 0.5)))
                            .toString(),
                        accountModel,
                        "${thisTimesModel!.year}-${months[selectedMonth]}",signatureGlobalKey,handleSaveButtonPressed,handleClearButtonPressed),
                  );
                },
              ),
            ]);
          });
    } else {
      return List.generate(
          salaryController.salaryMap.values
              .where((element) =>
          element.salaryId.toString().split(" ")[0] ==
              '${thisTimesModel!.year}-${months[selectedMonth]}')
              .length,
              (index) {
            SalaryModel salaryEmp = salaryController.salaryMap.values
                .where((element) =>
            element.salaryId.toString().split(" ")[0] ==
                '${thisTimesModel!.year}-${months[selectedMonth]}')
                .toList()[index];

            return DataRow(cells: [
              dataRowItem(
                  size / 2.5 / 4,
                  accountController.allAccountManagement[
                  salaryEmp.employeeId.toString()]
                      ?.fullName
                      .toString()),
              dataRowItem(size / 2.5 / 4, salaryEmp.dilaySalary.toString()),
              dataRowItem(size / 2.5 / 4, salaryEmp.constSalary.toString()),
              dataRowItem(size / 2.5 / 4, salaryEmp.paySalary.toString()),
            ]);
          });
    }
  }


}
