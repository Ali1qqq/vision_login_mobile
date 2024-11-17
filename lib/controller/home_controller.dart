import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/Utils/Hive_DataBase.dart';


class HomeViewModel extends GetxController {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  int menuIndex = 0;
  bool isDrawerOpen= true;
  bool isLoading=false;
  int currentScreenIndex=int.parse(HiveDataBase.getUserData().currentScreen);
  changeIsLoading(){
    isLoading=!isLoading;
    update();
  }
  void changeIndex(_) {
    menuIndex = _;
    update();
  }

  void controlMenu() {
    // if (!_scaffoldKey.currentState!.isDrawerOpen) {
    //   _scaffoldKey.currentState!.openDrawer();
    // }
    isDrawerOpen=!isDrawerOpen;
    update();
  }

   changeCurrentScreen(int index) {
     HiveDataBase.setCurrentScreen(index.toString());
     currentScreenIndex=index;
     update();
   }

}
