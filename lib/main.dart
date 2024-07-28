import 'dart:ui';
import 'package:vision_dashboard/Translate/App_Translation.dart';
import 'package:vision_dashboard/constants.dart';
import 'package:vision_dashboard/core/binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vision_dashboard/router.dart';
import 'package:vision_dashboard/screens/login/login_screen.dart';
import 'package:vision_dashboard/utils/Dialogs.dart';
import 'package:vision_dashboard/utils/Hive_DataBase.dart';
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


/*        final pageIndex = Get.parameters['page'];
        print(pageIndex);
        HiveDataBase.setCurrentScreen(pageIndex.toString());*/
      },
/*      routingCallback: (value) {
        HomeViewModel homeController = Get.find<HomeViewModel>();
     if(value?.current==AppRoutes.parentView)
        WidgetsFlutterBinding.ensureInitialized()
            .waitUntilFirstFrameRasterized
            .then((value) {
              print("value");
              homeController.pageController.jumpToPage(1);
              // homeController.tabController.animateTo(1);
              homeController.update();
            });
        if(value?.current==AppRoutes.parentView)
          WidgetsFlutterBinding.ensureInitialized()
              .waitUntilFirstFrameRasterized
              .then((value) {
            print("value");
            homeController.pageController.jumpToPage(1);
            // homeController.tabController.animateTo(1);
            homeController.update();
          });
        print(value?.current);
        print(value?.args);
        print(value?.route);
        print(value?.current);
      },*/
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
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.blue,
                displayColor: Colors.blue,
              ),
        ),
        canvasColor: secondaryColor,
      ),
      unknownRoute: GetPage(
        name: '/unknown',

        page: () => LoginScreen(), // واجهة معينة لعرضها
      ),
      // home: AllExp(),
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.main,

      // home: MainScreen(),
      // home: LoginScreen(),
      // home: LoginScreen(),
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
