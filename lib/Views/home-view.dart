import 'dart:async';
import 'dart:convert';

import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Views/wallpaper-view.dart';
import 'package:felexo/Widget/widgets.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:http/http.dart' as http;

const String testDevices = "mobileID";

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  ScrollController scrollController;
  List<WallpaperModel> wallpapers = new List();
  bool imagesLoaded = false;
  bool _lBVisiblity = false;
  String dailyTitle;
  User user;
  int noOfImages = 20;
  final globalKey = GlobalKey<ScaffoldState>();
  int progressValue = 0;
  String wallpaperLocation,
      imgUrl,
      originalUrl,
      photoID,
      photographer,
      photographerID,
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
    scrollController = new ScrollController()..addListener(_scrollListener);
  }

  initUser() async {
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

  getTrendingWallpapers() async {
    var response = await http.get(
        "https://api.pexels.com/v1/curated?per_page=$noOfImages",
        headers: {"Authorization": apiKey}); // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      // print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    print("TrendingState");
    setState(() {
      isLoading = false;
    });
  }

  getMoreWallpapers() async {
    var response = await http.get(
        "https://api.pexels.com/v1/curated/?page=$pageNumber&per_page=$noOfImages",
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {});
  }

  void _scrollListener() {
    print(scrollController.position.extentAfter);
    if (scrollController.position.extentAfter == 0) {
      setState(() {});
      _lBVisiblity = true;
    }
    if (scrollController.position.extentAfter > 0) {
      setState(() {});
      _lBVisiblity = false;
    }
    if (scrollController.position.extentAfter > 1000) {
      setState(() {});
      controller.stop();
      _lBVisiblity = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: isLoading
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
                CustomScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverGroupBuilder(
                      child: SliverAppBar(
                          floating: true,
                          stretchTriggerOffset:
                              MediaQuery.of(context).size.height / 5,
                          onStretchTrigger: () async {
                            HapticFeedback.heavyImpact();
                            print('stretch');
                            await Future.delayed(Duration.zero);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WallPaperView(
                                        uid: user.uid,
                                        imgUrl: imgUrl,
                                        originalUrl: originalUrl,
                                        photoID: photoID,
                                        photographer: photographer,
                                        photographerID: photographerID,
                                        photographerUrl: photographerUrl)));
                          },
                          stretch: true,
                          expandedHeight:
                              MediaQuery.of(context).size.height / 3,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                              stretchModes: [
                                StretchMode.zoomBackground,
                              ],
                              background: Stack(children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Transform.scale(
                                    scale: animation.value,
                                    alignment: Alignment.center,
                                    child: FadeInImage.assetNetwork(
                                        fit: BoxFit.fitWidth,
                                        fadeInDuration:
                                            const Duration(seconds: 1),
                                        fadeInCurve: Curves.easeIn,
                                        placeholder:
                                            "assets/images/loading.gif",
                                        image: imgUrl),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  alignment: Alignment.bottomCenter,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    color: Theme.of(context)
                                        .backgroundColor
                                        .withAlpha(50),
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    child: BorderedText(
                                        strokeWidth: 3,
                                        strokeColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        child: Text("Daily Special",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4)),
                                  ),
                                ),
                              ]),
                              centerTitle: true,
                              title: BorderedText(
                                strokeWidth: 3,
                                strokeColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: Text("Felexo",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ))),
                    ),
                    SliverGroupBuilder(
                      child: SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: wallpaperGrid(
                              wallpapers: wallpapers,
                              context: context,
                              uid: user.uid),
                        ),
                      ])),
                    ),
                  ],
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
              ]));
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
