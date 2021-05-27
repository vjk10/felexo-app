import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:felexo/Views/views.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
// import 'package:toast/toast.dart';

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
                            InkWell(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  saveDialog(context);
                                },
                                child: controlButton(
                                    context, Icons.save_outlined)),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  setWallpaperDialog(context);
                                },
                                child: controlButton(
                                    context, Icons.wallpaper_outlined)),
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
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.5)),
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).cardColor),
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
                            HapticFeedback.heavyImpact();
                            if (widget.favExists == true) {
                              favExistsDialog(context);
                            }
                            if (widget.favExists != true) {
                              addToFav();
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

  addToFav() {
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
      "photographerID": widget.photographerID.toString(),
      "originalUrl": widget.originalUrl,
      "avgColor": widget.avgColor,
    });
    setState(() {
      widget.favExists = !widget.favExists;
    });
  }

  favExistsDialog(BuildContext context) {
    FirebaseFirestore.instance
        .collection("User")
        .doc(user.uid)
        .collection("Favorites")
        .doc(widget.photoID)
        .delete()
        .whenComplete(() {
      setState(() {
        widget.favExists = !widget.favExists;
      });
    });
  }

  Future<dynamic> setWallpaperDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1,
                    color: Theme.of(context).accentColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(0)),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("SELECT A LOCATION",
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
            content: Container(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 24,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            "HOME\nSCREEN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Theme Bold',
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();

                        Future.delayed(Duration(seconds: 1), () {
                          saveWallpaper(WallpaperManager.HOME_SCREEN);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.lock_outlined,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary),
                          Text(
                            "LOCK\nSCREEN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Theme Bold',
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();

                        Future.delayed(Duration(seconds: 1), () {
                          saveWallpaper(WallpaperManager.LOCK_SCREEN);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 0),
                    child: TextButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.smartphone_outlined,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary),
                          Text(
                            "BOTH\nSCREEN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Theme Bold',
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Future.delayed(Duration(seconds: 1), () {
                          saveWallpaper(WallpaperManager.BOTH_SCREENS);
                        });
                      },
                    ),
                  ),
                ],
              ),
            )));
  }

  Container controlButton(
    BuildContext context,
    var iconStyle,
  ) {
    return Container(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: Theme.of(context).accentColor.withOpacity(0.5)),
          color: Theme.of(context).cardColor,
        ),
        child: Icon(
          iconStyle,
          size: 25,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Future<dynamic> saveDialog(BuildContext context) {
    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) => AlertDialog(
            elevation: 0,
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1,
                    color: Theme.of(context).accentColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(0)),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SELECT SIZE OF WALLPAPER",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 80,
                child: ClipRRect(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: Column(
                          children: [
                            Icon(
                              Icons.smartphone,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "PORTRAIT",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Theme Bold',
                                  color: Theme.of(context).colorScheme.primary),
                            )
                          ],
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          _save(widget.imgUrl, _permissionStatus, "p");
                        },
                      ),
                      TextButton(
                        child: Column(
                          children: [
                            Icon(Icons.photo_size_select_actual_outlined,
                                size: 24,
                                color: Theme.of(context).colorScheme.primary),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "ORIGINAL",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Theme Bold',
                                  color: Theme.of(context).colorScheme.primary),
                            )
                          ],
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();

                          _save(widget.originalUrl, _permissionStatus, "o");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  _save(String url, bool _permissionReceived, String type) async {
    String _type;
    if (type == "o") {
      _type = "ORIGINAL";
    }
    if (type == "p") {
      _type = "PORTRAIT";
    }
    var appDirectory = Directory("storage/emulated/0/Pictures/FELEXO");
    if (!(await appDirectory.exists())) {
      appDirectory.createSync(recursive: true);
    }
    downloading = true;
    setState(() {});
    if (_permissionStatus) {
      var response = await Dio().download(
          url,
          "storage/emulated/0/Pictures/FELEXO/" +
              widget.photographer +
              widget.photoID +
              " " +
              _type +
              ".jpg",
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: (received, total) {
        if (total != -1) {
          progressValue = received / total;
          progressString = (received / total * 100).toStringAsFixed(0) + "%";
          setState(() {});
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      }).whenComplete(() {
        downloading = false;
        setState(() {});
      });
      if (progressString == "100") {
        downloading = false;
        setState(() {});
      }
      // var response = await Dio()
      //     .get(url, options: Options(responseType: ResponseType.bytes),
      //         onReceiveProgress: (received, total) {
      //   if (total != -1) {
      //     progressValue = received / total;
      //     progressString = (received / total * 100).toStringAsFixed(0) + "%";
      //     setState(() {});
      //     print((received / total * 100).toStringAsFixed(0) + "%");
      //   }
      // });
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: widget.photographer + widget.photoID.toString());
      print(result);
      downloading = false;
      setState(() {
        progressString = "0%";
        progressValue = 0;
      });
    }
    if (!_permissionStatus) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1,
                        color: Theme.of(context).accentColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(0)),
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title:
                    Text("OOPS!", style: Theme.of(context).textTheme.bodyText1),
                content: Text("FILE PERMISSIONS ARE DENIED",
                    style: Theme.of(context).textTheme.bodyText1),
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
          barrierDismissible: true,
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1,
                        color: Theme.of(context).accentColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(0)),
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("CHOOSE TYPE",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
                content: Container(
                  height: 80,
                  child: ClipRRect(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Column(
                            children: [
                              Icon(
                                Icons.compress_outlined,
                                size: 24,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "COMPRESSED",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Theme Bold',
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              )
                            ],
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            setWallpaper(file, url, location);
                          },
                        ),
                        TextButton(
                          child: Column(
                            children: [
                              Icon(Icons.photo_size_select_actual_outlined,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.primary),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "ORIGINAL",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Theme Bold',
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              )
                            ],
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            setWallpaper(file, originalUrl, location);
                          },
                        ),
                        TextButton(
                          child: Column(
                            children: [
                              Icon(Icons.blur_on_outlined,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.primary),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "BLURRED",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Theme Bold',
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              )
                            ],
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => BlurWallpaperView(
                                          location: location,
                                          avgColor: widget.avgColor,
                                          photoID: widget.photoID,
                                          url: widget.originalUrl,
                                          photographer: widget.photographer,
                                          foregroundColor:
                                              widget.foregroundColor,
                                        )));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ));
    } catch (e) {
      print("Exception: " + e.message);
    }
  }

  Future<Null> setWallpaper(var file, String url, int location) async {
    setState(() {
      downloading = true;
    });
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
          setState(() {
            progressValue = received / total;
            progressString = (received / total * 100).toStringAsFixed(0) + "%";
          });
          // print((received / total * 100).toStringAsFixed(0) + "%");
        }
      });
      print(response.data);
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
          final file = File("storage/emulated/0/Pictures/" +
              widget.photographer +
              widget.photoID.toString() +
              ".jpg");
          file.delete();
          setState(() {});
          Fluttertoast.showToast(
              msg: "Your wallpaper is set",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.secondary,
              fontSize: 16.0);
          // Toast.show("YOUR WALLPAPER IS SET", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
