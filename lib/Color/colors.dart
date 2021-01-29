import 'dart:ui';

import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor backgroundColor = MaterialColor(0xFF000000, color);
MaterialColor primaryColor = MaterialColor(0xFFFFFFFF, color);
MaterialColor cardColor = MaterialColor(0xFF000000, color);
MaterialColor cardColorLight = MaterialColor(0xFFF5F5F5, color);
MaterialColor buttonColor = MaterialColor(0xFF7074DB, color);
MaterialColor textColor = MaterialColor(0xFFFFFFFF, color);
MaterialColor iconColor = MaterialColor(0xFF7074DB, color);
MaterialColor wallpaperColor = MaterialColor(0xFF2C0E5C, color);
