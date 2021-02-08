import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Widget/wallpaper-controls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
  double _height = 200;
  double _width;
  String wallpaperLocation;
  final globalKey = GlobalKey<ScaffoldState>();
  var result = "Waiting to set wallpapers";
  var foregroundColor;
  @override
  void initState() {
    transparent = false;
    foregroundColor = Hexcolor(widget.avgColor).computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
    print("AVG:" + widget.avgColor.toString());
    print(foregroundColor);
    findIfFav();
    initUser();
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
    final snapShot = await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.uid)
        .collection("Favorites")
        .doc(widget.photoID.toString())
        .get();
    if (snapShot.exists) {
      setState(() {
        favExists = true;
        print("Fav Exists");
      });
    } else {
      favExists = false;
    }
  }

  _updateState() {
    if (fullScreen == true) {
      _height = 0;
      _width = 0;
    }
    if (fullScreen == false) {
      findIfFav();
      _height = 200;
      _width = MediaQuery.of(context).size.width;
    }
    if (transparent == true) {}
    if (transparent == false) {}
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  color: Theme.of(context).colorScheme.secondary,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 3,
                          color: Theme.of(context).colorScheme.primary)),
                  onPressed: () {
                    setState(() {
                      fullScreen = !fullScreen;
                      _updateState();
                    });
                  },
                  child: Row(
                    children: [
                      fullScreen
                          ? Icon(Icons.select_all_outlined)
                          : Icon(Icons.tab_unselected_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Preview")
                    ],
                  )),
            )
          ],
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3)),
                child: GestureDetector(
                  child: Icon(
                    Icons.close,
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Hexcolor(widget.avgColor),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        transparent = !transparent;
                      });
                    },
                    child: Image.network(
                      widget.imgUrl,
                      fit: BoxFit.fitHeight,
                      height: MediaQuery.of(context).size.height,
                    ))),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: _width,
                    height: _height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 50,
                              spreadRadius: 5)
                        ],
                        color: transparent
                            ? Colors.transparent
                            : Hexcolor(widget.avgColor)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  launch(widget.photographerUrl);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: foregroundColor, width: 3)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.account_circle,
                                          color: foregroundColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        AutoSizeText(
                                          widget.photographer,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                          maxFontSize: 25,
                                          minFontSize: 15,
                                          style: TextStyle(
                                            color: foregroundColor,
                                            fontFamily: 'Circular Black',
                                            // fontSize: 20
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        // Icon(
                                        //   Icons.check_circle,
                                        //   color: iconColor,
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, bottom: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: foregroundColor, width: 3)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info,
                                        color: foregroundColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.photographerID,
                                        style: TextStyle(
                                            color: foregroundColor,
                                            fontFamily: 'Circular Black',
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        WallpaperControls(
                            foregroundColor: foregroundColor,
                            favExists: favExists,
                            uid: user.uid,
                            avgColor: widget.avgColor,
                            imgUrl: widget.imgUrl,
                            originalUrl: widget.originalUrl,
                            photoID: widget.photoID,
                            photographer: widget.photographer,
                            photographerID: widget.photographerID,
                            photographerUrl: widget.photographerUrl),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              backgroundColor: Theme.of(context)
                                                  .backgroundColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              content: Container(
                                                height: 200,
                                                width: 200,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5.0),
                                                          child: Text(
                                                            "All Wallpapers Provided by Pexels",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                fontFamily:
                                                                    'Circular Black',
                                                                fontSize: 14),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                            child:
                                                                Image.network(
                                                              "https://theme.zdassets.com/theme_assets/9028340/1e73e5cb95b89f1dce8b59c5236ca1fc28c7113b.png",
                                                              height: 100,
                                                              width: 100,
                                                            ),
                                                            onTap: () async {
                                                              await launch(
                                                                  "https://www.pexels.com/");
                                                            })
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Click the Logo to visit their website.",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                              fontFamily:
                                                                  'Circular Black',
                                                              fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Text(
                                    "Wallpaper provided by Pexels",
                                    style: TextStyle(
                                        color: foregroundColor,
                                        fontFamily: 'Circular Black',
                                        fontSize: 10),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
