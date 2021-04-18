import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Widget/wallpaper-controls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class WallPaperView extends StatefulWidget {
  final String avgColor,
      imgUrl,
      photoID,
      photographer,
      photographerID,
      originalUrl,
      photographerUrl,
      uid;
  WallPaperView(
      {this.avgColor,
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
  Stream<String> progressString;
  bool fullScreen = false;
  bool setWall = false;
  bool transparent = false;
  User user;
  String wallpaperLocation;
  final globalKey = GlobalKey<ScaffoldState>();
  var result = "Waiting to set wallpapers";
  var foregroundColor;
  @override
  void initState() {
    print(widget.uid);
    transparent = false;
    foregroundColor = Hexcolor(widget.avgColor).computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
    print("AVG:" + widget.avgColor.toString());
    print(foregroundColor);
    findIfFav();
    super.initState();
  }

  initUser() async {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    print("User: " + user.uid.toString());
    setState(() {});
  }

  findIfFav() async {
    print("finding fav");
    final snapShot = await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.uid)
        .collection("Favorites")
        .doc(widget.photoID.toString())
        .get();
    if (snapShot.exists) {
      favExists = true;
      print("Fav Exists");
      setState(() {});
    } else {
      print("Fav Not Exists");
      favExists = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        appBar: AppBar(
          actions: [],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Stack(children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.network(
                        widget.imgUrl,
                        fit: BoxFit.fitHeight,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      right: MediaQuery.of(context).size.width / 3,
                      left: MediaQuery.of(context).size.width / 3,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.4),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 15,
                    shadowColor: Hexcolor(widget.avgColor),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          color: Theme.of(context).colorScheme.primary),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
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
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.avgColor,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Theme Bold',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                      ],
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          child: Icon(
                                            Icons.tag,
                                            size: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
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
                                Column(
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
                                                  .secondary),
                                          child: Icon(
                                            Icons.badge,
                                            size: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.photographer,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Theme Bold',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                      ],
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          child: Icon(
                                            Icons.share_outlined,
                                            size: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Share",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Theme Bold',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WALLPAPER FROM PEXELS",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Theme Regular',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }
}
