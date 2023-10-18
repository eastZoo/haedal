import 'package:get/get.dart';
import 'package:haedal/splash.dart';

part 'app_routes.dart';

// ignore: avoid_classes_with_only_static_members
class AppPages {
  // static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: "/splash",
      page: () => const SplashScreen(),
    ),
    // GetPage(
    //   name: "/login",
    //   page: () => const LoginScreen(),
    // ),
    // GetPage(
    //   name: "/splash",
    //   page: () => const SplashScreen(),
    // ),
    // GetPage(
    //   name: "/walk",
    //   page: () => const WalkMapScreen(),
    // ),
    // //test SDJ
    // GetPage(
    //   name: "/main",
    //   page: () => const MainScreen(),
    // ),
    // GetPage(
    //   name: "/addWalk",
    //   page: () => const AddWalkMapScreen(),
    // ),
    // GetPage(
    //   name: "/point",
    //   page: () => const GetPointScreen(),
    // )
  ];
}
