import 'package:get/get.dart';

import 'package:vision_dashboard/screens/login/login_screen.dart';
import 'package:vision_dashboard/screens/main/main_screen.dart';

class AppRoutes {
  static const main = '/';
  static const DashboardScreen = '/DashboardScreen';
  static const parentView = '/ParentsView';
  static const StudentView = '/StudentView';
  static const ClassesView = '/ClassesView';
  static const EmployeeTimeView = '/EmployeeTimeView';
  static const ExamView = '/ExamView';
  static const SalaryView = '/SalaryView';
  static const BusesView = '/BusesView';
  static const StudyFeesView = '/StudyFeesView';
  static const EventViewScreen = '/EventViewScreen';
  static const ExpensesViewScreen = '/ExpensesViewScreen';
  static const EmployeeView = '/EmployeeView';
  static const StoreView = '/StoreViewPage';
  static const Container = '/LoginScreen';

  static List<GetPage> routes = [
    GetPage(name: main, page: () => LoginScreen()),
    GetPage(
      name: DashboardScreen,
      page: () {
        // HiveDataBase.setCurrentScreen("0");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
   /* GetPage(
      name: parentView,
      page: () {
        // HiveDataBase.setCurrentScreen("1");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: StudentView,
      page: () {
        // HiveDataBase.setCurrentScreen("2");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: ClassesView,
      page: () {
        // HiveDataBase.setCurrentScreen("3");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: EmployeeTimeView,
      page: () {
        // HiveDataBase.setCurrentScreen("4");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: ExamView,
      page: () {
        // HiveDataBase.setCurrentScreen("5");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: SalaryView,
      page: () {
        // HiveDataBase.setCurrentScreen("6");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: BusesView,
      page: () {
        // HiveDataBase.setCurrentScreen("7");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: StudyFeesView,
      page: () {
        // HiveDataBase.setCurrentScreen("8");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: EventViewScreen,
      page: () {
        // HiveDataBase.setCurrentScreen("9");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: ExpensesViewScreen,
      page: () {
        // HiveDataBase.setCurrentScreen("10");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: StoreView,
      page: () {
        // HiveDataBase.setCurrentScreen("11");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),
    GetPage(
      name: EmployeeView,
      page: () {
        // HiveDataBase.setCurrentScreen("12");
        return MainScreen();
      },
      transition: Transition.topLevel,
    ),*/
    GetPage(
      name: Container,
      page: () => LoginScreen(),
      transition: Transition.zoom,
    ),
  ];
}
