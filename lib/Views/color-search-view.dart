import 'dart:convert';

import 'package:felexo/Color/colors.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:felexo/Widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ColorSearchView extends StatefulWidget {
  String color;

  ColorSearchView({this.color});

  @override
  _ColorSearchViewState createState() => _ColorSearchViewState();
}

class _ColorSearchViewState extends State<ColorSearchView> {
  TextEditingController searchController = new TextEditingController();
  bool searchComplete = false;
  int noOfImages = 30;
  int pageNumber = 1;
  String searchQery;
  String nextPage;
  String searchMessage = "Search for some amazing wallpapers!";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  Color chip = iconColor.withAlpha(60);
  List<WallpaperModel> wallpapers = [];
  bool _buttonVisible = true;

  @override
  void initState() {
    searchQery = widget.color;
    getSearchResults(widget.color);
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

  Future<List> getSearchResults(color) async {
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=photos&per_page=$noOfImages&color=$color"),
        headers: {"Authorization": apiKey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    // print(jsonData["next_page"].toString());
    nextPage = jsonData["next_page"].toString();
    jsonData["photos"].forEach((element) {
      // print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    searchComplete = true;
    setState(() {});
    return wallpapers;
  }

  Future<List> getMoreSearchResults(searchQuery) async {
    var response =
        await http.get(Uri.parse(nextPage), headers: {"Authorization": apiKey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    // print(jsonData["next_page"].toString());
    nextPage = jsonData["next_page"].toString();
    jsonData["photos"].forEach((element) {
      // print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    searchComplete = true;
    _buttonVisible = !_buttonVisible;
    setState(() {});
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
      appBar: AppBar(
        title: Text(
          "#" + widget.color,
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: wallpaperSearchGrid(
            wallpapers: wallpapers, context: context, uid: user.uid),
      ),
    );
  }
}
