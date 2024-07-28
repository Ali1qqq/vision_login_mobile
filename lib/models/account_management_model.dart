import 'package:vision_dashboard/models/employee_time_model.dart';

import 'event_record_model.dart';

class AccountManagementModel {
  late String id, userName, password, type;
  String? serialNFC;
  int? salary, dayOfWork,discounts;
  bool? isAccepted;
  late bool isActive;
  Map<String, EmployeeTimeModel> employeeTime = {};
  String? mobileNumber,
      address,
      nationality,
      gender,
      age,
      jobTitle,
      contract,
      bus,
      startDate,
      salaryWithDelay,
      fullName;
  List<dynamic>? salaryReceived;
  bool? available = false;
  List<EventRecordModel>? eventRecords;

  AccountManagementModel(
      {required this.id,
      required this.userName,
      required this.password,
      required this.type,
      required this.serialNFC,
      required this.isActive,
      required this.salary,
      required this.dayOfWork,
      this.mobileNumber,
      this.address,
      this.nationality,
      this.gender,
      this.age,
      this.jobTitle,
      this.contract,
      this.bus,
      this.startDate,
      this.eventRecords,
      this.salaryReceived,
      this.salaryWithDelay,
      this.fullName,
      this.isAccepted,
      this.discounts,
      this.available});

  AccountManagementModel.fromJson(json) {
    id = json['id'] ?? '';
    userName = json['userName'] ?? '';
    password = json['password'] ?? '';
    type = json['type'] ?? '';
    fullName = json['fullName'] ?? '';
    serialNFC = json['serialNFC'] ?? '';
    salary = json['salary'] ?? 0;
    discounts = json['salary'] ?? 0;
    salaryReceived = json['salaryReceived'] ?? [] ?? '';
    dayOfWork = json['dayOfWork'] ?? 0;
    isActive = json['isActive'] ?? true;
    isAccepted = json['isAccepted'] ?? true;

    (json['employeeTime'] ?? {}).forEach((k, v) {
      employeeTime[k] = EmployeeTimeModel.fromJson(v);
    });
    mobileNumber = json['mobileNumber'] ?? '';
    address = json['address'] ?? '';
    nationality = json['nationality'] ?? '';
    gender = json['gender'] ?? '';
    age = json['age'] ?? '';
    jobTitle = json['jobTitle'] ?? '';
    contract = json['contract'] ?? '';
    bus = json['bus'] ?? '';
    startDate = json['startDate'] ?? '';
    eventRecords = ((json['eventRecords'] ?? []) as List<dynamic>?)
            ?.map((event) => EventRecordModel.fromJson(event))
            .toList() ??
        [];
  }

  toJson() {
    return {
      "id": id,
      "userName": userName,
      if (fullName != null) "fullName": fullName,
      if (discounts != null) "discounts": discounts,
      "password": password,
      if (salaryReceived != null) "salaryReceived": salaryReceived?.toList(),
      "type": type,
      if (serialNFC != null) "serialNFC": serialNFC,
      "isActive": isActive,
      if (salary != null) "salary": salary,
      if (isAccepted != null) "isAccepted": isAccepted,
      if (dayOfWork != null) "dayOfWork": dayOfWork,
      if(employeeTime.isEmpty)
      "employeeTime": Map.fromEntries(employeeTime.entries
          .map((e) => MapEntry(e.key, e.value.toJson()))
          .toList()),
      if (mobileNumber != null) 'mobileNumber': mobileNumber,
      if (address != null) 'address': address,
      if (nationality != null) 'nationality': nationality,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (jobTitle != null) 'jobTitle': jobTitle,
      if (contract != null) 'contract': contract,
      if (bus != null) 'bus': bus,
      if (startDate != null) 'startDate': startDate!,
      'eventRecords': eventRecords!.isNotEmpty
          ? eventRecords!.map((event) => event.toJson()).toList()
          : [],
    };
  }
}
