import 'dart:convert';

import 'package:felexo/Color/colors.dart';
import 'package:felexo/Services/ad-services.dart';
import 'package:felexo/Widget/widgets.dart';
import 'package:felexo/data/data.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  bool _buttonVisible = true;
  int pageNumber = 1;
  List<WallpaperModel> wallpapers = [];

  getCateogryWallpapers(String categoryName) async {
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search/?page=2&per_page=$noOfImages&query=$categoryName"),
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
        Uri.parse(
            "https://api.pexels.com/v1/search/?page=$pageNumber&per_page=10&query=$categoryName"),
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
    _buttonVisible = !_buttonVisible;
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
          leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.categoryName.toUpperCase(),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 00, vertical: 00),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: wallpaperSearchGrid(
                          wallpapers: wallpapers,
                          context: context,
                          uid: user.uid),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                          visible: !_buttonVisible,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Theme.of(context).backgroundColor,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 550,
                                  height: 5,
                                  child: LinearProgressIndicator(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      valueColor: AlwaysStoppedAnimation(
                                        Theme.of(context).colorScheme.primary,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    loadingText,
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 550,
                                  height: 5,
                                  child: LinearProgressIndicator(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      valueColor: AlwaysStoppedAnimation(
                                        Theme.of(context).colorScheme.primary,
                                      )),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        visible: _buttonVisible,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _buttonVisible = !_buttonVisible;
                              setState(() {});
                              pageNumber = pageNumber + 1;
                              getMoreWallpapers(widget.categoryName);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.primary,
                              onPrimary: textColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                            ),
                            child: Text(
                              loadMoreMessage,
                              style: TextStyle(
                                  fontFamily: 'Theme Bold',
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
        bottomNavigationBar: Container(
          height: 50,
          color: Colors.transparent,
          child: AdWidget(
            key: UniqueKey(),
            ad: AdServices.createBannerAd()..load(),
          ),
        ),
      );
    }
    if (imagesLoaded == false) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title:
              Text("CATEGORIES", style: Theme.of(context).textTheme.headline6),
          elevation: 5,
        ),
        body: Center(
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
                "Loading...",
                style: TextStyle(
                  fontFamily: 'Theme Bold',
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(iconColor),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold();
  }
}
