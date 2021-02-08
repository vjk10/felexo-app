import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Views/wallpaper-view.dart';
import 'package:felexo/Widget/widgets.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String testDevices = "mobileID";

class HomeViewAlt extends StatefulWidget {
  @override
  _HomeViewAltState createState() => _HomeViewAltState();
}

class _HomeViewAltState extends State<HomeViewAlt>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  List<WallpaperModel> wallpapers = new List();
  bool imagesLoaded = false;
  bool _lBVisiblity = false;
  String dailyTitle;
  User user;
  int noOfImages = 20;
  final _globalKey = GlobalKey<ScaffoldState>();
  int progressValue = 0;
  String wallpaperLocation,
      imgUrl,
      originalUrl,
      photoID,
      photographer,
      photographerID,
      avgColor,
      nextPage,
      photographerUrl;
  int pageNumber = 1;
  Timer timer;
  bool isLoading = true;
  Map data;

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: InterstitialAd.testAdUnitId);

    controller =
        AnimationController(duration: Duration(minutes: 1), vsync: this);
    getTrendingWallpapers();
    super.initState();
    initUser();
    animation = Tween<double>(begin: 1, end: 2).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
    // _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  Future initUser() async {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    print("User: " + user.uid.toString());
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("DailySpecial")
        .doc("DailySpecial");
    documentReference.snapshots().listen((event) {
      imgUrl = event.data()['imgUrl'].toString();
      originalUrl = event.data()['originalUrl'].toString();
      photoID = event.data()['photoID'].toString();
      photographer = event.data()['photographer'].toString();
      photographerID = event.data()['photographerID'].toString();
      photographerUrl = event.data()['photographerUrl'].toString();
      avgColor = event.data()['avgColor'].toString();
    });
    if (imgUrl == "") {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("DailySpecial")
          .doc("DailySpecial");
      documentReference.snapshots().listen((event) {
        imgUrl = event.data()['imgUrl'].toString();
        originalUrl = event.data()['originalUrl'].toString();
        photoID = event.data()['photoID'].toString();
        photographer = event.data()['photographer'].toString();
        photographerID = event.data()['photographerID'].toString();
        photographerUrl = event.data()['photographerUrl'].toString();
      });
    }
    assert(imgUrl != null);
    assert(originalUrl != null);
    assert(photoID != null);
    assert(photographer != null);
    assert(photographerID != null);
    assert(photographerUrl != null);
  }

  Future<List> getTrendingWallpapers() async {
    var response = await http.get(
        "https://api.pexels.com/v1/curated?per_page=$noOfImages",
        headers: {"Authorization": apiKey}); // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print(jsonData["next_page"].toString());
    nextPage = jsonData["next_page"].toString();
    jsonData["photos"].forEach((element) {
      // print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    print("TrendingState");
    setState(() {
      isLoading = false;
      imagesLoaded = true;
    });
    return wallpapers;
  }

  Future<List> getMoreWallpapers() async {
    var response = await http.get(nextPage, headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {
      imagesLoaded = true;
    });
    print("Next" + jsonData["next_page"].toString());
    nextPage = jsonData["next_page"].toString();
    return wallpapers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Curated", style: Theme.of(context).textTheme.headline6),
        ),
        key: _globalKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).accentColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Loading")],
                      )
                    ],
                  ),
                )
              : Stack(children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WallPaperView(
                                          avgColor: avgColor,
                                          uid: user.uid,
                                          imgUrl: imgUrl,
                                          originalUrl: originalUrl,
                                          photoID: photoID,
                                          photographer: photographer,
                                          photographerID: photographerID,
                                          photographerUrl: photographerUrl)));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  child: Container(
                                    color: Hexcolor(avgColor),
                                    child: Transform.scale(
                                      scale: animation.value,
                                      child: Image.network(
                                        imgUrl,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  color: Hexcolor(avgColor).withOpacity(0.3),
                                  alignment: Alignment.center,
                                  child: Stack(children: [
                                    Text(
                                      "Daily Special",
                                      style: TextStyle(
                                        fontSize: 50,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(8.0, 10.0),
                                            blurRadius: 50.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ]),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                            child: imagesLoaded
                                ? Curated()
                                : Column(
                                    children: [
                                      Text("Loading"),
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation(iconColor),
                                      )
                                    ],
                                  )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 90.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        visible: _lBVisiblity,
                        child: Container(
                          width: 110,
                          height: 40,
                          child: RaisedButton(
                            elevation: 5,
                            color: Theme.of(context).backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () {
                              pageNumber = pageNumber + 1;
                              getMoreWallpapers();
                              _lBVisiblity = false;
                              setState(() {});
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Load More"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
