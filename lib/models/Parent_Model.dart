


import 'event_record_model.dart';


class ParentModel {
  String? fullName,
      parentID,
      address,
      phoneNumber,
      motherPhone,
      emergencyPhone,age,
  id,
  nationality,startDate,
      work;
bool? isAccepted;
  List<dynamic>? children,contract;
  List<EventRecordModel>? eventRecords;

  ParentModel({
    this.id,
    this.age,
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

    this.children,
  });


  Map<String, dynamic> toJson() {
    return {
      if(startDate!=null)   'startDate':startDate,
      if(fullName!=null)   'fullName': fullName,
      if(parentID!=null)    'parentID': parentID,
      if(address!=null)  'address': address,
      if(nationality!=null)  'nationality':nationality,
      if(phoneNumber!=null)   'phoneNumber': phoneNumber,
      if(motherPhone!=null)    'motherPhone': motherPhone,
      if(emergencyPhone!=null)    'emergencyPhone': emergencyPhone,
      if(work!=null)    'work': work,
      if(id!=null)      'id':id,
      if(age!=null)     'age':age,
      if(contract!=null)     'contract':contract,
      if(children!=null)    'children':children,
      if(isAccepted!=null)    'isAccepted':isAccepted,
      if(eventRecords!=null)   'eventRecords': eventRecords?.map((event) => event.toJson()).toList()??[],
    };
  }

  // Method to create ParentModel instance from JSON
  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      fullName: json['fullName']??'',
      parentID: json['parentID']??'',
      address: json['address']??'',
      age:json['age']??'',
      isAccepted:json['isAccepted']??true,
      startDate:json['startDate']??'',
      nationality: json['nationality']??'',
      phoneNumber: json['phoneNumber']??'',
      motherPhone: json['motherPhone']??'',
      emergencyPhone: json['emergencyPhone']??'',
      work: json['work']??'',
      id: json['id']??'',
      contract: json['contract']??[],
      children: json['children']??[],
      eventRecords: (json['eventRecords'] as List<dynamic>?)
          ?.map((event) => EventRecordModel.fromJson(event))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ParentModel{fullName: $fullName, parentID: $parentID, address: $address, phoneNumber: $phoneNumber, mPhoneNumber: $motherPhone, emergencyPhone: $emergencyPhone, work: $work, eventRecords: $eventRecords}';
  }
}


