import 'package:flutter/material.dart';

abstract class GeneralConfig {
  static const DefaultAppName = "Amigo Tools";
  static const AppLogo = "logo_amigotools.png";

  static const AssetImagesPath = "assets/images";
  static const TranslationsPath = "assets/i18n";

  static const SupportedLocales = const [
    Locale("en"), // default, should be first
    Locale("da"),
    Locale("ru"),
    Locale("sv"),
  ];

  static final palette2Primary = MaterialColor(0xFF0A558C, {
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    50: Color(0xFFDCEEFB),
    100: Color(0xFFB6E0FE7),
    200: Color(0xFF84C5F4),
    300: Color(0xFF62B0E8),
    400: Color(0xFF4098D7),
    500: Color(0xFF2680C2),
    600: Color(0xFF186FAF),
    700: Color(0xFF0F609B),
    800: Color(0xFF0A558C),
    900: Color(0xFF003E6B),
  });

  static final palette2Primary2 = MaterialColor(0xFFB44D12, {
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    50: Color(0xFFFFFBEA),
    100: Color(0xFFFFF3C4),
    200: Color(0xFFFCE588),
    300: Color(0xFFFADB5F),
    400: Color(0xFFF7C948),
    500: Color(0xFFF0B429),
    600: Color(0xFFDE911D),
    700: Color(0xFFCB6E17),
    800: Color(0xFFB44D12),
    900: Color(0xFF8D2B0B),
  });

  static final palette2Neutrals = MaterialColor(0xFF829AB1, {
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    0: Color(0xFFFFFFFF),
    50: Color(0xFFF0F4F8),
    100: Color(0xFFD9E2EC),
    200: Color(0xFFBCCCDC), //border
    300: Color(0xFF9FB3C8),
    400: Color(0xFF829AB1),
    500: Color(0xFF627D98),
    600: Color(0xFF486581),
    700: Color(0xFF334E68),
    800: Color(0xFF243B53),
    900: Color(0xFF102A43),
  });

  static final palette2SupportingCyan = MaterialColor(0xFF38BEC9, {
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    50: Color(0xFFE0FCFF),
    100: Color(0xFFBEF8FD),
    200: Color(0xFF87EAF2),
    300: Color(0xFF54D1DB),
    400: Color(0xFF38BEC9),
    500: Color(0xFF2CB1BC),
    600: Color(0xFF14919B),
    700: Color(0xFF0E7C86),
    800: Color(0xFF0A6C74),
    900: Color(0xFF044E54),
  });

  static final palette2SupportingRed = MaterialColor(0xFFD64545, {
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    50: Color(0xFFFFEEEE),
    100: Color(0xFFFACDCD),
    200: Color(0xFFF29B9B),
    300: Color(0xFFE66A6A),
    400: Color(0xFFD64545),
    500: Color(0xFFBA2525),
    600: Color(0xFFA61B1B),
    700: Color(0xFF911111),
    800: Color(0xFF780A0A),
    900: Color(0xFF610404),
  });
  static const palette2Primary50 = const Color(0xFFDCEEFB);
  static const palette2Primary400 = const Color(0xFF4098D7);
  static const palette2Primary600 = const Color(0xFF186FAF);
  static const palette2Primary800 = const Color(0xFF0A558C);

  static const palette2Primary2100 = const Color(0xFFFFF3C4);
  static const palette2Primary2300 = const Color(0xFFFADB5F);
  static const palette2Primary2600 = const Color(0xFFDE911D);
  static const palette2Primary2900 = const Color(0xFF8D2B0B);

  static const palette2Neutrals0 = const Color(0xFFFFFFFF);
  static const palette2Neutrals50 = const Color(0xFFF0F4F8);
  static const palette2Neutrals100 = const Color(0xFFD9E2EC);
  static const palette2Neutrals200 = const Color(0xFFBCCCDC); //border
  static const palette2Neutrals300 = const Color(0xFF9FB3C8);
  static const palette2Neutrals500 = const Color(0xFF627D98);
  static const palette2Neutrals900 =
      const Color(0xFF102A43); //labels, main text color

  static const palette2SupportingCyan50 = const Color(0xFFE0FCFF);
  static const palette2SupportingCyan400 = const Color(0xFF38BEC9);
  //accent
  static const palette2SupportingRed100 = const Color(0xFFFACDCD);
  static const palette2SupportingRed700 = const Color(0xFF911111); //error

}
