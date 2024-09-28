
abstract class Const {
  static const expensesCollection = "Expenses";
  static const eventCollection = "Events";
  static const waitManagementCollection = "WaitManagement";
  static const settingsCollection = "Setting";
  static const eventTypeStudent = 'eventTypeStudent';
  static const eventTypeParent = 'eventTypeParent';
  static const eventTypeEmployee = 'eventTypeEmployee';
  static const allEventType = [eventTypeStudent, eventTypeParent, eventTypeEmployee];
  static const String appendTime = 'AppendTime';
  static  const String lateTime = 'LateTime';
  static  const String outTime = 'OutTime';
  static const String friAppendTime = 'FriAppendTime';
  static  const String friLateTime = 'FriLateTime';
  static  const String friOutTime = 'FriOutTime';
  static const String time = 'Time';
}

Map<String, Map<String, dynamic>> compareMaps(Map<String, dynamic> newData, Map<String, dynamic> oldData) {
  Map<String, Map<String, dynamic>> differences = {};

  newData.forEach((key, value) {

    if (key != "isAccepted"&&key != "installmentRecords"&&key!="eventRecords") if (oldData.containsKey(key) && newData[key].toString() != oldData[key].toString()) {
      differences[key] = {'newData': newData[key], 'oldData': oldData[key]};
    }
    ///فحص الاقساط
    if (key == "installmentRecords") {
/// معرفة اذا كان هناك تعديل على الاقساط كلها
      Map<String, Map<String, dynamic>> installmentDeference = compareMaps(newData[key], oldData[key]);
      print(installmentDeference.length);
      if (installmentDeference != {}) {
        /// الدوران على القسط المتعدل لمعرفة التعديل الحاصل
        installmentDeference.forEach(
          (key, value) {
            /// التعديلات التي حصلت على القسط
            Map<String, Map<String, dynamic>> installmentDeference2 = compareMaps(value['newData'], value['oldData']);
            ///الدوران على التعديلات التي حصلت
            installmentDeference2.forEach((key, value) {
              differences[key] = {'newData': value['newData'], 'oldData': value['oldData']};

            },);
          },
        );
      }
    }
    if (key == "eventRecords") {

      bool eventAdd = newData[key].length!=oldData[key].length;
      print(eventAdd);
      if(eventAdd) {
        String newEvent = '';
        List<dynamic> dataList = newData[key];

        for (int i = 0; i < dataList.length; i++) {
          var string = dataList[i];
          newEvent += string["type"].toString() + " - " + string["body"].toString();

          // إذا لم يكن العنصر الأخير، أضف "\n"
          if (i < dataList.length - 1) {
            newEvent += "\n";
          }
        }
        differences["eventRecords"] = {'newData':newEvent, 'oldData': "اضافة حدث"};
      }
    }
  });

  return differences;
}

String getEventTypeFromEnum(data) {
  if (data == Const.eventTypeStudent) {
    return "طالب";
  } else if (data == Const.eventTypeParent) {
    return "ولي أمر";
  } else if (data == Const.eventTypeEmployee) {
    return "موظفين";
  } else {
    return "UNKNOWN";
  }
}
