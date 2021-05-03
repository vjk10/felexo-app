import 'package:cached_network_image/cached_network_image.dart';
import 'package:felexo/Data/data.dart';
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
    askStoragePermission();
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

  askStoragePermission() async {
    List<Permissions> permissionStorage =
        await Permission.requestPermissions([PermissionName.Storage]);

    print(permissionStorage.map((e) {
      print("StoragePermission " + e.permissionStatus.toString());
    }));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
                    Container(
                      width: 230,
                      height: 60,
                      child: ElevatedButton.icon(
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
                        icon: CachedNetworkImage(
                          placeholder: (context, googleIcon) {
                            return Container(
                              width: 24,
                              height: 24,
                            );
                          },
                          imageUrl: googleIcon,
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
}
