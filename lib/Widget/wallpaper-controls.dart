import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:felexo/Color/colors.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

const String testDevices = "10541B246DA05AC314ED0A170DA2B594";

String home = "Home Screen";
String lock = "Lock Screen";
String both = "Both Screen";
String system = "System";
String res;
String pexelsText = "Wallpapers Provided by Pexels";
bool deletingFav = false;
Stream<String> progressString;
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
  static const MobileAdTargetingInfo mobileAdTargetingInfo =
      MobileAdTargetingInfo(
    testDevices: testDevices != null ? <String>[testDevices] : null,
    keywords: <String>['Wallpapers'],
  );
  InterstitialAd interstitialAd;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: 'ca-app-pub-1356887710608938/6475087475',
        targetingInfo: mobileAdTargetingInfo,
        listener: (MobileAdEvent event) {
          print("Ad: $event");
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-1356887710608938~3220128931');

    downloading = false;
    setState(() {});
    initUser();
    super.initState();
  }

  @override
  void dispose() {
    interstitialAd.dispose();
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

  @override
  Widget build(BuildContext context) {
    return downloading
        ? Padding(
            padding: const EdgeInsets.only(top: 54.0, bottom: 20),
            child: SizedBox(
              width: 280,
              height: 5,
              child: LinearProgressIndicator(
                backgroundColor: iconColor.withAlpha(80),
                valueColor: AlwaysStoppedAnimation(iconColor),
              ),
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
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.save,
                                    size: 30,
                                    color: widget.foregroundColor,
                                  ),
                                  onTap: () {
                                    interstitialAd = createInterstitialAd()
                                      ..load()
                                      ..show();
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
                                                      child: FlatButton(
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .stay_current_portrait,
                                                              size: 30,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            Text(
                                                              "Portrait",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Circular Black',
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          downloading = true;

                                                          setState(() {});
                                                          Future.delayed(
                                                              Duration(
                                                                  seconds: 1),
                                                              () {
                                                            _save(
                                                                widget.imgUrl);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: FlatButton(
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .photo_size_select_actual,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                              "Original",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Circular Black',
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          downloading = true;

                                                          setState(() {});
                                                          Future.delayed(
                                                              Duration(
                                                                  seconds: 1),
                                                              () {
                                                            _save(widget
                                                                .originalUrl);
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
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.wallpaper,
                                    size: 30,
                                    color: widget.foregroundColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            interstitialAd = createInterstitialAd()
                              ..load()
                              ..show();
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
                                              child: FlatButton(
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
                                              child: FlatButton(
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
                                              child: FlatButton(
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
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    widget.favExists
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 30,
                                    color: widget.favExists
                                        ? Colors.redAccent
                                        : widget.foregroundColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: () async {
                            interstitialAd = createInterstitialAd()
                              ..load()
                              ..show();
                            if (widget.favExists == true) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Favorites"),
                                        content:
                                            Text("Already added to Favorites!"),
                                        actions: [
                                          FlatButton(
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
                        if (user.email == "felexotestemail@gmail.com")
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: GestureDetector(
                                onTap: () {
                                  print("Daily Special Added");
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .backgroundColor,
                                            title: Text("Felexo"),
                                            content:
                                                Text("Daily Special Added!"),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("OK"),
                                              )
                                            ],
                                          ));
                                  FirebaseFirestore.instance
                                      .collection("DailySpecial")
                                      .doc("DailySpecial")
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
                                },
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: widget.foregroundColor,
                                )),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  _save(String url) async {
    try {
      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes),
              onReceiveProgress: (actualBytes, totalBytes) {
        setState(() {});
      }).whenComplete(() => () {});

      final location =
          await ImageGallerySaver.saveImage(Uint8List.fromList(response.data))
              .whenComplete(() {
        downloading = false;
        setState(() {});
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  title: Text("Felexo",
                      style: Theme.of(context).textTheme.subtitle1),
                  content: Text("Wallpaper Saved to Device!",
                      style: Theme.of(context).textTheme.subtitle1),
                  actions: [
                    FlatButton(
                      child: Text(
                        "OK",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Circular Black'),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      });
      wallpaperLocation = location;
    } catch (e) {
      print(e);
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
                  FlatButton(
                    child: Text("Compressed",
                        style: Theme.of(context).textTheme.subtitle1),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Future.delayed(Duration(seconds: 1), () {
                        setWallpaper(file, url, location);
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("Original",
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
      final file = await DefaultCacheManager().getSingleFile(url);

      try {
        final String result =
            await WallpaperManager.setWallpaperFromFile(file.path, location)
                .whenComplete(() {
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
                      FlatButton(
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
