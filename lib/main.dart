import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vision_dashboard/core/constant/constants.dart';
import 'package:vision_dashboard/core/Styling/app_colors.dart';
import 'package:vision_dashboard/core/binding/binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vision_dashboard/models/TimeModel.dart';
import 'package:vision_dashboard/core/router/router.dart';
import 'package:vision_dashboard/screens/employee_time/employee_time.dart';
import 'package:vision_dashboard/core/Utils/Hive_DataBase.dart';
import 'core/Translate/App_Translation.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDataBase.init();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
  );
/*  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);*/
  currentEmployee= await HiveDataBase.getAccountManagementModel();
  thisTimesModel = TimesModel.fromDateTime(Timestamp.now().toDate());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routingCallback: (value) {
      },
      translationsKeys: AppTranslation.translationKes,
      locale: const Locale("ar", "ar"),
      fallbackLocale: const Locale("ar", "ar"),
      textDirection: Get.locale.toString() != "en_US"
          ? TextDirection.rtl
          : TextDirection.ltr,
      initialBinding: GetBinding(),
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'مركز رؤية التعليمي للتدريب',
      theme: ThemeData(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            // backgroundColor: primaryColor,
            // foregroundColor: Colors.white
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            // backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
            // foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
        ),
        buttonTheme: ButtonThemeData(
          // buttonColor: Colors.white,
          // textTheme: ButtonTextTheme.normal,
        ),
        fontFamily: 'Cairo',
        canvasColor: secondaryColor,
        scaffoldBackgroundColor: bgColor,
        textTheme: TextTheme(
          bodySmall: TextStyle(color: AppColors.textColor),
          bodyLarge: TextStyle(color: AppColors.textColor),
          bodyMedium: TextStyle(color: AppColors.textColor),
          labelSmall: TextStyle(color: AppColors.textColor),
          labelLarge: TextStyle(color: AppColors.textColor),
          labelMedium: TextStyle(color: AppColors.textColor),
          displayLarge: TextStyle(color: AppColors.textColor),
          titleSmall: TextStyle(color: AppColors.textColor),
          titleLarge: TextStyle(color: AppColors.textColor),
          titleMedium: TextStyle(color: AppColors.textColor),
          displayMedium: TextStyle(color: AppColors.textColor),
          displaySmall: TextStyle(color: AppColors.textColor),
          headlineLarge: TextStyle(color: AppColors.textColor),
          headlineMedium: TextStyle(color: AppColors.textColor),
          headlineSmall: TextStyle(color: AppColors.textColor),
        ),
      ),


      unknownRoute: GetPage(
        name: '/unknown',

        page: () => EmployeeTimeView(), // واجهة معينة لعرضها
      ),
      // home: AllExp(),
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.main,


    );
  }
}


class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}