import 'package:get/get.dart';

import '../utils/abstract.dart';
import 'event_record_model.dart';

class BusModel implements Mappable {
  String? busId;
  String? name;
  String? number;
  String? type;
  List<String>? employees;
  List<String>? students;
  DateTime? startDate;
  List<String>? expense;
  bool? isAccepted;

  List<EventRecordModel>? eventRecords;

  BusModel({
    this.name,
    this.busId,
    this.number,
    this.type,
    this.employees,
    this.students,
    this.startDate,
    this.expense,
    this.eventRecords,
    this.isAccepted,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (busId != null) 'busId': busId,
        if (number != null) 'number': number,
        if (type != null) 'type': type,
        if (isAccepted != null) 'isAccepted': isAccepted,
        if (employees != null) 'employees': employees!.toList(),
        if (students != null) 'students': students!.toList(),
        if (startDate != null) 'startDate': startDate!.toIso8601String(),
        if (expense != null) 'expense': expense,
        if (eventRecords != null) 'eventRecords': eventRecords!.map((event) => event.toJson()).toList(),
      };

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      name: json['name'] ?? '',
      busId: json['busId'] ?? '',
      number: json['number'] ?? '',
      type: json['type'] ?? '',
      isAccepted: json['isAccepted'] ?? true,
      employees: List<String>.from(json['employees'] ?? []),
      students: List<String>.from(json['students'] ?? []),
      startDate: DateTime.parse(json['startDate']),
      expense: List<String>.from(json['expense'] ?? []),
      eventRecords: (json['eventRecords'] as List<dynamic>?)?.map((event) => EventRecordModel.fromJson(event)).toList()
        ?..sort((a, b) {
          // افترض أن لديك حقل `date` أو `timestamp` في `EventRecordModel`
          DateTime dateA = DateTime.parse(a.date); // استبدل `date` بالحقل المناسب
          DateTime dateB = DateTime.parse(b.date); // استبدل `date` بالحقل المناسب
          return dateA.compareTo(dateB); // ترتيب تصاعدي
        }),
    );
  }

  @override
  String toString() {
    return 'Bus(name: $name, number: $number, type: $type, employee: $employees, students: $students, startDate: $startDate, expense: $expense, eventRecords: $eventRecords)';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "الرقم التسلسلي": busId.toString(),
      'رقم الحافلة': number.toString(),
      'اسم الحافلة': name.toString(),
      'النوع': type.toString(),
      'عدد الطلاب': students?.length.toString(),
      'عدد الموظفين': employees?.length.toString(),
      'تاريخ البداية': startDate.toString(),
      "موافقة المدير": isAccepted == true ? "تمت الموافقة".tr : "في انتظار الموافقة".tr,
    };
  }
}
