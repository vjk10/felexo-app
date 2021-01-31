import 'dart:convert';

import 'package:felexo/Color/colors.dart';
import 'package:felexo/data/data.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:felexo/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = new TextEditingController();
  bool searchComplete = false;
  int noOfImages = 30;
  String searchMessage = "Search for some amazing wallpapers!";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  Color chip = iconColor.withAlpha(60);
  List<WallpaperModel> wallpapers = new List();

  @override
  void initState() {
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

  void getSearchResults(String searchQuery) async {
    await http.get(
        "https://api.pexels.com/v1/search?query=$searchQuery&per_page=$noOfImages",
        headers: {"Authorization": apiKey}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      // print(value.body.toString());
      wallpapers = new List();
      jsonData["photos"].forEach((element) {
        WallpaperModel wallpaperModel = new WallpaperModel();
        wallpaperModel = WallpaperModel.fromMap(element);
        wallpapers.add(wallpaperModel);
      });
      searchComplete = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (searchComplete == false) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Search", style: Theme.of(context).textTheme.headline6),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontFamily: 'Circular Bold'),
                            controller: searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search for wallpapers",
                            ),
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (String str) {
                              str = searchController.text;
                              getSearchResults(str);
                            },
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                "Search powered by Pexels",
                style: TextStyle(fontFamily: 'Circular Bold', fontSize: 12),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => {getSearchResults("color:black")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "black",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:white")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "white",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:red")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "red",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:yellow")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "yellow",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.yellow,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:purple")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "purple",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.purple,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:blue")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "blue",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:brown")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "brown",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.brown,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:green")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "green",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:pink")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "pink",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.pink,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              Container(
                child: Column(
                  children: [
                    Lottie.asset("assets/lottie/search.json",
                        width: 150, height: 150),
                    SizedBox(
                      height: 10,
                    ),
                    Text(searchMessage),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    if (searchComplete == true) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Search", style: Theme.of(context).textTheme.headline6),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontFamily: 'Circular Bold'),
                            controller: searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search for wallpapers",
                            ),
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (String str) {
                              str = searchController.text;
                              getSearchResults(str);
                            },
                            onTap: () {
                              searchComplete = false;
                              setState(() {});
                            },
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                "Search powered by Pexels",
                style: TextStyle(fontFamily: 'Circular Bold', fontSize: 12),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => {getSearchResults("color:black")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "black",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:white")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "white",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:red")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "red",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:yellow")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "yellow",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.yellow,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:purple")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "purple",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.purple,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:blue")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "blue",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:brown")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "brown",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.brown,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:green")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "green",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => {getSearchResults("color:pink")},
                        child: ColorChips(
                          chipColor: chip,
                          colorchip: "pink",
                          backgroundchip:
                              Theme.of(context).colorScheme.secondary,
                          foregroundchip: Colors.pink,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: wallpaperGrid(
                      wallpapers: wallpapers, context: context, uid: user.uid),
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
