import 'dart:convert';

import 'package:felexo/Color/colors.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Widget/widgets.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer_animation/shimmer_animation.dart';

class SearchView extends StatefulWidget {
  final String searchQuery;
  final bool appBarState;

  SearchView({@required this.searchQuery, @required this.appBarState});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
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
  bool _isLoading = true;
  bool _hasResults = true;
  bool loading = false;
  bool _appBar;

  @override
  void initState() {
    searchQery = widget.searchQuery;
    getSearchResults(widget.searchQuery);
    super.initState();
    _appBar = widget.appBarState;
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
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$searchQuery&per_page=$noOfImages"),
        headers: {"Authorization": apiKey});
    print("STATUS CODE: " + response.statusCode.toString());
    print("CONTENT LENGHT: " + response.contentLength.toString());
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    // print(jsonData["next_page"].toString());
    print("CONTENT LENGHT: " + jsonData['photos'].toString());
    if (jsonData['photos'].toList().isEmpty) {
      setState(() {
        _hasResults = false;
      });
      print("NO RESULTS");
    } else {
      setState(() {
        _hasResults = true;
      });
      print("RESULTS FOUND!");
    }
    nextPage = jsonData["next_page"].toString();
    if (nextPage == null) {
      setState(() {
        loading = false;
      });
    }
    if (nextPage != null) {
      setState(() {
        loading = true;
      });
    }
    jsonData["photos"].forEach((element) {
      // print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    searchComplete = true;
    _isLoading = false;
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
    return _appBar
        ? scaffoldWithAppBar(context)
        : scaffoldWithoutAppBar(context);
  }

  Scaffold scaffoldWithoutAppBar(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Shimmer(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            )
          : _hasResults
              ? SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: wallpaperSearchGrid(
                              wallpapers: wallpapers,
                              context: context,
                              uid: user.uid),
                        ),
                        loading
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Visibility(
                                  visible: !_buttonVisible,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        height: 60,
                                        child: Shimmer(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _buttonVisible = !_buttonVisible;
                                              setState(() {});
                                              getMoreSearchResults(
                                                  widget.searchQuery);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              primary: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              onPrimary: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              onSurface: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Theme.of(context)
                                                          .accentColor
                                                          .withOpacity(0.5),
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          00)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _buttonVisible = !_buttonVisible;
                                            setState(() {});
                                            getMoreSearchResults(
                                                widget.searchQuery);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            primary: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            onPrimary: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            onSurface: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                  ),
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 30,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "WE COULDN'T FIND ANY RESULTS FOR YOUR SEARCH!",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontFamily: 'Theme Black'),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
    );
  }

  Scaffold scaffoldWithAppBar(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.searchQuery.toUpperCase(),
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: _isLoading
          ? Shimmer(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            )
          : _hasResults
              ? SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: wallpaperSearchGrid(
                              wallpapers: wallpapers,
                              context: context,
                              uid: user.uid),
                        ),
                        loading
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Visibility(
                                  visible: !_buttonVisible,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        height: 60,
                                        child: Shimmer(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _buttonVisible = !_buttonVisible;
                                              setState(() {});
                                              getMoreSearchResults(
                                                  widget.searchQuery);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              primary: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              onPrimary: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              onSurface: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Theme.of(context)
                                                          .accentColor
                                                          .withOpacity(0.5),
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          00)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _buttonVisible = !_buttonVisible;
                                            setState(() {});
                                            getMoreSearchResults(
                                                widget.searchQuery);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            primary: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            onPrimary: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            onSurface: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                  ),
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 30,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "WE COULDN'T FIND ANY RESULTS FOR YOUR SEARCH!",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontFamily: 'Theme Black'),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
    );
  }
}
