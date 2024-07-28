import 'dart:js' as js;
import 'package:universal_html/html.dart';
import 'package:get/get.dart';
import '../account_management_view_model.dart';

Future<bool> initNFCWorker(typeNFC type) async {
  bool isSupportNfc = false;
  var a = await js.context.callMethod(
    'initNFC',
  );
  if (a == "ok") {
    isSupportNfc = true;
  } else {
    isSupportNfc = false;
  }
  window.addEventListener("message", (event) {
    var state = js.JsObject.fromBrowserObject(js.context['state']);
    print(state['data']);
    String serialCode = state['data'].toString();
    AccountManagementViewModel accountManagementViewModel = Get.find<AccountManagementViewModel>();
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
