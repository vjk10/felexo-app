import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Views/collections-view.dart';
import 'package:felexo/Views/search-delegate.dart';
import 'package:felexo/Widget/wallpaper-controls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final suggestions = FirebaseFirestore.instance;
  final history = FirebaseFirestore.instance;
  bool storeHistory;

  final myTabs = [
    const Tab(text: "CURATED"),
    const Tab(text: "COLLECTIONS"),
    const Tab(text: "FAVORITES"),
    const Tab(text: "CATEGORIES"),
  ];

  @override
  void initState() {
    initUser();
    fetchSuggestions();
    fetchHistory();
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  initUser() {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    FirebaseFirestore.instance
        .collection("User")
        .doc(user.uid.toString())
        .snapshots()
        .forEach((element) {
      storeHistory = element.data()["storeHistory"];
    });
    // print("User: " + user.uid.toString());
  }

  Future<List> fetchSuggestions() async {
    suggestions
        .collection("SearchSuggestions")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.map((e) {
        defaultSuggestions.add(e.data()["term"]);
      }).toList();
    });
    return defaultSuggestions;
  }

  Future<List> fetchHistory() async {
    history
        .collection("User")
        .doc(user.uid.toString())
        .collection("SearchHistory")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.map((e) {
        searchHistory.add(e.data()["searchHistory"].toString());
      }).toList();
    });
    return searchHistory;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  // elevation: 15,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  expandedHeight: 220.0,
                  floating: true,
                  pinned: true,
                  centerTitle: true,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "FELEXO",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsView(
                                  storeHistory: storeHistory,
                                )));
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: CircleAvatar(
                            radius: 17,
                            backgroundColor: Colors.redAccent,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundImage: NetworkImage(
                                user.photoURL,
                              ),
                            ),
                          )),
                    )
                  ],
                  forceElevated: true,
                  shadowColor: Theme.of(context).colorScheme.primary,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [
                      StretchMode.fadeTitle,
                      StretchMode.blurBackground
                    ],
                    centerTitle: true,
                    background: Padding(
                      padding:
                          const EdgeInsets.only(top: 45.0, left: 10, right: 10),
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text(
                                  "A library of amazing wallpapers!",
                                  style: TextStyle(fontSize: 16),
                                ),
                              )),
                          InkWell(
                            onTap: () async {
                              await fetchHistory().whenComplete(() {
                                fetchSuggestions().whenComplete(() {
                                  showSearch(
                                      context: context,
                                      delegate: WallpaperSearch(
                                        defaultSuggestions,
                                        searchHistory,
                                        user.uid.toString(),
                                        storeHistory,
                                      ));
                                });
                              });
                            },
                            child: Center(
                              child: Material(
                                  shadowColor:
                                      Theme.of(context).colorScheme.primary,
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 54,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(Icons.search),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                            "Search across the library of Pexels")
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  backwardsCompatibility: true,
                  collapsedHeight: 80,
                  bottom: TabBar(
                      isScrollable: true,
                      enableFeedback: true,
                      controller: _tabController,
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.primary,
                      labelStyle:
                          TextStyle(fontSize: 12, fontFamily: 'Theme Bold'),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: myTabs),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                HomeView(),
                CollectionsView(),
                FavoritesView(),
                CategoriesView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
