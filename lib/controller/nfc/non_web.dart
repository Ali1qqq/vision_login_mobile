import 'dart:io';

import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';


Future<bool> initNFCWorker(typeNFC type) async {
  bool isNfcAvailable = false;
  if(!Platform.isAndroid &&!Platform.isIOS){
    return false;
  }
  isNfcAvailable = await NfcManager.instance.isAvailable();
  if(isNfcAvailable){
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      List<int> idList = tag.data["ndef"]['identifier'];
      String id ='';
      for(var e in idList){
        if(id==''){
          id="${e.toRadixString(16).padLeft(2,"0")}";
        }else{
          id="$id:${e.toRadixString(16).padLeft(2,"0")}";
        }
      }
      var cardId=id.toUpperCase();
      AccountManagementViewModel accountManagementViewModel = Get.find<AccountManagementViewModel>();
      if(type==typeNFC.login){
        // accountManagementViewModel.signInUsingNFC(cardId);
      }else if(type==typeNFC.time){
        accountManagementViewModel.addTime(cardId: cardId);
      }else{
        accountManagementViewModel.addCard(cardId: cardId);
      }
    });
  }
  return isNfcAvailable;
}