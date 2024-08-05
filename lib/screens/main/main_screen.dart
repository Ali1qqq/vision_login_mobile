import 'dart:math';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';
import 'package:vision_dashboard/utils/Hive_DataBase.dart';

import 'Widgets/Drawer_List_Tile.dart';



class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {

late TabController tabController;
@override
void initState() {
  super.initState();

  tabController = TabController(length: allData.length, vsync: this);
  tabController.addListener(() {
    HiveDataBase.setCurrentScreen(tabController.index.toString());
    setState(() {});
  });
  WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then(
        (value) {
      tabController.animateTo(int.parse(HiveDataBase.getUserData().currentScreen));
      setState(() {});
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(builder: (controller) {
      return Scaffold(
        backgroundColor: secondaryColor,
        body: controller.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            :
        SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
          child: SizedBox(
            height:max(800, Get.height-40),
            child: TabContainer(
                textDirection: Get.locale.toString() != "en_US"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                controller: tabController,
                tabEdge: Get.locale.toString() != "en_US"
                    ? TabEdge.right
                    : TabEdge.left,
                tabsEnd: 1,
                tabsStart: 0.0,
                tabMaxLength: controller.isDrawerOpen ? 60 : 60,
                tabExtent: controller.isDrawerOpen ? 180 : 60,
                borderRadius: BorderRadius.circular(10),
                tabBorderRadius: BorderRadius.circular(20),
                childPadding: const EdgeInsets.all(0.0),
                selectedTextStyle: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
                unselectedTextStyle: AppStyles.headLineStyle1.copyWith(
                  color: primaryColor,
                  fontSize: 13.0,
                ),
                colors: List.generate(allData.length, (index) => bgColor),
                tabs: List.generate(
                  allData.length,
                      (index) {
                    return DrawerListTile(
                      controller: controller,
                      index: index,
                      title: allData[index].name.toString().tr,
                      svgSrc: allData[index].img,

                    );
                  },
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: allData[int.parse(HiveDataBase.getUserData().currentScreen)]
                      .widget,
                )),
          ),
        )

      );
    });
  }
}

