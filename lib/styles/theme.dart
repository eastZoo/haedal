import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color(0xFFFBFBFC),
      elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.amber,
        shape: RoundedRectangleBorder(),
        textTheme: ButtonTextTheme.accent,
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        color: AppColors().mainColor,
        elevation: 0,
        titleTextStyle: const TextStyle(fontSize: 18.0),
      ),
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 10,
          indicatorColor: AppColors().subContainer,
          // iconTheme:  IconThemeData(color: AppColors().textGrey),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            return IconThemeData(
              color:
                  states == MaterialState.selected ? Colors.red : Colors.blue,
              // opacity: states ?? this.opacity,
              // shadows: shadows ?? this.shadows,
              // size: size ?? this.size,
            );
          })

          // indicatorShape: ShapeBorder.lerp( ShapeBorder., ShapeBorder.circular(50), 0.3),
          // indicatorShape:
          ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF202020),
        onPrimary: Color(0xFF505050),
        secondary: Color(0xFFBBBBBB),
        onSecondary: Color(0xFFEAEAEA),
        error: Color(0xFFF32424),
        onError: Color(0xFFF32424),
        background: Color(0xFFF1F2F3),
        onBackground: Color(0xFFFFFFFF),
        surface: Color(0xFF54B435),
        onSurface: Color(0xFF54B435),
      )
      // colorScheme: ColorScheme(
      //   background: Color(0xFFFBFBFC),
      // ),
      );
  // static final dark = ThemeData.dark().copyWith(
  //   backgroundColor: Colors.black,
  //   buttonColor: Colors.red,
  // );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displayMedium: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 26.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    displaySmall: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headlineMedium: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 17.0,
      color: Colors.black,
    ),
    headlineSmall: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontWeight: FontWeight.w500,
      fontSize: 15.0,
      color: Colors.black,
    ),
    titleLarge: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 13.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    titleMedium: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    titleSmall: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodyLarge: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodyMedium: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: const TextStyle(
      fontFamily: 'NotoSansKR',
      fontSize: 12.0,
      letterSpacing: 1.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    // headline5: TextStyle(
    //   fontFamily: 'NotoSansKR',
    //   //height: 20.0,
    //   fontSize: 13.0,
    //   fontWeight: FontWeight.bold,
    //   color: dark ? Colors.white : lightBaseText,
    // ),
    // headline6: TextStyle(
    //   fontFamily: 'NotoSansKR',
    //   //height: 20.0,
    //   fontSize: 12.0,
    //   fontWeight: FontWeight.w400,
    //   color: dark ? Colors.white : lightBaseText,
    // ),
    // subtitle1: TextStyle(
    //   fontFamily: 'NotoSansKR',
    //   //height: 20.0,
    //   fontSize: 14.0,
    //   fontWeight: FontWeight.normal,
    //   color: dark ? Colors.white : lightBaseText,
    // ),
    // subtitle2: TextStyle(
    //   fontFamily: 'NotoSansKR',
    //   //height: 20.0,
    //   fontSize: 12.0,
    //   fontWeight: FontWeight.normal,
    //   color: dark ? Colors.white : lightBaseText.withOpacity(0.5),
    // ),
    // bodyText1: TextStyle(
    //   fontFamily: 'NotoSansKR',
    //   //height: 22.0,
    //   fontSize: 14.0,
    //   fontWeight: FontWeight.normal,
    //   color: dark ? Colors.white : lightBaseText,
    // ),
    // bodyText2: TextStyle(
    //   fontFamily: 'Inter',
    //   //height: 20.0,
    //   fontSize: 12.0,
    //   fontWeight: FontWeight.normal,
    //   color: dark ? Colors.white : lightBaseText,
    // ),
    // caption: TextStyle(
    //   fontFamily: 'NotoSansKR',
    //   //height: 20.0,
    //   fontSize: 12.0,
    //   letterSpacing: 1.0,
    //   fontWeight: FontWeight.bold,
    //   color: dark ? Colors.white : lightBaseText,
    // ),
  );
}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: const Color(0xFF0072DB),
  minimumSize: const Size(88, 40),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7)),
  ),
);
