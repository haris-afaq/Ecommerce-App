import 'package:get/get.dart';
import '../views/splash_screen.dart';
import '../views/login_screen.dart';
import '../views/seller_home_screen.dart';
import '../views/buyer_home_screen.dart';
import '../routes/app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerHome,
      page: () => const SellerHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.buyerHome,
      page: () => const BuyerHomeScreen(),
    ),
  ];
}
// import 'package:get/get.dart';

// import '../utils/exports/views_exports.dart';
// import 'app_routes.dart';

// class AppPages {
//   static final List<GetPage> pages = [
//     GetPage(
//       name: AppRoutes.splash,
//       page: () =>  SplashScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.login,
//       page: () =>  LoginScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.register,
//       page: () =>  SignupScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.sellerHome,
//       page: () =>  SellerHomeScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.favourite,
//       page: () => FavouriteScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.buyerHome,
//       page: () =>  BuyerHomeScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.sellerOrders,
//       page: () => OrdersScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.orders,
//       page: () => OrdersHistoryScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.addProduct,
//       page: () =>  AddProductScreen(),
//     ),
//   ];
// }
