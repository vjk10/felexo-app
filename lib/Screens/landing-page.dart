import 'package:bordered_text/bordered_text.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Services/authentication-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:lottie/lottie.dart';
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
        body: Stack(children: [
      Align(
        alignment: Alignment.bottomCenter,
        child: darkMode
            ? Lottie.asset(
                "assets/lottie/wavesDark.json",
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                controller: controller,
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
              )
            : Lottie.asset(
                "assets/lottie/waves.json",
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                animate: true,
                controller: controller,
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
                  GoogleSignInButton(
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
                ],
              )
            ],
          )),
    ]));
  }
}
