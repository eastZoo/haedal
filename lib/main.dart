import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:haedal/routes/app_pages.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
      clientId: '01uy52gfk2',
      onAuthFailed: (error) {
        print(error);
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
      ..indicatorColor = Colors.blueAccent
      ..backgroundColor = Colors.blue.shade100
      ..textColor = Colors.blueAccent
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = Colors.black.withOpacity(0.2)
      // ..indicatorSize = 30.0
      ..userInteractions = true;

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          navigationBarTheme: const NavigationBarThemeData(
            labelTextStyle: MaterialStatePropertyAll(
              TextStyle(fontSize: 14),
            ),
            iconTheme: MaterialStatePropertyAll(
              IconThemeData(size: 30, opticalSize: 50),
            ),
          ),
        ),
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
