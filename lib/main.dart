import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:haedal/routes/app_pages.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// 테스트 앱키 ( 동의항목 전체 오픈 )
  KakaoSdk.init(nativeAppKey: 'e328e398b5297ab57d81161144651db9');
  // KakaoSdk.init(nativeAppKey: '67241b40f1430b89dee5326a15b225ec');
  await NaverMapSdk.instance.initialize(
      clientId: '01uy52gfk2',
      onAuthFailed: (error) {
        print("NAVER AUTH ERROR :  $error");
      });
  await dotenv.load(fileName: 'assets/config/.env');

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorColor = Colors.white
      ..backgroundColor = Colors.white
      ..textColor = Colors.blueAccent
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = Colors.black.withOpacity(0.2)
      // ..indicatorSize = 30.0
      ..userInteractions = true;

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Pretendard',
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
        builder: (context, child) {
          child = EasyLoading.init()(context, child);
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child,
          );
        });
  }
}
