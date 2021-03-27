import 'dart:io';

import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/theme/app-theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

enum ThemeValues { dark, light, system }

class _SettingsViewState extends State<SettingsView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  String feedbackToken;
  final globalKey = GlobalKey<ScaffoldState>();
  String _systemTheme;
  bool themeBoxOpen = false;
  bool isDark = true;
  String appName;
  String packageName;
  String version;
  String buildNumber;
  TextEditingController subject = new TextEditingController();
  TextEditingController feedback = new TextEditingController();
  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = _auth.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      key: globalKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings", style: Theme.of(context).textTheme.headline6),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Felexo",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'Circular Black',
                      fontSize: 40),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Powered by Pexels",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'Circular Bold'),
                ),
              ],
            ),
            // SizedBox(
            //   height: 30,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       BorderedText(
            //         strokeColor: Theme.of(context).colorScheme.primary,
            //         strokeWidth: 3,
            //         child: Text(
            //           "Appearance",
            //           style: TextStyle(
            //               color: Theme.of(context).colorScheme.secondary,
            //               fontFamily: 'Circular Black',
            //               fontSize: 16),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // // SizedBox(
            // //   height: 20,
            // // ),
            // ListTile(
            //   leading: Icon(Icons.palette_outlined, size: 30, color: iconColor),
            //   title: Text("Select Theme"),
            //   subtitle: Text(
            //     "Choose your app theme here.",
            //     style: TextStyle(fontSize: 12),
            //   ),
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //               title: Text("Choose Theme"),
            //               content: Container(
            //                 width: 200,
            //                 height: 145,
            //                 child: Column(
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Radio(
            //                           activeColor:
            //                               Theme.of(context).accentColor,
            //                           value: 'ThemeMode.system',
            //                           groupValue: _systemTheme,
            //                           onChanged: (val) {
            //                             HapticFeedback.mediumImpact();
            //                             _systemTheme = val;
            //                             onThemeChanged(val, themeModeNotifier);
            //                             setState(() {});
            //                           },
            //                         ),
            //                         SizedBox(width: 10),
            //                         Text("System Default")
            //                       ],
            //                     ),
            //                     Row(
            //                       children: [
            //                         Radio(
            //                           activeColor:
            //                               Theme.of(context).accentColor,
            //                           value: 'ThemeMode.dark',
            //                           groupValue: _systemTheme,
            //                           onChanged: (val) {
            //                             HapticFeedback.mediumImpact();

            //                             _systemTheme = val;
            //                             onThemeChanged(val, themeModeNotifier);
            //                             setState(() {});
            //                           },
            //                         ),
            //                         SizedBox(width: 10),
            //                         Text("Dark")
            //                       ],
            //                     ),
            //                     Row(
            //                       children: [
            //                         Radio(
            //                           activeColor:
            //                               Theme.of(context).accentColor,
            //                           value: 'ThemeMode.light',
            //                           groupValue: _systemTheme,
            //                           onChanged: (val) {
            //                             HapticFeedback.mediumImpact();

            //                             _systemTheme = val;
            //                             onThemeChanged(val, themeModeNotifier);
            //                             setState(() {});
            //                           },
            //                         ),
            //                         SizedBox(width: 10),
            //                         Text("Light")
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ));
            //   },
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BorderedText(
                    strokeColor: Theme.of(context).colorScheme.primary,
                    strokeWidth: 3,
                    child: Text(
                      "General",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Circular Black',
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            ListTile(
              title: Text("Clear Cache"),
              leading: Icon(
                Icons.delete_outline_outlined,
                size: 30,
                color: iconColor,
              ),
              subtitle: Text(
                "Clear cache if you want slower load times ;)",
                style: TextStyle(fontSize: 12),
              ),
              onTap: () async {
                HapticFeedback.mediumImpact();
                var appDir =
                    (await getTemporaryDirectory()).path + '/com.vlabs.felexo';
                new Directory(appDir).delete(recursive: true)
                  ..whenComplete(() =>
                      // ignore: deprecated_member_use
                      globalKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          "Cache Deleted!",
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      )));
                print(appDir);
                print("Clicked");
              },
            ),
            // SizedBox(
            //   height: 30,
            // ),
            ListTile(
              leading: Icon(
                Icons.feedback_outlined,
                size: 30,
                color: iconColor,
              ),
              title: Text("Feedback"),
              subtitle: Text(
                "Give us all the best feedback you can to improve the exprience",
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                HapticFeedback.mediumImpact();
                feedbackForm();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BorderedText(
                    strokeColor: Theme.of(context).colorScheme.primary,
                    strokeWidth: 3,
                    child: Text(
                      "App Info",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Circular Black',
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            ListTile(
              leading: Icon(
                Icons.build_circle_outlined,
                size: 30,
                color: iconColor,
              ),
              title: Text("Build Number"),
              subtitle: Text(
                "1.0.0",
                style: TextStyle(fontSize: 12),
              ),
            ),
            // SizedBox(
            //   height: 30,
            // ),
            ListTile(
              leading: Icon(
                Icons.code,
                size: 30,
                color: iconColor,
              ),
              title: Text("Application ID"),
              subtitle: Text(
                "com.vlabs.felexo",
                style: TextStyle(fontSize: 12),
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            ListTile(
              leading: Icon(
                Icons.info_outline_rounded,
                size: 30,
                color: iconColor,
              ),
              title: Text("About and Credits"),
              subtitle: Text(
                "Licenses",
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                HapticFeedback.mediumImpact();
                showAboutDialog(
                    context: context,
                    applicationName: "Felexo",
                    applicationVersion: "1.0.0",
                    applicationLegalese:
                        "Owned and developed by Vishnu Jayakumar",
                    applicationIcon: Image.asset(
                      "assets/images/ic_launcher-playstore.png",
                      width: 50,
                      height: 50,
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  void feedbackForm() {
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) => ExpandableBottomSheet(
              persistentContentHeight: MediaQuery.of(context).size.height / 2,
              expandableContent: Container(
                width: MediaQuery.of(context).size.width,
                height: 640,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.maximize,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Form(
                      child: Theme(
                        data: ThemeData(
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          textTheme: TextTheme(
                            bodyText1: Theme.of(context).textTheme.bodyText1,
                            headline1: Theme.of(context).textTheme.headline1,
                            subtitle1: Theme.of(context).textTheme.subtitle1,
                            subtitle2: Theme.of(context).textTheme.subtitle2,
                            bodyText2: Theme.of(context).textTheme.bodyText2,
                            caption: Theme.of(context).textTheme.caption,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: iconColor, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: iconColor, width: 1)),
                              counterStyle: TextStyle(color: iconColor),
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontFamily: 'Circular Black')),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 15.0, left: 15),
                              child: Material(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: TextFormField(
                                  controller: subject,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                      labelText: "Subject",
                                      prefixIcon: Icon(
                                        Icons.subject,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 15.0, left: 15),
                              child: Material(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: TextFormField(
                                  controller: feedback,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: null,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                      labelText: "Feedback",
                                      prefixIcon: Icon(
                                        Icons.feedback,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 100,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: () async {
                                  feedbackToken =
                                      "#" + randomAlphaNumeric(5).toString();
                                  await FirebaseFirestore.instance
                                      .collection("Feedbacks")
                                      .doc(feedbackToken)
                                      .set({
                                    "uid": user.uid,
                                    "email": user.email,
                                    "name": user.displayName,
                                    "subject": subject.text,
                                    "feedback": feedback.text
                                  });
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "OK",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button,
                                                ),
                                              )
                                            ],
                                            content: Text(
                                              "Your feedback is received and you can refer back to it by using the token: " +
                                                  feedbackToken,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Send",
                                      style: TextStyle(
                                          color: textColor,
                                          fontFamily: 'Circular Bold'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.send,
                                      color: textColor,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              background: Container(
                color: Colors.transparent,
              ),
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
