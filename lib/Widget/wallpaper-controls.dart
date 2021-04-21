import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
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
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(80),
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      progressString,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Downloading...",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: GestureDetector(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
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
                                      builder: (context) => AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          content: Container(
                                            height: 200,
                                            child: ClipRRect(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextButton(
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .stay_current_portrait,
                                                            size: 30,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Portrait",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Theme Bold',
                                                                color: Colors
                                                                    .white),
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
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextButton(
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .photo_size_select_actual,
                                                              size: 30,
                                                              color:
                                                                  Colors.white),
                                                          Text(
                                                            "Original",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Theme Bold',
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        ],
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        _save(
                                                            widget.originalUrl,
                                                            _permissionStatus);
                                                      },
                                                    ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
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
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Container(
                                      height: 200,
                                      child: ClipRRect(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextButton(
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.home,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      "Home Screen",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Circular Black',
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  downloading = true;

                                                  setState(() {});
                                                  Future.delayed(
                                                      Duration(seconds: 1), () {
                                                    saveWallpaper(
                                                        WallpaperManager
                                                            .HOME_SCREEN);
                                                  });
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextButton(
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .screen_lock_portrait,
                                                        size: 30,
                                                        color: Colors.white),
                                                    Text(
                                                      "Lock Screen",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Circular Black',
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  downloading = true;

                                                  setState(() {});
                                                  Future.delayed(
                                                      Duration(seconds: 1), () {
                                                    saveWallpaper(
                                                        WallpaperManager
                                                            .LOCK_SCREEN);
                                                  });
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextButton(
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.smartphone,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      "Both Screen",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Circular Black',
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  downloading = true;
                                                  setState(() {});
                                                  Future.delayed(
                                                      Duration(seconds: 1), () {
                                                    saveWallpaper(
                                                        WallpaperManager
                                                            .BOTH_SCREENS);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
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
                    Text("Oops!", style: Theme.of(context).textTheme.subtitle1),
                content: Text("File Permissions are denied!",
                    style: Theme.of(context).textTheme.subtitle1),
                actions: [
                  TextButton(
                      onPressed: () {
                        askPermission();
                        Navigator.pop(context);
                      },
                      child: Text("ASK PERMISSION")),
                  TextButton(
                    child: Text("OK",
                        style: Theme.of(context).textTheme.subtitle1),
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
                title: Text("Felexo",
                    style: Theme.of(context).textTheme.subtitle1),
                content: Text("Choose Size",
                    style: Theme.of(context).textTheme.subtitle1),
                actions: [
                  TextButton(
                    child: Text("COMPRESSED",
                        style: Theme.of(context).textTheme.subtitle1),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Future.delayed(Duration(seconds: 1), () {
                        setWallpaper(file, url, location);
                      });
                    },
                  ),
                  TextButton(
                    child: Text("ORIGINAL",
                        style: Theme.of(context).textTheme.subtitle1),
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
                    title: Text("Felexo",
                        style: Theme.of(context).textTheme.subtitle1),
                    content: Text("Wallpaper Set :)",
                        style: Theme.of(context).textTheme.subtitle1),
                    actions: [
                      TextButton(
                        child: Text("OK",
                            style: Theme.of(context).textTheme.subtitle1),
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
