import 'Installment_model.dart';
import 'event_record_model.dart';

class ParentModel {
  String? fullName, parentID, address, phoneNumber, motherPhone, emergencyPhone, paymentWay, id, nationality, startDate, work;
  bool? isAccepted;
  List<dynamic>? children, contract;
  List<EventRecordModel>? eventRecords;
  Map<String, InstallmentModel>? installmentRecords = {};
  int? totalPayment=0;

  ParentModel({
    this.id,
    this.fullName,
    this.address,
    this.phoneNumber,
    this.motherPhone,
    this.startDate,
    this.emergencyPhone,
    this.work,
    this.parentID,
    this.eventRecords,
    this.nationality,
    this.contract,
    this.isAccepted,
    this.installmentRecords,
    this.paymentWay,
    this.totalPayment,
    this.children,
  });

  Map<String, dynamic> toJson() {
    return {
      if (startDate != null) 'startDate': startDate,
      if (fullName != null) 'fullName': fullName,
      if (parentID != null) 'parentID': parentID,
      if (address != null) 'address': address,
      if (nationality != null) 'nationality': nationality,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (motherPhone != null) 'motherPhone': motherPhone,
      if (emergencyPhone != null) 'emergencyPhone': emergencyPhone,
      if (work != null) 'work': work,
      if (id != null) 'id': id,
      if (contract != null) 'contract': contract,
      if (children != null) 'children': children,
      if (installmentRecords != null) 'installmentRecords': Map.fromEntries(installmentRecords!.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList()),
      if (isAccepted != null) 'isAccepted': isAccepted,
      if (eventRecords != null) 'eventRecords': eventRecords?.map((event) => event.toJson()).toList() ?? [],
      if (paymentWay != null) 'paymentWay': paymentWay,
    };
  }

  // Method to create ParentModel instance from JSON
  ParentModel.fromJson(Map<String, dynamic> json) {
    {
      fullName = json['fullName'] ?? '';
      parentID = json['parentID'] ?? '';
      address = json['address'] ?? '';
      isAccepted = json['isAccepted'] ?? true;
      startDate = json['startDate'] ?? '';
      nationality = json['nationality'] ?? '';
      phoneNumber = json['phoneNumber'] ?? '';
      motherPhone = json['motherPhone'] ?? '';
      emergencyPhone = json['emergencyPhone'] ?? '';
      work = json['work'] ?? '';
      id = json['id'] ?? '';

      (json['installmentRecords'] ?? {}).forEach((k, v) {
        // إنشاء الكائن مرة واحدة فقط
        var installment = InstallmentModel.fromJson(v);

        // تخزين الكائن في القاموس
        installmentRecords![k] = installment;

        // التحقق من قيمة installmentCost وجمع المجموع
        if (installment.installmentCost != null && installment.installmentCost!.isNotEmpty) {
          totalPayment = totalPayment! + (int.tryParse(installment.installmentCost!) ?? 0);
        }
      });
      contract = json['contract'] ?? [];
      children = json['children'] ?? [];
      eventRecords = (json['eventRecords'] as List<dynamic>?)?.map((event) => EventRecordModel.fromJson(event)).toList();
    }
    paymentWay = json['paymentWay'] ?? '';
  }

  @override
  String toString() {
    return 'ParentModel{fullName: $fullName, parentID: $parentID, address: $address, phoneNumber: $phoneNumber, mPhoneNumber: $motherPhone, emergencyPhone: $emergencyPhone, work: $work, eventRecords: $eventRecords}';
  }
}
