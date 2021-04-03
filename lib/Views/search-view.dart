import 'dart:convert';

import 'package:felexo/Color/colors.dart';
import 'package:felexo/Widget/widgets.dart';
import 'package:felexo/data/data.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SearchView extends StatefulWidget {
  String searchQuery;

  SearchView({this.searchQuery});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = new TextEditingController();
  bool searchComplete = false;
  int noOfImages = 30;
  int pageNumber = 1;
  String searchQery;
  String searchMessage = "Search for some amazing wallpapers!";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  Color chip = iconColor.withAlpha(60);
  List<WallpaperModel> wallpapers = [];
  bool _buttonVisible = true;

  @override
  void initState() {
    searchQery = widget.searchQuery;
    getSearchResults(widget.searchQuery);
    super.initState();

    initUser();
  }

  initUser() async {
    user = _auth.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);

    setState(() {});
  }

  Future<List> getSearchResults(searchQuery) async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$searchQuery&per_page=$noOfImages"),
        headers: {"Authorization": apiKey}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      // print(value.body.toString());
      wallpapers = [];
      jsonData["photos"].forEach((element) {
        WallpaperModel wallpaperModel = new WallpaperModel();
        wallpaperModel = WallpaperModel.fromMap(element);
        wallpapers.add(wallpaperModel);
      });
      searchComplete = true;
      setState(() {});
    });
    return wallpapers;
  }

  Future<List> getMoreSearchResults(searchQuery) async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$searchQuery&page=$pageNumber&per_page=$noOfImages"),
        headers: {"Authorization": apiKey}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      // print(value.body.toString());
      wallpapers = [];
      jsonData["photos"].forEach((element) {
        WallpaperModel wallpaperModel = new WallpaperModel();
        wallpaperModel = WallpaperModel.fromMap(element);
        wallpapers.add(wallpaperModel);
      });
      searchComplete = true;
      if (pageNumber == 0) {
        pageNumber = 1;
      }
      _buttonVisible = !_buttonVisible;
      setState(() {});
    });
    return wallpapers;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: wallpaperSearchGrid(
                  wallpapers: wallpapers, context: context, uid: user.uid),
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).colorScheme.primary,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "LOADING NEXT PAGE...",
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
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
                      pageNumber = pageNumber + 1;
                      setState(() {});
                      getMoreSearchResults(widget.searchQuery);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      onPrimary: textColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    child: Text(
                      "GO TO NEXT PAGE",
                      style: TextStyle(
                          fontFamily: 'Theme Bold',
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
