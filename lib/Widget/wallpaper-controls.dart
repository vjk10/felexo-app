import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:felexo/Color/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

const String testDevices = "10541B246DA05AC314ED0A170DA2B594";

String home = "Home Screen";
String lock = "Lock Screen";
String both = "Both Screen";
String system = "System";
String res;
String pexelsText = "Wallpapers Provided by Pexels";
bool deletingFav = false;
bool downloading = false;
bool setWall = false;
User user;
String wallpaperLocation;

// ignore: must_be_immutable
class WallpaperControls extends StatefulWidget {
  final String imgUrl,
      photoID,
      photographer,
      photographerID,
      originalUrl,
      photographerUrl,
      uid,
      avgColor;
  var foregroundColor;
  bool favExists;
  WallpaperControls(
      {@required this.uid,
      @required this.imgUrl,
      @required this.originalUrl,
      @required this.photoID,
      @required this.photographer,
      @required this.photographerID,
      @required this.photographerUrl,
      @required this.avgColor,
      @required this.favExists,
      @required this.foregroundColor});
  @override
  _WallpaperControlsState createState() => _WallpaperControlsState();
}

class _WallpaperControlsState extends State<WallpaperControls> {
  bool _permissionStatus;
  double progressValue;
  String progressString = "0%";

  @override
  void initState() {
    downloading = false;
    checkPermissionStatus();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initUser() async {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    print("User: " + user.uid.toString());
    setState(() {});
  }

  checkPermissionStatus() async {
    List<Permissions> permissions =
        await Permission.getPermissionsStatus([PermissionName.Storage]);
    print("PERMISSION STATUS");
    print(permissions.map((e) {
      print(e.permissionStatus);
      if (e.permissionStatus == PermissionStatus.allow) {
        _permissionStatus = true;
        setState(() {});
      }
      if (e.permissionStatus == PermissionStatus.deny) {
        _permissionStatus = false;
        setState(() {});
      }
      if (e.permissionStatus == PermissionStatus.notAgain) {
        _permissionStatus = false;
        setState(() {});
      }
    }));
    print(_permissionStatus);
  }

  askPermission() async {
    // ignore: unused_local_variable
    List<Permissions> permissionNames =
        await Permission.requestPermissions([PermissionName.Storage]);
    checkPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return downloading
        ? Padding(
            padding: const EdgeInsets.only(top: 54.0, bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 280,
                      height: 5,
                      child: LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor:
                            Theme.of(context).colorScheme.primary.withAlpha(80),
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      progressString,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "DOWNLOADING...",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container(
            width: 250,
            height: 85,
            color: Colors.transparent,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: GestureDetector(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Hexcolor(widget.avgColor),
                                            blurRadius: 20,
                                            spreadRadius: 10),
                                      ],
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  child: Icon(
                                    Icons.save,
                                    size: 25,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  showDialog(
                                      context: context,
                                      useSafeArea: true,
                                      builder: (context) => AlertDialog(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          elevation: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                          title: Text(
                                            "SELECT SIZE",
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          content: Container(
                                            height: 80,
                                            child: ClipRRect(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.smartphone,
                                                          size: 30,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "PORTRAIT",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Theme Bold',
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary),
                                                        )
                                                      ],
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _save(widget.imgUrl,
                                                          _permissionStatus);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .photo_size_select_actual_outlined,
                                                            size: 30,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "ORIGINAL",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Theme Bold',
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary),
                                                        )
                                                      ],
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _save(widget.originalUrl,
                                                          _permissionStatus);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )));
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Hexcolor(widget.avgColor),
                                          blurRadius: 20,
                                          spreadRadius: 10),
                                      // BoxShadow(
                                      //   color: Theme.of(context).scaffoldBackgroundColor,
                                      //   blurRadius: 15,
                                      //   spreadRadius: 5,
                                      // )
                                    ],
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.wallpaper,
                                    size: 25,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    title: Text("SELECT A LOCATION",
                                        style:
                                            Theme.of(context).textTheme.button),
                                    content: Container(
                                      height: 100,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextButton(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.home_outlined,
                                                    size: 30,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  Text(
                                                    "HOME\nSCREEN",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Theme Bold',
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                  )
                                                ],
                                              ),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                downloading = true;

                                                setState(() {});
                                                Future.delayed(
                                                    Duration(seconds: 1), () {
                                                  saveWallpaper(WallpaperManager
                                                      .HOME_SCREEN);
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextButton(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Icon(Icons.lock_outlined,
                                                      size: 30,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                                  Text(
                                                    "LOCK\nSCREEN",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Theme Bold',
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                  )
                                                ],
                                              ),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                downloading = true;

                                                setState(() {});
                                                Future.delayed(
                                                    Duration(seconds: 1), () {
                                                  saveWallpaper(WallpaperManager
                                                      .LOCK_SCREEN);
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 0),
                                            child: TextButton(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Icon(
                                                      Icons.smartphone_outlined,
                                                      size: 30,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                                  Text(
                                                    "BOTH\nSCREEN",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Theme Bold',
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                  )
                                                ],
                                              ),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                downloading = true;
                                                setState(() {});
                                                Future.delayed(
                                                    Duration(seconds: 1), () {
                                                  saveWallpaper(WallpaperManager
                                                      .BOTH_SCREENS);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )));
                          },
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Hexcolor(widget.avgColor),
                                          blurRadius: 20,
                                          spreadRadius: 10),
                                    ],
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    widget.favExists
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 25,
                                    color: widget.favExists
                                        ? Colors.redAccent
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: () async {
                            if (widget.favExists == true) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Favorites"),
                                        content:
                                            Text("Already added to Favorites!"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Ok"),
                                          )
                                        ],
                                      ));
                            }
                            if (widget.favExists != true) {
                              FirebaseFirestore.instance
                                  .collection("User")
                                  .doc(user.uid)
                                  .collection("Favorites")
                                  .doc(widget.photoID)
                                  .set({
                                "imgUrl": widget.imgUrl,
                                "photographer": widget.photographer,
                                "photographerUrl": widget.photographerUrl,
                                "photoID": widget.photoID.toString(),
                                "photographerID":
                                    widget.photographerID.toString(),
                                "originalUrl": widget.originalUrl,
                                "avgColor": widget.avgColor,
                              });
                              setState(() {
                                widget.favExists = !widget.favExists;
                              });
                            }
                          },
                        ),
                        //
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  _save(String url, bool _permissionReceived) async {
    downloading = true;
    setState(() {});
    if (_permissionStatus) {
      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes),
              onReceiveProgress: (received, total) {
        if (total != -1) {
          progressValue = received / total;
          progressString = (received / total * 100).toStringAsFixed(0) + "%";
          setState(() {});
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      });
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: widget.photographer + widget.photoID.toString());
      print(result);
      downloading = false;
      setState(() {});
    }
    if (!_permissionStatus) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title:
                    Text("OOPS!", style: Theme.of(context).textTheme.subtitle1),
                content: Text("FILE PERMISSIONS ARE DENIED",
                    style: Theme.of(context).textTheme.button),
                actions: [
                  TextButton(
                      onPressed: () {
                        askPermission();
                        Navigator.pop(context);
                      },
                      child: Text("ASK PERMISSION",
                          style: Theme.of(context).textTheme.button)),
                  TextButton(
                    child:
                        Text("OK", style: Theme.of(context).textTheme.button),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }

  saveWallpaper(int location) async {
    try {
      String url = widget.imgUrl;
      String originalUrl = widget.originalUrl;
      var file;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title:
                    Text("FELEXO", style: Theme.of(context).textTheme.button),
                content: Text("CHOOSE SIZE",
                    style: Theme.of(context).textTheme.button),
                actions: [
                  TextButton(
                    child: Text("COMPRESSED",
                        style: Theme.of(context).textTheme.button),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Future.delayed(Duration(seconds: 1), () {
                        setWallpaper(file, url, location);
                      });
                    },
                  ),
                  TextButton(
                    child: Text("ORIGINAL",
                        style: Theme.of(context).textTheme.button),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      Future.delayed(Duration(seconds: 1), () {
                        setWallpaper(file, originalUrl, location);
                      });
                    },
                  )
                ],
              ));
    } catch (e) {
      print("Exception: " + e.message);
    }
  }

  Future<Null> setWallpaper(var file, String url, int location) async {
    try {
      // final file = await DefaultCacheManager().getSingleFile(url);
      // var response = await http.get(Uri.parse(url));
      // var filePath =
      //     await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
      var filePath = await getTemporaryDirectory();
      print(filePath);
      var response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
          ), onReceiveProgress: (received, total) {
        if (total != -1) {
          progressValue = received / total;
          progressString = (received / total * 100).toStringAsFixed(0) + "%";
          setState(() {});
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      });
      print(response);
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: widget.photographer + widget.photoID.toString());
      print(result);

      try {
        final String result = await WallpaperManager.setWallpaperFromFile(
          "storage/emulated/0/Pictures/" +
              widget.photographer +
              widget.photoID.toString() +
              ".jpg",
          location,
        ).whenComplete(() {
          downloading = false;
          setState(() {});
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    title: Text("FELEXO",
                        style: Theme.of(context).textTheme.button),
                    content: Text("YOUR WALLPAPER IS SET",
                        style: Theme.of(context).textTheme.button),
                    actions: [
                      TextButton(
                        child: Text("OK",
                            style: Theme.of(context).textTheme.button),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        });
        print(result);
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }
}
