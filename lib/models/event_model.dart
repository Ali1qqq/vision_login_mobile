class EventModel {
  late String id,name,role;
  late int color;

  EventModel({required this.name,required this.id  ,required this.role ,required this.color});

  EventModel.fromJson(json){
    id = json['id'];
    name = json['name'];
    role = json['role'];
    color = json['color'];
  }
  toJson(){
    return {
      "id":id,
      "name":name,
      "role":role,
      "color":color,
    };
  }
}