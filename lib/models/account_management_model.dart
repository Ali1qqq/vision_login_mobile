import 'package:get/get.dart';
import 'package:vision_dashboard/models/employee_time_model.dart';

import '../screens/Buses/Controller/Bus_View_Model.dart';
import '../utils/Hive_DataBase.dart';
import '../utils/abstract.dart';
import 'event_record_model.dart';

class EmployeeModel implements Mappable{
  late String id, userName, password, type;
  String? serialNFC;
  int? salary, dayOfWork, discounts;
  bool? isAccepted;
  late bool isActive;
  Map<String, EmployeeTimeModel> employeeTime = {};
  String? mobileNumber, address, nationality, gender, age, jobTitle, contract, bus, startDate, salaryWithDelay, fullName;
  List<dynamic>? salaryReceived;
  List<dynamic>? idImages;
  bool? available = false;
  List<EventRecordModel>? eventRecords;

  EmployeeModel({
    required this.id,
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
    this.available,
    this.idImages,
  });

  EmployeeModel.fromJson(json) {
    id = json['id'] ?? '';
    userName = json['userName'] ?? '';
    password = json['password'] ?? '';
    type = json['type'] ?? '';
    fullName = json['fullName'] ?? '';
    serialNFC = json['serialNFC'] ?? '';
    salary = json['salary'] ?? 0;
    idImages = json['idImages'] ?? [];
    discounts = json['discounts'] ?? 0;
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
    eventRecords = ((json['eventRecords'] ?? []) as List<dynamic>?)?.map((event) => EventRecordModel.fromJson(event)).toList() ?? [];
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
      if (employeeTime.isEmpty) "employeeTime": Map.fromEntries(employeeTime.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList()),
      if (mobileNumber != null) 'mobileNumber': mobileNumber,
      if (address != null) 'address': address,
      if (nationality != null) 'nationality': nationality,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (idImages != null) 'idImages': idImages,
      if (jobTitle != null) 'jobTitle': jobTitle,
      if (contract != null) 'contract': contract,
      if (bus != null) 'bus': bus,
      if (startDate != null) 'startDate': startDate!,
      'eventRecords': eventRecords!.isNotEmpty ? eventRecords!.map((event) => event.toJson()).toList() : [],
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "الرقم التسلسلي": id,
      "اسم المستخدم":userName ,
      "الاسم الكامل": fullName,
      "كامة السر": HiveDataBase.getAccountManagementModel()?.type == "مالك" ? password : '' ,
      "الدور": type,
      "الحالة": isActive == true ? "فعال".tr : "غير فعال".tr,
      "رقم الموبايل": mobileNumber,
      "العنوان":address ,
      "الجنسية": nationality,
      "الجنس": gender,
      "العمر": age,
      "الوظيفة": jobTitle,
      "العقد":contract ,
      "الحافلة": Get.find<BusViewModel>().busesMap[bus]?.name ?? bus,
      "تاريخ البداية": startDate,
      "سجل الاحداث": eventRecords?.length,
      "موافقة المدير": isAccepted == true ? "تمت الموافقة".tr : "في انتظار الموافقة".tr,
    };
  }
}
