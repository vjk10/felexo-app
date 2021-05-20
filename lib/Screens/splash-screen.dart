import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felexo/Services/authentication-service.dart';
import 'package:felexo/Views/main-view.dart';
import 'package:felexo/theme/app-theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission/permission.dart';
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
  double elevationValue = 15;
  bool darkMode = false;
  bool visibility = false;
  User user;
  String _systemTheme;
  bool isDark = true;
  final fsref = FirebaseStorage.instance.ref();
  var googleIcon;

  @override
  initState() {
    super.initState();
    getIcon();
    setState(() {});
    askPermission();
    Timer(Duration(seconds: 3), () async {
      if (_auth.currentUser != null) {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => MainView()),
            (route) => false);
      } else {
        visibility = true;
        setState(() {});
      }
    });
  }

  getIcon() async {
    await fsref.child('googleIcon.png').getDownloadURL().then((value) {
      setState(() {
        googleIcon = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  askPermission() async {
    List<Permissions> permissionNames =
        await Permission.requestPermissions([PermissionName.Storage]);
    return permissionNames;
  }

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
        Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 10,
                  shadowColor: Theme.of(context).colorScheme.primary,
                  child: Container(
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 80)),
                        ],
                      )),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: visibility,
                      child: Container(
                        width: 230,
                        height: 60,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              onPrimary:
                                  Theme.of(context).colorScheme.background,
                              elevation: elevationValue,
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              shadowColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(1),
                              onSurface:
                                  Theme.of(context).colorScheme.secondary),
                          icon: CachedNetworkImage(
                            placeholder: (context, googleIcon) {
                              return Container(
                                width: 24,
                                height: 24,
                              );
                            },
                            imageUrl: googleIcon.toString(),
                            height: 24,
                            fadeInCurve: Curves.easeIn,
                            fadeInDuration: const Duration(milliseconds: 500),
                          ),
                          label: Row(children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text("SIGN IN WITH GOOGLE")
                          ]),
                          onPressed: () {
                            showDialog(
                                useSafeArea: true,
                                context: context,
                                builder: (context) => AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Visibility(
                //       visible: visibility,
                //       child: Container(
                //         width: 230,
                //         height: 60,
                //         child: ElevatedButton.icon(
                //           style: ElevatedButton.styleFrom(
                //             primary: Theme.of(context).colorScheme.secondary,
                //             onSurface: Theme.of(context).colorScheme.primary,
                //             elevation: 15,
                //             padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.zero),
                //             shadowColor: Theme.of(context)
                //                 .colorScheme
                //                 .primary
                //                 .withOpacity(1),
                //           ),
                //           icon: Text(
                //             "F",
                //             style: TextStyle(
                //                 fontSize: 24,
                //                 fontFamily: 'Theme Black',
                //                 color: Theme.of(context).colorScheme.primary),
                //           ),
                //           label: Row(
                //             children: [
                //               SizedBox(
                //                 width: 10,
                //               ),
                //               Text(
                //                 "SIGN IN WITH FELEXO",
                //                 style: TextStyle(
                //                     fontFamily: 'Theme Bold',
                //                     color:
                //                         Theme.of(context).colorScheme.primary),
                //               ),
                //             ],
                //           ),
                //           onPressed: () {},
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
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
