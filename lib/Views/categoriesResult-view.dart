import 'dart:convert';

import 'package:felexo/Color/colors.dart';
import 'package:felexo/data/data.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:felexo/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CategoriesResult extends StatefulWidget {
  final String categoryName;
  CategoriesResult({this.categoryName});

  @override
  _CategoriesResultState createState() => _CategoriesResultState();
}

class _CategoriesResultState extends State<CategoriesResult> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  int noOfImages = 30;
  bool imagesLoaded = false;
  int pageNumber = 1;
  List<WallpaperModel> wallpapers = new List();

  getCateogryWallpapers(String categoryName) async {
    var response = await http.get(
        "https://api.pexels.com/v1/search/?page=2&per_page=$noOfImages&query=$categoryName",
        headers: {"Authorization": apiKey});
    // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    imagesLoaded = true;
    setState(() {});
  }

  getMoreWallpapers(String categoryName) async {
    var response = await http.get(
        "https://api.pexels.com/v1/search/?page=$pageNumber&per_page=10&query=$categoryName",
        headers: {"Authorization": apiKey});
    // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      // print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    imagesLoaded = true;
    setState(() {});
  }

  @override
  void initState() {
    getCateogryWallpapers(widget.categoryName);
    initUser();
    super.initState();
  }

  initUser() async {
    user = _auth.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (imagesLoaded == true) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(color: iconColor),
            title: Text(
              "Categories",
              style: Theme.of(context).textTheme.headline6,
            ),
            elevation: 5,
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, bottom: 2, left: 10),
                        child: Text(
                          widget.categoryName,
                          style: TextStyle(
                              fontFamily: 'Circular Black', fontSize: 25),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: wallpaperGrid(
                          wallpapers: wallpapers,
                          context: context,
                          uid: user.uid),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding:
                              EdgeInsets.only(top: 10, bottom: 2, right: 10),
                          child: FlatButton.icon(
                            splashColor: iconColor,
                            onPressed: () {
                              pageNumber = pageNumber + 1;
                              getMoreWallpapers(widget.categoryName);
                            },
                            icon: Icon(Icons.arrow_circle_down_outlined),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            label: Text(
                              "Load More",
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          )));
    }
    if (imagesLoaded == false) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title:
              Text("Categories", style: Theme.of(context).textTheme.headline6),
          elevation: 5,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(iconColor),
                strokeWidth: 3,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Loading...",
                style: TextStyle(
                  fontFamily: 'Circular Bold',
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold();
  }
}
