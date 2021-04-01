import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Views/collections-view.dart';
import 'package:felexo/Views/search-delegate.dart';
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

  List defaultSuggestions = [];

  final pages = [
    HomeView(),
    SearchView(),
    CategoriesView(),
    SettingsView(),
    ProfileView()
  ];

  final myTabs = [
    const Tab(text: "Curated"),
    const Tab(text: "Collections"),
    const Tab(text: "Favorites"),
    const Tab(text: "Categories"),
  ];

  @override
  void initState() {
    fetchSuggestions();
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  void fetchSuggestions() async {
    suggestions.collection("Categories").get().then((QuerySnapshot snapshot) {
      snapshot.docs.map((e) {
        // print(e.data()["CategoryName"]);
        defaultSuggestions.add(e.data()["CategoryName"]);
      }).toList();
    });
    print(defaultSuggestions.toString());
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
          length: myTabs.length,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 15,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  expandedHeight: 200.0,
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
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsView()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.settings_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
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
                          const EdgeInsets.only(top: 40.0, left: 10, right: 10),
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text("A library of amazing wallpapers!"),
                              )),
                          InkWell(
                            onTap: () {
                              showSearch(
                                  context: context,
                                  delegate:
                                      WallpaperSearch(defaultSuggestions));
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
                      labelStyle: Theme.of(context).textTheme.button,
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
