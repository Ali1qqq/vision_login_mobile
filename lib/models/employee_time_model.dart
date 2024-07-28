class EmployeeTimeModel{
  String? dayName,reasonOfLate ,reasonOfEarlier;
  DateTime? startDate , endDate ;
  int? totalDate ;
  bool? isDayEnd,isLateWithReason,isEarlierWithReason,isDayOff;
  int?  totalLate,totalEarlier;

  EmployeeTimeModel({
    required this.dayName,
    required this.startDate,
    required this.endDate,
    required this.totalDate,
    required this.isDayEnd,
    required this.isLateWithReason,
    required this.reasonOfLate,
    required this.isEarlierWithReason,
    required this.reasonOfEarlier,
    required this.isDayOff,
    required this.totalLate,
    required this.totalEarlier,


  });

  EmployeeTimeModel.fromJson(json){
    dayName = json['dayName'];
    isLateWithReason = json['isLateWithReason'];
    reasonOfLate = json['reasonOfLate'];
    startDate = json['startDate']==null ?null :json['startDate'].toDate();
    endDate = json['endDate']==null ?null :json['endDate'].toDate();
    totalDate = json['totalDate'];
    isDayEnd = json['isDayEnd'];
    isDayOff = json['isDayOff'];
    totalLate = int.tryParse(json['totalLate'].toString());
    isEarlierWithReason = json['isEarlierWithReason'];
    reasonOfEarlier = json['reasonOfEarlier'];
    totalEarlier = int.tryParse(json['totalEarlier'].toString());
  }

  toJson(){
    return {
      "dayName":dayName,
      "startDate":startDate,
      'endDate':endDate,
      "totalDate":totalDate,
      'isDayEnd':isDayEnd,
      'isDayOff':isDayOff,
      'isLateWithReason':isLateWithReason,
      'reasonOfLate':reasonOfLate,
      'totalLate':totalLate,
      'isEarlierWithReason':isEarlierWithReason,
      'reasonOfEarlier':reasonOfEarlier,
      'totalEarlier':totalEarlier,
    };
  }

}