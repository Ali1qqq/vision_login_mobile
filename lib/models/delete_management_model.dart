

class WaitManagementModel {
  late String id, affectedId, collectionName;

  Map<String, dynamic>? oldDate, newData;
  String? details, relatedId, date, type;

  bool? isAccepted;

  WaitManagementModel(
      {required this.id,
      required this.affectedId,
      required this.collectionName,
      this.details,
      this.relatedId,
      this.isAccepted,
      this.date,
      this.oldDate,
      this.newData,
      required this.type});

  WaitManagementModel.fromJson(json) {
    id = json['id'] ?? '';
    type = json['type'] ?? '';
    date = json['date'] ?? '';
    affectedId = json['affectedId'] ?? '';
    details = json['details'] ?? 'لا يوجد';
    isAccepted = json['isAccepted'];
    collectionName = json['collectionName'] ?? '';
    relatedId = json['relatedId'];
    oldDate=json['oldDate']??{};
    newData=json['newData']??{};

  }

  toJson() {
    return {
      "id": id,
      "date": date,
      "details": details,
      "collectionName": collectionName,
      "affectedId": affectedId,
      "isAccepted": isAccepted,
      "oldDate": oldDate,
      "newData": newData,
      "type": type,
      if (relatedId != null) "relatedId": relatedId,
    };
  }
}
