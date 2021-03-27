import 'package:felexo/Color/colors.dart';
import 'package:felexo/Services/authentication-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission/permission.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool darkMode = false;

  @override
  void initState() {
    askPermission();
    controller = AnimationController(vsync: this);

    super.initState();
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

  askPermission() async {
    // ignore: unused_local_variable
    List<Permissions> permissionNames =
        await Permission.requestPermissions([PermissionName.Storage]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
                    ElevatedButton(
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
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 550,
                                          height: 5,
                                          child: LinearProgressIndicator(
                                              backgroundColor: Theme.of(context)
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
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Text(
                                            "VERIFYING CREDENTIALS",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 23,
                                        ),
                                        SizedBox(
                                          width: 550,
                                          height: 5,
                                          child: LinearProgressIndicator(
                                              backgroundColor: Theme.of(context)
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
                  ],
                )
              ],
            )),
      ]),
    ));
  }
}
