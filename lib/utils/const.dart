abstract class Const {

  static const expensesCollection = "Expenses";
  static const eventCollection = "Events";
  static const waitManagementCollection = "WaitManagement";


  static const eventTypeStudent = 'eventTypeStudent';
  static const eventTypeParent = 'eventTypeParent';
  static const eventTypeEmployee = 'eventTypeEmployee';
  static const allEventType = [eventTypeStudent,eventTypeParent,eventTypeEmployee];
}
Map<String, Map<String, dynamic>> compareMaps(Map<String, dynamic> newData, Map<String, dynamic> oldData) {
  Map<String, Map<String, dynamic>> differences = {};
  newData.forEach((key, value) {
    if (oldData.containsKey(key) && newData[key].toString() != oldData[key].toString()) {
      differences[key] = {'newData': newData[key], 'oldData': oldData[key]};
    }
  });
  return differences;}
String getEventTypeFromEnum(data){
  if(data == Const.eventTypeStudent){
    return "طالب";
  }else if(data == Const.eventTypeParent){
    return "ولي أمر";
  }else if(data == Const.eventTypeEmployee){
    return "موظفين";
  }else {
    return "UNKNOWN";
  }
}