class EventRecordModel {
  late String body , type , date , color ;

  EventRecordModel({required this.body,required this.type,required this.date,required this.color});
  EventRecordModel.fromJson(json){
    body = json ['body'];
    type = json ['type'];
    date = json ['date'];
    color = json ['color'];
  }
  toJson(){
    return {
      "body":body,
      "type":type,
      "date":date,
      "color":color,
    };
  }
}