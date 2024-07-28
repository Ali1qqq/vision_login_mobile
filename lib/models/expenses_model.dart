

class ExpensesModel {
  String? id, title, userId, date;

  int? total;
bool? isAccepted;
  String? body, busId;

  List<dynamic>? images = [];

  ExpensesModel(
      {this.id,
      this.title,
      this.userId,
      this.total,
      this.busId,
      this.body,
      this.isAccepted,
      this.images,
      this.date});

  ExpensesModel.fromJson(json) {
    id = json['id'];
    title = json['title'];
    userId = json['userId'];
    total = json['total'];
    body = json['body'];
    isAccepted = json['isAccepted'];
    busId = json['busId'];
    date = json['date'] ?? DateTime.now().toString();
    images = json['images'] == null
        ? []
        : json['images'].map((e) => e.toString()).toList();
  }


  toJson() {
    return {
      "id": id,
      "title": title,
      "userId": userId,
      "total": total,
      "body": body,
      "isAccepted": isAccepted,
      if (busId != null) "busId": busId,
      "images": images,
      "date": date,
    };
  }
}
