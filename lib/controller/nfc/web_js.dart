import 'dart:js' as js;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_html/html.dart';
import 'package:get/get.dart';
import '../../screens/Employee/Controller/Employee_view_model.dart';
import '../../screens/Settings/Controller/Settings_View_Model.dart';
import '../../utils/const.dart';

Future<bool> initNFCWorker(typeNFC type) async {

  bool isSupportNfc = false;
  var a = await js.context.callMethod(
    'initNFC',
  );
  print(a);
  if (a == "ok") {
    isSupportNfc = true;
  } else {
    isSupportNfc = false;
  }
  window.addEventListener("message", (event) {
    var state = js.JsObject.fromBrowserObject(js.context['state']);
    String serialCode = state['data'].toString();
    EmployeeViewModel accountManagementViewModel = Get.find<EmployeeViewModel>();
    if(type==typeNFC.login){
      // accountManagementViewModel.signInUsingNFC(serialCode);
      print(serialCode);
    }else if(type==typeNFC.time){
      SettingsViewModel settingsController = Get.find<SettingsViewModel>();
      String lateTime = settingsController.settingsMap[Const.lateTime][Const.time];
      String appendTime = settingsController.settingsMap[Const.appendTime][Const.time];
      String outTime = settingsController.settingsMap[Const.outTime][Const.time];
      String friLateTime = settingsController.settingsMap[Const.friLateTime][Const.time];
      String friAppendTime = settingsController.settingsMap[Const.friAppendTime][Const.time];
      String friOutTime = settingsController.settingsMap[Const.friOutTime][Const.time];
      if ( Timestamp.now().toDate().weekday == DateTime.friday) {
        accountManagementViewModel.addTime(
          appendTime:friAppendTime ,
          lateTime:friLateTime ,
          outTime: friOutTime,
          cardId: serialCode,
        );
      } else {
        accountManagementViewModel.addTime(
          appendTime: appendTime,
          lateTime: lateTime,
          outTime: outTime,
          cardId: serialCode,
        );
      }
    }else{
      accountManagementViewModel.addCard(cardId: serialCode);
    }

  });
  return isSupportNfc;
}
