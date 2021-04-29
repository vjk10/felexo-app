import 'dart:async';

import 'package:felexo/Services/authentication-service.dart';
import 'package:felexo/Views/main-view.dart';
import 'package:felexo/theme/app-theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController controller;
  bool darkMode = false;
  bool visibility = false;
  User user;
  double height = 500;
  String _systemTheme;
  bool isDark = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this);
    Timer(Duration(seconds: 3), () async {
      if (_auth.currentUser != null) {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => MainView()),
            (route) => false);
      } else {
        visibility = true;
        height = MediaQuery.of(context).size.height;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.platformBrightnessOf(context) == Brightness.dark) {
      darkMode = true;
      setState(() {});
    }
    if (MediaQuery.platformBrightnessOf(context) == Brightness.light) {
      darkMode = false;
      setState(() {});
    }
  }

  // askPermission() async {
  //   // ignore: unused_local_variable
  //   List<Permissions> permissionNames =
  //       await Permission.requestPermissions([PermissionName.Storage]);
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final themeModeNotifier = Provider.of<ThemeModeNotifier>(context);
    if (MediaQuery.of(context).platformBrightness == Brightness.light) {
      isDark = false;
    }
    _systemTheme = (themeModeNotifier.getMode().toString());
    if (_systemTheme == "") {
      SharedPreferences.getInstance().then((themePrefs) async {
        String theme = themePrefs.getString("appTheme");
        if (theme == "ThemeMode.system") {
          _systemTheme = "ThemeMode.system";
        }
        if (theme == "ThemeMode.dark") {
          _systemTheme = "ThemeMode.dark";
        }
        if (theme == "ThemeMode.light") {
          _systemTheme = "ThemeMode.light";
        }
      });
    }
    if (_systemTheme != "") {
      SharedPreferences.getInstance().then((themePrefs) async {
        String theme = themePrefs.getString("appTheme");
        if (theme == "ThemeMode.system") {
          _systemTheme = "ThemeMode.system";
        }
        if (theme == "ThemeMode.dark") {
          _systemTheme = "ThemeMode.dark";
        }
        if (theme == "ThemeMode.light") {
          _systemTheme = "ThemeMode.light";
        }
      });
    }
    print(_systemTheme);
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.all(15.0),
        //     child: InkWell(
        //         onTap: () {
        //           HapticFeedback.mediumImpact();
        //           if (isDark == true) {
        //             onThemeChanged("ThemeMode.dark", themeModeNotifier);
        //           } else if (isDark == false) {
        //             onThemeChanged("ThemeMode.light", themeModeNotifier);
        //           }
        //           setState(() {});
        //         },
        //         child: Icon(Icons.brightness_4_outlined)),
        //   ),
        // ),
        Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("FELEXO",
                            style: TextStyle(
                                fontFamily: 'Theme Black',
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 80)),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: visibility,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            onPrimary: Theme.of(context).colorScheme.background,
                            elevation: 15,
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            shadowColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(1),
                            onSurface: Theme.of(context).colorScheme.secondary),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/googleIcon.png",
                              scale: 4,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("SIGN IN WITH GOOGLE")
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    content: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color:
                                            Theme.of(context).backgroundColor,
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 550,
                                            height: 5,
                                            child: LinearProgressIndicator(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Text(
                                              "VERIFYING CREDENTIALS",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 23,
                                          ),
                                          SizedBox(
                                            width: 550,
                                            height: 5,
                                            child: LinearProgressIndicator(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                          signInWithGoogle(context);
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ]),
    ));
  }

  void onThemeChanged(String val, ThemeModeNotifier themeModeNotifier) async {
    var themeModePrefs = await SharedPreferences.getInstance();
    if (val == "ThemeMode.system") {
      themeModeNotifier.setMode(ThemeMode.system);
    }
    if (val == "ThemeMode.dark") {
      themeModeNotifier.setMode(ThemeMode.dark);
    }
    if (val == "ThemeMode.light") {
      themeModeNotifier.setMode(ThemeMode.light);
    }
    themeModePrefs.setString("appTheme", val);
  }
}
