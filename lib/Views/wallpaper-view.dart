import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Services/ad-services.dart';
import 'package:felexo/Widget/wallpaper-controls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission/permission.dart';
import 'package:share/share.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/link.dart';

import 'views.dart';

class WallPaperView extends StatefulWidget {
  final String avgColor,
      searchString,
      imgUrl,
      photoID,
      photographer,
      photographerID,
      originalUrl,
      photographerUrl,
      uid;
  WallPaperView(
      {this.avgColor,
      this.searchString,
      @required this.uid,
      @required this.imgUrl,
      @required this.originalUrl,
      @required this.photoID,
      @required this.photographer,
      @required this.photographerID,
      @required this.photographerUrl});
  @override
  _WallPaperViewState createState() => _WallPaperViewState();
}

class _WallPaperViewState extends State<WallPaperView> {
  String home = "Home Screen";
  String lock = "Lock Screen";
  String both = "Both Screen";
  String system = "System";
  String res;
  bool favExists = false;
  bool deletingFav = false;
  bool fullScreen = false;
  bool setWall = false;
  bool transparent = false;
  User user;
  String wallpaperLocation;
  final globalKey = GlobalKey<ScaffoldState>();
  var result = "Waiting to set wallpapers";
  var foregroundColor;
  var linkTarget;
  double elevationValue = 0;
  bool _isVerified = false;
  bool _permissionStatus;
  double progressValue;
  String progressString = "0%";
  String creatorCheck = "";

  List<String> searchTerms = [];

  @override
  initState() {
    print(widget.uid);
    checkPermissionStatus();
    transparent = false;
    findIfFav();
    checkVerified();
    super.initState();
  }

