import 'package:hive_flutter/hive_flutter.dart';

import '../models/account_management_model.dart';

class HiveDataBase {
  static late Box<String> accountBox;
  static late Box<Map> accountManagementBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    accountBox = await Hive.openBox<String>("Account");
    accountManagementBox = await Hive.openBox<Map>("AccountManagement");

  }

  static ({
    String userName,
    String type,
    String name,
    String seralNFC,
String id,
  String salary,
    String currentScreen
  }) getUserData() {
    String userName = accountBox.get("userName").toString();
    String type = accountBox.get("type").toString();
    String seralNFC = accountBox.get("seralNFC").toString();
    String name = accountBox.get("name").toString();
    String currentScreen = accountBox.get("currentScreen")??"0";
    String id = accountBox.get("id")??"0";
    String salary=accountBox.get("salary")??"0";


    return (
salary: salary,
        userName:userName,
    id:id,
      type:type,
        seralNFC:seralNFC,
      name:name,
      currentScreen: currentScreen
    );
  }

  static setUserData(
      { required String userName,required String type, required String serialNFC,required String name,required String id}) async {
    await accountBox.put("name",name);
    await accountBox.put("userName", userName);
    await accountBox.put("type", type);
    await accountBox.put("serialNFC", serialNFC);
    await accountBox.put("id", id);
    return true;
  }





  static setCurrentScreen(String currentScreen) async {
    await accountBox.put("currentScreen", currentScreen);
    return true;
  }

  static deleteUserData() {
    accountBox.delete("mobile");
    accountBox.delete("name");
    accountBox.delete("gender");
    accountBox.delete("email");
    accountBox.delete("licenseImage");
    accountBox.delete("passport");
  }


  static Future<void> setAccountManagementModel(AccountManagementModel model) async {
    await accountManagementBox.put("accountManagement", model.toJson());
  }

  static AccountManagementModel? getAccountManagementModel() {
    var json = accountManagementBox.get("accountManagement");
    if (json != null) {
      return AccountManagementModel.fromJson(json);
    }
    return null;
  }


  static Future<void> deleteAccountManagementModel() async {
    await accountManagementBox.delete("accountManagement");
  }
}
