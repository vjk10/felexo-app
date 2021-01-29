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
      color: cardColor,
      textTheme: TextTheme(
        headline1: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        headline2: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        headline3: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        headline4: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        headline5: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        headline6: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        subtitle1: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        subtitle2: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        bodyText1: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        bodyText2: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        caption: TextStyle(color: textColor, fontFamily: 'Circular Black'),
        button: TextStyle(color: textColor, fontFamily: 'Circular Black'),
      ),
      iconTheme: IconThemeData(color: iconColor)),
  colorScheme: ColorScheme.dark(
    primary: textColor,
    secondary: cardColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    labelStyle: TextStyle(color: textColor, fontFamily: 'Circular Black'),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    headline2: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    headline3: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    headline4: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    headline5: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    headline6: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    subtitle1: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    subtitle2: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    bodyText1: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    bodyText2: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    caption: TextStyle(color: textColor, fontFamily: 'Circular Black'),
    button: TextStyle(color: textColor, fontFamily: 'Circular Black'),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData lightTheme = ThemeData(
  canvasColor: Colors.white,
  cardColor: Colors.white,
  dialogBackgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  accentColor: iconColor,
  primaryColor: Colors.white,
  primaryColorDark: Colors.black,
  appBarTheme: AppBarTheme(
      centerTitle: true,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        headline2: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        headline3: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        headline4: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        headline5: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        headline6: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        subtitle1: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        subtitle2: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        bodyText1: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        bodyText2: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        caption: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
        button: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
      ),
      color: cardColorLight,
      iconTheme: IconThemeData(color: iconColor)),
  colorScheme: ColorScheme.light(
    primary: cardColor,
    secondary: textColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    labelStyle: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    headline2: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    headline3: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    headline4: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    headline5: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    headline6: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    subtitle1: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    subtitle2: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    bodyText1: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    bodyText2: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    caption: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
    button: TextStyle(color: Colors.black, fontFamily: 'Circular Black'),
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
