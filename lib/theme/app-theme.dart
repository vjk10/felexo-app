import 'package:felexo/Color/colors.dart';
import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  canvasColor: Colors.black,
  cardColor: Colors.black,
  dialogBackgroundColor: Colors.black,
  scaffoldBackgroundColor: backgroundColor,
  backgroundColor: Colors.black,
  accentColor: iconColor,
  primaryColor: Colors.black,
  primaryColorDark: Colors.white,
  appBarTheme: AppBarTheme(
      centerTitle: true,
      color: Colors.black,
      textTheme: TextTheme(
        headline1: TextStyle(color: textColor, fontFamily: 'Theme Black'),
        headline2: TextStyle(color: textColor, fontFamily: 'Theme Black'),
        headline3: TextStyle(color: textColor, fontFamily: 'Theme Black'),
        headline4: TextStyle(color: textColor, fontFamily: 'Theme Black'),
        headline5: TextStyle(color: textColor, fontFamily: 'Theme Black'),
        headline6: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
        subtitle1: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
        subtitle2: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
        bodyText1: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
        bodyText2: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
        caption: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
        button: TextStyle(color: textColor, fontFamily: 'Theme Bold'),
      ),
      iconTheme: IconThemeData(color: iconColor)),
  colorScheme: ColorScheme.dark(
    primary: textColor,
    secondary: cardColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: textColor, fontFamily: 'Theme Bold'),
    labelStyle: TextStyle(color: textColor, fontFamily: 'Theme Bold'),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(color: textColor, fontFamily: 'Theme Black'),
    headline2: TextStyle(color: textColor, fontFamily: 'Theme Black'),
    headline3: TextStyle(color: textColor, fontFamily: 'Theme Black'),
    headline4: TextStyle(color: textColor, fontFamily: 'Theme Black'),
    headline5: TextStyle(color: textColor, fontFamily: 'Theme Black'),
    headline6: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
    subtitle1: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
    subtitle2: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
    bodyText1: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
    bodyText2: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
    caption: TextStyle(color: textColor, fontFamily: 'Theme Regular'),
    button: TextStyle(color: textColor, fontFamily: 'Theme Bold'),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData lightTheme = ThemeData(
  canvasColor: Colors.white,
  cardColor: Colors.white,
  dialogBackgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  accentColor: iconColorLight,
  primaryColor: Colors.white,
  primaryColorDark: Colors.black,
  appBarTheme: AppBarTheme(
      centerTitle: true,
      color: Colors.white,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
        headline2: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
        headline3: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
        headline4: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
        headline5: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
        headline6: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
        subtitle1: TextStyle(color: Colors.black, fontFamily: 'Theme Bold'),
        subtitle2: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
        bodyText1: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
        bodyText2: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
        caption: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
        button: TextStyle(color: Colors.black, fontFamily: 'Theme Bold'),
      ),
      iconTheme: IconThemeData(color: iconColor)),
  colorScheme: ColorScheme.light(
    primary: cardColor,
    secondary: textColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.black, fontFamily: 'Theme Bold'),
    labelStyle: TextStyle(color: Colors.black, fontFamily: 'Theme Bold'),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
    headline2: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
    headline3: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
    headline4: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
    headline5: TextStyle(color: Colors.black, fontFamily: 'Theme Black'),
    headline6: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
    subtitle1: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
    subtitle2: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
    bodyText1: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
    bodyText2: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
    caption: TextStyle(color: Colors.black, fontFamily: 'Theme Regular'),
    button: TextStyle(color: Colors.black, fontFamily: 'Theme Bold'),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

class ThemeModeNotifier with ChangeNotifier {
  ThemeMode _mode;

  ThemeModeNotifier(this._mode);

  getMode() => _mode;

  setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
  }
}
