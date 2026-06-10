import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/managers/colors_manager.dart';
import 'package:untitled/managers/fonts_manager.dart';
import 'package:untitled/managers/strings_manager.dart';
import 'package:untitled/managers/values_manager.dart';
import 'package:untitled/routes/app_routes.dart';
import 'package:untitled/widgets/custom_text.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthenticateController authController;

  @override
  void initState() {
    super.initState();
    
    // Safe way to get controller with fallback
    if (Get.isRegistered<AuthenticateController>()) {
      authController = Get.find<AuthenticateController>();
    } else {
      authController = Get.put(AuthenticateController(), permanent: true);
    }
    
    // Use Timer instead of Future.delayed for better reliability
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        try {
          authController.checkLoginStatus();
        } catch (e) {
          print("Error checking login status: $e");
          // Fallback navigation
          Get.offAllNamed(AppRoutes.login);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: ColorsManager.secondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              color: isDarkMode
                  ? DarkColorsManager.primaryColor
                  : ColorsManager.whiteColor,
              size: SizeManager.sizeXL * 8,
            ),
            Txt(
              text: StringsManager.appName,
              color: isDarkMode
                  ? DarkColorsManager.primaryColor.withOpacity(0.8)
                  : ColorsManager.whiteColor.withOpacity(0.8),
              fontFamily: FontsManager.fontFamilyPoppins,
              fontSize: FontSize.headerFontSize * 1.5,
              fontWeight: FontWeightManager.bold,
            ),
          ],
        ),
      ),
    );
  }
}
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../controllers/auth_controller.dart';
// import '../utils/exports/managers_exports.dart';
// import '../widgets/custom_text.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   static const String routeName = '/splashScreen';

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   late final AuthenticateController authController;

// @override
// void initState() {
//   super.initState();

//   authController = Get.isRegistered<AuthenticateController>()
//       ? Get.find<AuthenticateController>()
//       : Get.put(
//           AuthenticateController(),
//           permanent: true,
//         );

//   Timer(
//     const Duration(seconds: 2),
//     () {
//       if (mounted) {
//         authController.checkLoginStatus();
//       }
//     },
//   );
// }
//   // @override
//   // void initState() {
//   //   super.initState();

//   //   authController = Get.isRegistered<AuthenticateController>()
//   //       ? Get.find<AuthenticateController>()
//   //       : Get.put(
//   //           AuthenticateController(),
//   //           permanent: true,
//   //         );

//   //   Timer(const Duration(seconds: 2), () {
//   //     if (mounted) {
//   //       authController.checkLoginStatus();
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode =
//         Theme.of(context).brightness == Brightness.dark;

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ColorsManager.secondaryColor,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.shopping_cart,
//                 color: isDarkMode
//                     ? DarkColorsManager.primaryColor
//                     : ColorsManager.whiteColor,
//                 size: SizeManager.sizeXL * 8,
//               ),
//               Txt(
//                 text: StringsManager.appName,
//                 color: isDarkMode
//                     ? DarkColorsManager.primaryColor.withOpacity(0.8)
//                     : ColorsManager.whiteColor.withOpacity(0.8),
//                 fontFamily: FontsManager.fontFamilyPoppins,
//                 fontSize: FontSize.headerFontSize * 1.5,
//                 fontWeight: FontWeightManager.bold,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