  checkVerified() async {
    print("CHECK VERIFIED");
    FirebaseFirestore.instance
        .collection('User')
        .snapshots()
        .forEach((element) {
      print(element.docs.map((e) async {
        if (e.get('displayName') == widget.photographer) {
          DocumentSnapshot snapshot = await FirebaseFirestore.instance
              .collection('VerifiedCreators')
              .doc(e.get('uid'))
              .get();
          if (snapshot.exists) {
            setState(() {
              _isVerified = true;
            });
          }
        }
      }));
    });
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

  @mustCallSuper
  didChangeDependencies() async {
    if (widget.avgColor.length < 6) {
      foregroundColor = Theme.of(context).colorScheme.secondary;
      elevationValue = 1;
    } else {
      foregroundColor = Hexcolor(widget.avgColor).computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;
      elevationValue = 0;
    }
    super.didChangeDependencies();
  }

  initUser() async {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    // print("User: " + user.uid.toString());
    setState(() {});
  }

  findIfFav() async {
    // print("finding fav");
    final snapShot = await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.uid)
        .collection("Favorites")
        .doc(widget.photoID.toString())
        .get();
    if (snapShot.exists) {
      favExists = true;
      // print("Fav Exists");
      setState(() {});
    } else {
      // print("Fav Not Exists");
      favExists = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Theme.of(context).accentColor.withOpacity(0.5)),
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SlidingUpPanel(
          border: Border.all(
              color: Theme.of(context).accentColor.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(0),
          backdropEnabled: true,
          backdropColor: Hexcolor(widget.avgColor),
          backdropOpacity: 0.5,
          backdropTapClosesPanel: true,
          color: Theme.of(context).scaffoldBackgroundColor,
          maxHeight: MediaQuery.of(context).size.height / 1.5,
          minHeight: MediaQuery.of(context).size.height / 8,
          body: Stack(children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Hexcolor(widget.avgColor),
              ),
            ),
            Shimmer(
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CachedNetworkImage(
                    imageUrl: widget.imgUrl,
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.easeIn),
              ),
            ),
          ]),
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.minimize_outlined,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SWIPE FOR MORE",
                    style: Theme.of(context).textTheme.button,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WallpaperControls(
                      uid: widget.uid,
                      imgUrl: widget.imgUrl,
                      originalUrl: widget.originalUrl,
                      photoID: widget.photoID,
                      photographer: widget.photographer,
                      photographerID: widget.photographerID,
                      photographerUrl: widget.photographerUrl,
                      avgColor: widget.avgColor,
                      favExists: favExists,
                      foregroundColor: foregroundColor)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              infoCard(context),
              SizedBox(
                height: 20,
              ),
              adBox(context),
            ],
          )),
    );
  }

  Row adBox(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: AdWidget(
            ad: AdServices.createBannerAd()..load(),
            key: UniqueKey(),
          ),
        )
      ],
    );
  }

  Row infoCard(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
                color: Theme.of(context).accentColor.withOpacity(0.5),
                width: 1),
            color: Theme.of(context).cardColor,
            // color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            var color = widget.avgColor
                                .substring(1, widget.avgColor.length);
                            print(color);
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => ColorSearchView(
                                      color: color,
                                    )));
                          },
                          child: Row(
                            children: [
                              Material(
                                type: MaterialType.circle,
                                color: Hexcolor(widget.avgColor),
                                elevation: elevationValue,
                                shadowColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Hexcolor(widget.avgColor),
                                  ),
                                  child: Icon(
                                    Icons.palette_outlined,
                                    size: 20,
                                    color: foregroundColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.avgColor,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Theme Bold',
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary),
                              child: Icon(
                                Icons.tag,
                                size: 20,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.photoID,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Theme Bold',
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          HapticFeedback.heavyImpact();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              content: Row(
                                children: [
                                  Text(
                                    widget.photographer.toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor,
                                        fontFamily: 'Theme Bold'),
                                  ),
                                  _isVerified
                                      ? Icon(Icons.verified,
                                          size: 16,
                                          color: Theme.of(context).cardColor)
                                      : SizedBox(),
                                ],
                              )));
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  child: Icon(
                                    Icons.badge_outlined,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.photographer.toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Theme Bold',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      _isVerified
                                          ? Icon(Icons.verified,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(0)),
                              elevation: 0,
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "SHARE AS",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              ),
                              content: SizedBox(
                                height: 100,
                                width: 80,
                                child: Center(
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _imageShare(widget.imgUrl,
                                                _permissionStatus);
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image_outlined,
                                                size: 24,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "IMAGE",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button,
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Share.share("Checkout this Photo By: " +
                                                widget.photographer +
                                                "\n\nPhotographer: " +
                                                widget.photographerUrl +
                                                "\n\nFind Image at: " +
                                                widget.originalUrl +
                                                "\n\nDownload FELEXO for more amazing wallpapers");
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.link_outlined,
                                                size: 24,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "LINK",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button,
                                              )
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  child: Icon(
                                    Icons.share_outlined,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "SHARE",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Theme Bold',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(0)),
                            elevation: 0,
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("VISIT PEXELS",
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                            content: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.public),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "OPEN PEXELS IN",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                            actions: [
                              Row(
                                children: [
                                  Link(
                                      target: LinkTarget.blank,
                                      uri: Uri.parse("https://www.pexels.com/"),
                                      builder: (context, followBlank) {
                                        return TextButton(
                                            onPressed: followBlank,
                                            child: Text("OPEN IN BROWSER"));
                                      }),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Link(
                                      target: LinkTarget.self,
                                      uri: Uri.parse("https://www.pexels.com/"),
                                      builder: (context, followSelf) {
                                        return TextButton(
                                            onPressed: followSelf,
                                            child: Text("OPEN IN APP"));
                                      }),
                                ],
                              )
                            ],
                          );
                        });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.public_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "VISIT PEXELS",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Theme Bold',
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _imageShare(String url, bool _permissionReceived) async {
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
      Share.shareFiles([
        "storage/emulated/0/Pictures/FELEXO/" +
            widget.photographer +
            widget.photoID.toString() +
            ".jpg"
      ],
          text: "Checkout this Photo By: " +
              widget.photographer +
              "\n\nPhotographer: " +
              widget.photographerUrl +
              "\n\nFind Image at: " +
              widget.originalUrl +
              "\n\nDownload FELEXO for more amazing wallpapers");
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
}
