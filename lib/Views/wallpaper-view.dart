import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Views/views.dart';
import 'package:felexo/Widget/wallpaper-controls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';

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
  var linkTarget;
  double elevationValue = 0;

  @override
  void initState() {
    print(widget.uid);
    transparent = false;

    // print("AVG:" + widget.avgColor.toString());
    // print(foregroundColor);
    findIfFav();
    super.initState();
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
                        color: Theme.of(context).colorScheme.primary,
                        // color: Colors.transparent,
                      ),
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
                                    GestureDetector(
                                      onTap: () {
                                        var color = widget.avgColor.substring(
                                            1, widget.avgColor.length);
                                        print(color);
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    ColorSearchView(
                                                      color: color,
                                                    )));
                                      },
                                      child: Row(
                                        children: [
                                          Material(
                                            type: MaterialType.circle,
                                            color: Hexcolor(widget.avgColor),
                                            elevation: elevationValue,
                                            shadowColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    Hexcolor(widget.avgColor),
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Link(
                                      target: LinkTarget.self,
                                      uri: Uri.parse(widget.photographerUrl),
                                      builder: (context, followPhotographer) {
                                        return GestureDetector(
                                          onTap: followPhotographer,
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
                                                        fontFamily:
                                                            'Theme Bold',
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
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
                                        title: Text("Visit Pexels"),
                                        content: Text("Open Pexels in"),
                                        actions: [
                                          Row(
                                            children: [
                                              Link(
                                                  target: LinkTarget.blank,
                                                  uri: Uri.parse(
                                                      "https://www.pexels.com/"),
                                                  builder:
                                                      (context, followBlank) {
                                                    return TextButton(
                                                        onPressed: followBlank,
                                                        child: Text(
                                                            "Open in Browser"));
                                                  }),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Link(
                                                  target: LinkTarget.self,
                                                  uri: Uri.parse(
                                                      "https://www.pexels.com/"),
                                                  builder:
                                                      (context, followSelf) {
                                                    return TextButton(
                                                        onPressed: followSelf,
                                                        child: Text(
                                                            "Open in App"));
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    child: Icon(
                                      Icons.public_outlined,
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Visit Pexels",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Theme Bold',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
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
