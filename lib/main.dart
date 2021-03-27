import 'package:felexo/Screens/splash-screen.dart';
import 'package:felexo/theme/app-theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]).then((_) {
    SharedPreferences.getInstance().then((themePrefs) async {
      String theme = themePrefs.getString("appTheme");
      ThemeMode prefTheme;
      if (theme == "ThemeMode.system") {
        prefTheme = ThemeMode.system;
      }
      if (theme == "ThemeMode.dark") {
        prefTheme = ThemeMode.dark;
      }
      if (theme == "ThemeMode.light") {
        prefTheme = ThemeMode.light;
      }
      await Firebase.initializeApp();
      runApp(
        ChangeNotifierProvider<ThemeModeNotifier>(
          create: (_) => ThemeModeNotifier(prefTheme),
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeModeNotifier = Provider.of<ThemeModeNotifier>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Felexo',
        darkTheme: darkTheme,
        theme: lightTheme,
        // themeMode: themeModeNotifier.getMode(),
        themeMode: ThemeMode.system,
        home: SplashScreen());
  }
}
