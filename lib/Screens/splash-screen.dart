import 'dart:async';

import 'package:bordered_text/bordered_text.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Screens/main-screen.dart';
import 'package:felexo/Services/animation-route.dart';
import 'package:felexo/Services/authentication-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:lottie/lottie.dart';
import 'package:permission/permission.dart';

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

  @override
  void initState() {
    super.initState();
    askPermission();

    controller = AnimationController(vsync: this);
    Timer(Duration(seconds: 3), () async {
      if (_auth.currentUser != null) {
        Navigator.pushAndRemoveUntil(
            context, FadeRoute(context, page: MainScreen()), (route) => false);
      } else {
        visibility = true;
        height = MediaQuery.of(context).size.height;
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
        body: Stack(children: [
      SizedBox(
        height: 10,
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: darkMode
            ? AnimatedContainer(
                duration: Duration(seconds: 3),
                curve: Curves.ease,
                height: height,
                child: Lottie.asset(
                  "assets/lottie/wavesDark.json",
                  controller: controller,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  onLoaded: (composition) {
                    controller
                      ..duration = composition.duration
                      ..forward()
                      ..addListener(() {
                        setState(() {});
                      })
                      ..addStatusListener((status) {
                        if (status == AnimationStatus.completed) {
                          controller.repeat();
                        }
                      });
                  },
                ),
              )
            : AnimatedContainer(
                duration: Duration(seconds: 3),
                curve: Curves.ease,
                height: height,
                child: Lottie.asset(
                  "assets/lottie/waves.json",
                  controller: controller,
                  fit: BoxFit.cover,
                  height: height,
                  width: MediaQuery.of(context).size.width,
                  onLoaded: (composition) {
                    controller
                      ..duration = composition.duration
                      ..forward()
                      ..addListener(() {
                        setState(() {});
                      })
                      ..addStatusListener((status) {
                        if (status == AnimationStatus.completed) {
                          controller.repeat();
                        }
                      });
                  },
                ),
              ),
      ),
      Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BorderedText(
                    strokeColor: Theme.of(context).colorScheme.primary,
                    strokeWidth: 3,
                    child: Text("Felexo",
                        style: TextStyle(
                            color: Colors.transparent, fontSize: 100)),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BorderedText(
                    strokeColor: Theme.of(context).colorScheme.primary,
                    strokeWidth: 1,
                    child: Text("A library of amazing wallpapers",
                        style:
                            TextStyle(color: Colors.transparent, fontSize: 20)),
                  ),
                ],
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
                    child: GoogleSignInButton(
                      borderRadius: 10,
                      textStyle: TextStyle(fontFamily: "Circular Bold"),
                      darkMode: darkMode,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation(iconColor),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Verifying Credentials")
                                    ],
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
    ]));
  }
}
