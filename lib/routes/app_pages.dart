import 'package:get/get.dart';
import 'package:haedal/screens/login_screen.dart';
import 'package:haedal/screens/register_screen/code_screen.dart';
import 'package:haedal/screens/register_screen/signup_screen.dart';
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
    GetPage(
      name: "/login",
      page: () => LoginScreen(),
    ),
    GetPage(
      name: "/signup",
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: "/code",
      page: () => const CodeScreen(),
    ),
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
