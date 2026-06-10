import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled/controllers/auth_controller.dart';
import 'package:untitled/controllers/theme_controller.dart';
import 'package:untitled/routes/app_pages.dart';
import 'package:untitled/routes/app_routes.dart';
import 'managers/strings_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage first
  await GetStorage.init();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Register controllers AFTER all initializations
  // Make sure ThemeController doesn't use GetStorage immediately
  Get.put(ThemeController(), permanent: true);
  Get.put(AuthenticateController(), permanent: true);
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Safe way to get controller
    final ThemeController themeController;
    if (Get.isRegistered<ThemeController>()) {
      themeController = Get.find<ThemeController>();
    } else {
      themeController = Get.put(ThemeController(), permanent: true);
    }
    
    return GetMaterialApp(
      title: StringsManager.appName,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.themeMode,
    );
  }
}
// class MyApp extends StatelessWidget {
//   MyApp({super.key});

//   final themeController = Get.find<ThemeController>();

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: StringsManager.appName,
//       debugShowCheckedModeBanner: false,
//       smartManagement: SmartManagement.full,
//       initialRoute: AppRoutes.splash,
//       getPages: AppPages.pages,
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: themeController.themeMode,
//     );
//   }
// }
