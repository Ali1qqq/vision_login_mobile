import 'dart:ui';
import 'package:vision_dashboard/Translate/App_Translation.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/core/Styling/app_colors.dart';
import 'package:vision_dashboard/core/binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vision_dashboard/router.dart';
import 'package:vision_dashboard/screens/login/login_screen.dart';
import 'package:vision_dashboard/utils/Hive_DataBase.dart';
import 'core/Utils/service.dart';
import 'firebase_options.dart';
//flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
  );
/*  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);*/
  await HiveDataBase.init();
  await getTime();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // routerDelegate: router.routerDelegate,
      // routeInformationParser: router.routeInformationParser,
      // routeInformationProvider: router.routeInformationProvider,
      // routingCallback: _router.,

      routingCallback: (value) {


      },

      translationsKeys: AppTranslation.translationKes,

      // locale: const Locale("en", "US"),
      // fallbackLocale:const Locale("en", "US"),
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
        fontFamily: 'Poppins',
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

      /* theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.blue,
                displayColor: Colors.blue,
              ),
        ),
        canvasColor: secondaryColor,
      ),*/
      unknownRoute: GetPage(
        name: '/unknown',

        page: () => LoginScreen(), // واجهة معينة لعرضها
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
