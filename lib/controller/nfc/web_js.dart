import 'dart:js' as js;
import 'package:universal_html/html.dart';
import 'package:get/get.dart';
import '../../screens/Employee/Controller/Employee_view_model.dart';

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
      accountManagementViewModel.addTime(cardId: serialCode);
    }else{
      accountManagementViewModel.addCard(cardId: serialCode);
    }

  });
  return isSupportNfc;
}
