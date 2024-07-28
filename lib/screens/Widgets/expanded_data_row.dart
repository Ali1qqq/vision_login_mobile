import 'package:flutter/material.dart';


class ExpandedDataRow<T> extends StatefulWidget {
  const ExpandedDataRow({super.key, required this.size, required this.numberOfRow, required this.listOfDataCell, required this.listOfData});

  final double size ;
  final int numberOfRow ;
  final List<DataCell> Function(T model) listOfDataCell ;
  final List<T> listOfData ;

  @override
  State<ExpandedDataRow> createState() => _ExpandedDataRowState<T>();
}

class _ExpandedDataRowState<T> extends State<ExpandedDataRow> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columnSpacing: 0, columns: [
        DataColumn(label: Container(width: widget.size, child: Center(child: Text("اليوم")))),
        DataColumn(label: Container(width: widget.size, child: Center(child: Text("الدخول")))),
        DataColumn(label: Container(width: widget.size, child: Center(child: Text("الخروج")))),
        DataColumn(label: Container(width: widget.size, child: Center(child: Text("المجموع")))),
        DataColumn(label: Container(width: widget.size, child: Center(child: Text("تأخر بالدخول")))),
        DataColumn(label: Container(width: widget.size, child: Center(child: Text(" التأخير")))),
        DataColumn(label: Container(width: widget.size, child: Center(child: Text("عرض المبرر")))),
        DataColumn(label: Container(width: widget.size, child: Center(child: Text("خروج المبكر")))),
        DataColumn(label: Container(width: widget.size, child: Center(child: Text(" الخروج المبكر")))),
        DataColumn(label: Container(width: widget.size, child: Center(child: Text("عرض المبرر")))),
      ], rows:
        [
          for (var model in widget.listOfData)
            DataRow(cells: widget.listOfDataCell(model)),
        ]
      // [
      //   for (var j in i.employeeTime.values)
      //     DataRow(cells: [
      //       dataRowItem( j.dayName.toString()),
      //       dataRowItem( DateFun.dateToMinAndHour(j.startDate!)),
      //       dataRowItem( (j.endDate == null ? "" : DateFun.dateToMinAndHour(j.endDate!))),
      //       dataRowItem( DateFun.minutesToTime(j.totalDate ?? 0)),
      //       dataRowItem( (j.isLateWithReason == null ? "" : (j.isLateWithReason! ? "مع مبرر" : "بدون مبرر"))),
      //       dataRowItem( j.totalLate == null || j.totalLate == 0 ? "" : DateFun.minutesToTime(j.totalLate!)),
      //       dataRowItem( j.reasonOfLate != null && j.reasonOfLate != "" ? "عرض" : "", onTap: () {
      //         Get.defaultDialog(
      //             title: "المبرر",
      //             backgroundColor: Colors.white,
      //             content: Container(
      //               height: Get.height / 2,
      //               width: Get.height / 2,
      //               child: Text(j.reasonOfLate.toString()),
      //             ));
      //       }, color: Colors.teal),
      //       dataRowItem( (j.isEarlierWithReason == null ? "" : (j.isEarlierWithReason! ? "مع مبرر" : "بدون مبرر"))),
      //       dataRowItem( j.totalEarlier == null || j.totalEarlier == 0 ? "" : DateFun.minutesToTime(j.totalEarlier!)),
      //       dataRowItem(j.reasonOfEarlier != null && j.reasonOfEarlier != "" ? "عرض" : "", onTap: () {
      //         Get.defaultDialog(
      //             title: "المبرر",
      //             backgroundColor: Colors.white,
      //             content: Container(
      //               height: Get.height / 2,
      //               width: Get.height / 2,
      //               child: Text(j.reasonOfEarlier.toString()),
      //             ));
      //       }, color: Colors.teal),
      //     ]),
      // ]
      ),
    );
  }
}
DataCell dataRowItem( size,text, {onTap, color}) {
  return DataCell(
    Container(
      width: size,
      child: InkWell(
          onTap: onTap,
          child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: color == null ? null : TextStyle(color: color),
              ))),
    ),
  );
}

