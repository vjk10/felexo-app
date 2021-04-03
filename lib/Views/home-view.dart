import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Widget/widgets.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<WallpaperModel> wallpapers = [];
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
  var foregroundColor;
  int pageNumber = 1;
  Timer timer;
  bool isLoading = true;
  Map data;

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    getTrendingWallpapers();
    super.initState();

    initUser();
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse();
    //   }
    //   if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });
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
    // if (imgUrl == "") {
    //   DocumentReference documentReference = FirebaseFirestore.instance
    //       .collection("DailySpecial")
    //       .doc("DailySpecial");
    //   documentReference.snapshots().listen((event) {
    //     imgUrl = event.data()['imgUrl'].toString();
    //     originalUrl = event.data()['originalUrl'].toString();
    //     photoID = event.data()['photoID'].toString();
    //     photographer = event.data()['photographer'].toString();
    //     photographerID = event.data()['photographerID'].toString();
    //     photographerUrl = event.data()['photographerUrl'].toString();
    //     avgColor = event.data()['avgColor'].toString();
    //   });
    // }
    assert(imgUrl != null);
    assert(originalUrl != null);
    assert(photoID != null);
    assert(photographer != null);
    assert(photographerID != null);
    assert(photographerUrl != null);
    assert(avgColor != null);
  }

  Future<List> getTrendingWallpapers() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=$noOfImages"),
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
    foregroundColor = Hexcolor(avgColor).computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
    // print("AVG:" + avgColor.toString());
    // print("FG: " + foregroundColor.toString());
    setState(() {});
    return wallpapers;
  }

  Future<List> getMoreWallpapers() async {
    var response =
        await http.get(Uri.parse(nextPage), headers: {"Authorization": apiKey});

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
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text("Curated", style: Theme.of(context).textTheme.headline6),
        // ),
        key: _globalKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(iconColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Loading",
                        style: Theme.of(context).textTheme.button,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(iconColor),
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: imagesLoaded
                                ? Curated()
                                : Column(
                                    children: [
                                      LinearProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation(iconColor),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Loading"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      LinearProgressIndicator(
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: buttonColor,
                                onPrimary: textColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {
                              pageNumber = pageNumber + 1;
                              HapticFeedback.mediumImpact();
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
