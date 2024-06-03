import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:haedal/routes/app_pages.dart';
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
              fontFamily: 'Pretendard', primaryColor: AppColors().mainColor),
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
          },
        );
      },
    );
  }
}
