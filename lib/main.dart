import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:haedal/routes/app_pages.dart';
import 'package:haedal/service/controller/alarm_controller.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/controller/home_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // 테스트 앱키 ( 동의항목 전체 오픈 )
  KakaoSdk.init(nativeAppKey: '${dotenv.env['KAKAO_NATIVE_API_KEY']}');
  await NaverMapSdk.instance.initialize(
      clientId: '${dotenv.env['NAVER_CLIENT_ID']}',
      onAuthFailed: (error) {
        print("NAVER AUTH ERROR :  $error");
      });
  Get.put(AuthController());
  Get.put(HomeController());
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Pretendard',
            cupertinoOverrideTheme: CupertinoThemeData(
              primaryColor: AppColors().mainColor,
            ),
            primaryColor: AppColors().mainColor,
            appBarTheme: AppBarTheme(backgroundColor: AppColors().white),
            scaffoldBackgroundColor: AppColors().white,
            radioTheme: RadioThemeData(
                fillColor: WidgetStateProperty.all(AppColors().mainColor)),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: AppColors().mainColor),
              bodyMedium: TextStyle(color: AppColors().mainColor),
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('ko', ''), // Korean, no country code
          ],
          locale: const Locale('ko'),
          enableLog: true,
          logWriterCallback: (String text, {bool isError = false}) {
            Future.microtask(() => print('** $text. isError: [$isError]'));
          },
          initialRoute: "/splash",
          getPages: AppPages.routes,
          navigatorObservers: [MyNavigatorObserver()], // 여기 추가
          builder: (context, child) {
            // EasyLoading 적용 및 전역 로깅 추가
            child = EasyLoading.init()(context, child);

            // 전역 로깅을 위한 코드 추가
            print("App state changed or screen transitioned");

            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child,
            );
          },
        );
      },
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  final AlarmController alarmCon = Get.find<AlarmController>();
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    // 페이지가 푸시될 때마다 실행될 코드
    print("Navigator: Pushed ${route.settings.name}");
    alarmCon.getNotiData();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // 페이지가 팝될 때마다 실행될 코드
    print("Navigator: Popped ${route.settings.name}");
    alarmCon.getNotiData();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    // 페이지가 교체될 때마다 실행될 코드
    print(
        "Navigator: Replaced ${oldRoute?.settings.name} with ${newRoute?.settings.name}");
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    // 페이지가 제거될 때마다 실행될 코드
    print("Navigator: Removed ${route.settings.name}");
  }
}
