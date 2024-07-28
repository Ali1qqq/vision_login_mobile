import 'dart:math';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/controller/home_controller.dart';
import 'package:vision_dashboard/screens/Buses/Buses_View.dart';
import 'package:vision_dashboard/screens/Exams/Exam_View.dart';
import 'package:vision_dashboard/screens/Parents/Parents_View.dart';
import 'package:vision_dashboard/screens/Salary/Salary_view.dart';
import 'package:vision_dashboard/screens/Settings/Setting_View.dart';
import 'package:vision_dashboard/screens/Store/Store_View.dart';
import 'package:vision_dashboard/screens/Student/Student_view_Screen.dart';
import 'package:vision_dashboard/screens/Study%20Fees/Study_Fees_View.dart';
import 'package:vision_dashboard/screens/classes/classes_view.dart';
import 'package:vision_dashboard/screens/dashboard/dashboard_screen.dart';
import 'package:vision_dashboard/screens/expenses/expenses_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';
import 'package:vision_dashboard/screens/login/login_screen.dart';
import 'package:vision_dashboard/screens/logout/logout_View.dart';
import 'package:vision_dashboard/utils/Hive_DataBase.dart';

import '../account_management/Employee_View.dart';

import '../employee_time/employee_time.dart';
import '../event/event_view_screen.dart';
// import 'dart:html'  as html;

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {

  List<({String name, String img, Widget widget})> allData = [
    (
      name: "لوحة التحكم",
      img: "assets/dashIcon/dash.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),):DashboardScreen(),
    ),
    (
      name: "أولياء الامور",
      img: "assets/dashIcon/family (1).png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): ParentsView(),
    ),
    (
      name: "الطلاب",
      img: "assets/dashIcon/student.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): StudentView(),
    ),
    (
      name: "الصفوف",
      img: "assets/dashIcon/class.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): ClassesView(),
    ),
    (
      name: "الدوام",
      img: "assets/dashIcon/time.png",
      widget: EmployeeTimeView(),
    ),
    (
      name: "الامتحانات",
      img: "assets/dashIcon/checklist.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): ExamView(),
    ),
    (
      name: "الموظفين",
      img: "assets/dashIcon/employee.png",
      widget: !(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),):EmployeeView(),
    ),
    (
    name: "الرواتب",
    img: "assets/dashIcon/salary.png",
    widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): SalaryView(),
    ),
    (
      name: "الحافلات",
      img: "assets/dashIcon/bus.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): BusesView(),
    ),
    (
      name: "الرسوم الدراسية",
      img: "assets/dashIcon/accounting.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): StudyFeesView(),
    ),
    (
      name: "الأحداث",
      img: "assets/dashIcon/events.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): EventViewScreen(),
    ),
    (
      name: "المصاريف",
      img: "assets/dashIcon/audit.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): ExpensesViewScreen(),
    ),
    (
      name: "المستودع",
      img: "assets/dashIcon/groceries.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')?  Container(child: Center(child: Text("غير مسموح الوصل".tr),),): StoreViewPage(),
    ),
    (
      name: "ادارة المنصة",
      img: "assets/dashIcon/setting.png",
      widget:!(HiveDataBase.getAccountManagementModel()!.type!='مستخدم')? Container(child: Center(child: Text("غير مسموح الوصل".tr),),): SettingsView(),
    ),
    (
      name: "تسجيل الخروج",
      img: "assets/dashIcon/logout.png",
      widget:LogoutView() ,
    ),
  ];

  late TabController tabController;



  @override
  void initState() {
    print(HiveDataBase.getAccountManagementModel()!.type);
    tabController = TabController(length: allData.length, vsync: this);
      tabController.addListener(() {
        // html.window.history.pushState(null, '', "/#/"+allData[tabController.index].widget.toString());
          HiveDataBase.setCurrentScreen(tabController.index.toString());

        setState(() {});
      });
    super.initState();
    WidgetsFlutterBinding.ensureInitialized()
        .waitUntilFirstFrameRasterized
        .then(
      (value) {

        tabController
            .animateTo(int.parse(HiveDataBase.getUserData().currentScreen));
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(builder: (controller) {
      return Scaffold(
        backgroundColor: secondaryColor,
        body: SafeArea(
          child: controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
                child: SizedBox(
                  height:max(900, Get.height-40),
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
                      unselectedTextStyle: Styles.headLineStyle1.copyWith(
                        color: primaryColor,
                        fontSize: 13.0,
                      ),
                      colors: List.generate(allData.length, (index) => bgColor),
                      tabs: List.generate(
                        allData.length,
                        (index) {
                          return DrawerListTile(
                            index: index,
                            title: allData[index].name.toString().tr,
                            svgSrc: allData[index].img,
                            press: () {
                              setState(() {});
                            },
                          );
                        },
                      ),
                      child: allData[int.parse(
                              HiveDataBase.getUserData().currentScreen)]
                          .widget),
                ),
              ),
        ),
      );
    });
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.index,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(builder: (controller) {
      return Directionality(
        textDirection: Get.locale.toString() != "en_US"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: controller.isDrawerOpen
            ? Center(
                child: Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Image.asset(
                    svgSrc,
                    height: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                    ),

                  ),

                ],
              ))
            : Center(
                child: Image.asset(
                  svgSrc,
                  height: 26,
                ),
              ),
      );
    });
  }
}
