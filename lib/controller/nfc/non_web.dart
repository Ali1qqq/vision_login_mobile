import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../screens/Settings/Controller/Settings_View_Model.dart';
import '../../core/constant/const.dart';
import '../../screens/employee_time/Controller/Employee_view_model.dart';


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
      // cardId=cardsMap.entries.where((element) => element.value==cardId,).firstOrNull?.key??cardId;
      EmployeeViewModel accountManagementViewModel = Get.find<EmployeeViewModel>();
      if(type==typeNFC.login){
        // accountManagementViewModel.signInUsingNFC(cardId);
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
            cardId: cardId,
          );
        } else {
          accountManagementViewModel.addTime(
            appendTime: appendTime,
            lateTime: lateTime,
            outTime: outTime,
            cardId: cardId,
          );
        }
      }else{
        accountManagementViewModel.addCard(cardId: cardId);
      }
    });
  }
  return isNfcAvailable;
}