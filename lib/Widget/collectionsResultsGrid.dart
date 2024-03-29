import 'dart:convert';

import 'package:felexo/Color/colors.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Model/wallpapers-model.dart';
import 'package:felexo/Services/animation-route.dart';
import 'package:felexo/Views/views.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer_animation/shimmer_animation.dart';

class CRGrid extends StatefulWidget {
  final String collectionsID;
  CRGrid({@required this.collectionsID});
  @override
  _CRGridState createState() => _CRGridState();
}

class _CRGridState extends State<CRGrid> {
  List<WallpaperModel> wallpapers = [];
  bool _buttonVisible = false;
  bool loading = true;
  String wallpaperLocation,
      uid,
      imgUrl,
      originalUrl,
      photoID,
      photographer,
      photographerID,
      avgColor,
      nextPage,
      photographerUrl;
  int noOfImages = 20;
  int pageNumber = 1;
  bool imagesLoaded = false;
  bool moreVisible = false;
  User user;
  var foregroundColor;

  @override
  void initState() {
    initUser();
    getTrendingWallpapers();
    _buttonVisible = true;
    super.initState();
  }

  Future<List> getTrendingWallpapers() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/collections/" +
            widget.collectionsID +
            "?&type=photos&page=$pageNumber&per_page=$noOfImages"),
        headers: {"Authorization": apiKey}); // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print("NEXT: " + jsonData["next_page"].toString());
    nextPage = jsonData["next_page"].toString();
    if (nextPage == "null") {
      setState(() {
        loading = false;
      });
    }
    jsonData["media"].forEach((element) {
      // print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    // print("TrendingState");
    imagesLoaded = true;
    setState(() {});
    return wallpapers;
  }

  Future<List> getMoreWallpapers() async {
    var response =
        await http.get(Uri.parse(nextPage), headers: {"Authorization": apiKey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["media"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    // print("Next" + jsonData["next_page"].toString());
    nextPage = jsonData["next_page"].toString();
    if (nextPage == "null") {
      setState(() {
        loading = false;
      });
    }
    moreVisible = false;
    _buttonVisible = !_buttonVisible;
    setState(() {});
    return wallpapers;
  }

  Future initUser() async {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    // print("User: " + user.uid.toString());
    uid = user.uid.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imagesLoaded
        ? SafeArea(
            child: Column(
              children: [
                SingleChildScrollView(
                    child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  physics: BouncingScrollPhysics(),
                  childAspectRatio: 0.6,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  children: wallpapers.map((wallpaper) {
                    foregroundColor =
                        Hexcolor(wallpaper.avgColor).computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white;
                    setState(() {});
                    return GridTile(
                      child: Material(
                        type: MaterialType.card,
                        shadowColor: Theme.of(context).backgroundColor,
                        elevation: 5,
                        borderRadius: BorderRadius.circular(0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Hexcolor(wallpaper.avgColor),
                              borderRadius: BorderRadius.circular(0),
                              shape: BoxShape.rectangle),
                          child: Stack(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 0),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      loadingMessage,
                                      style: TextStyle(
                                          color: foregroundColor,
                                          fontFamily: 'Theme Bold'),
                                    )
                                  ],
                                )
                              ],
                            ),
                            GestureDetector(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Image.network(
                                    wallpaper.src.portrait,
                                    height: 800,
                                    fit: BoxFit.fill,
                                  )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    ScaleRoute(context,
                                        page: WallPaperView(
                                          avgColor: wallpaper.avgColor,
                                          uid: user.uid,
                                          photographerUrl:
                                              wallpaper.photographerUrl,
                                          imgUrl: wallpaper.src.portrait,
                                          originalUrl: wallpaper.src.original,
                                          photoID: wallpaper.photoID.toString(),
                                          photographer: wallpaper.photographer,
                                          photographerID: wallpaper
                                              .photographerId
                                              .toString(),
                                        )));
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    ScaleRoute(context,
                                        page: WallPaperView(
                                          avgColor:
                                              wallpaper.avgColor.toString(),
                                          uid: uid,
                                          photographerUrl:
                                              wallpaper.photographerUrl,
                                          imgUrl: wallpaper.src.portrait,
                                          originalUrl: wallpaper.src.original,
                                          photoID: wallpaper.photoID.toString(),
                                          photographer: wallpaper.photographer,
                                          photographerID: wallpaper
                                              .photographerId
                                              .toString(),
                                        )));
                              },
                            )
                          ]),
                        ),
                      ),
                    );
                  }).toList(),
                )),
                loading
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Visibility(
                          visible: !_buttonVisible,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 20,
                                height: 60,
                                child: Shimmer(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _buttonVisible = !_buttonVisible;
                                      setState(() {});
                                      getMoreWallpapers();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      onPrimary:
                                          Theme.of(context).colorScheme.primary,
                                      onSurface:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .accentColor
                                                  .withOpacity(0.5),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(00)),
                                    ),
                                    child: Text(
                                      loadingMessage,
                                      style: TextStyle(
                                          fontFamily: 'Theme Bold',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                loading
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Visibility(
                          visible: _buttonVisible,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 20,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _buttonVisible = !_buttonVisible;
                                    setState(() {});
                                    getMoreWallpapers();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    onPrimary:
                                        Theme.of(context).colorScheme.primary,
                                    onSurface:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.5),
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(00)),
                                  ),
                                  child: Text(
                                    loadMoreMessage,
                                    style: TextStyle(
                                        fontFamily: 'Theme Bold',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          )
        : Shimmer(
            child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ));
  }
}
