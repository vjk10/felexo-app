import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Services/push-notifications.dart';
import 'package:felexo/Views/collections-view.dart';
import 'package:felexo/Views/search-delegate.dart';
import 'package:felexo/Widget/wallpaper-controls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
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
  bool storeHistory = true;
  bool subscription = true;
  bool isDark = true;
  PushNotificationService fcmNotification;

  final myTabs = [
    const Tab(text: "CURATED"),
    const Tab(text: "COLLECTIONS"),
    const Tab(text: "FAVORITES"),
    const Tab(text: "CATEGORIES"),
  ];

  @override
  void initState() {
    initUser();
    findIfStoreHistory();
    fetchSuggestions();
    fcmNotification = PushNotificationService();
    fcmNotification.initialize();
    fetchHistory();
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  initUser() {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    handleAsync();

    // print("User: " + user.uid.toString());
  }

  handleAsync() async {
    FirebaseFirestore.instance
        .collection("User")
        .doc(user.uid)
        .snapshots()
        .forEach((element) {
      if (element.data()["subscribedToNotifications"] == true) {
        fcmNotification.subscribeToTopic('notification');
      }
      if (element.data()["subscribedToNotifications"] == false) {
        fcmNotification.unSubscribeToTopic('notification');
      }
    });
  }

  findIfStoreHistory() {
    FirebaseFirestore.instance
        .collection("User")
        .doc(user.uid.toString())
        .snapshots()
        .forEach((element) {
      setState(() {
        storeHistory = element.data()["storeHistory"];
        print("Mainsh" + storeHistory.toString());
      });
    });
    setState(() {});
  }

  Future<List> fetchSuggestions() async {
    suggestions
        .collection("SearchSuggestions")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.map((e) {
        defaultSuggestions.add(e.get("term"));
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
        searchHistory.add(e.get("searchHistory").toString());
      }).toList();
    });
    return searchHistory;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TabBar get _tabBar => TabBar(
      isScrollable: true,
      enableFeedback: true,
      controller: _tabController,
      dragStartBehavior: DragStartBehavior.down,
      labelColor: Theme.of(context).colorScheme.primary,
      unselectedLabelColor: Theme.of(context).accentColor,
      labelStyle: TextStyle(fontSize: 12, fontFamily: 'Theme Bold'),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 4,
      indicatorColor: Theme.of(context).colorScheme.primary,
      indicator: MD2Indicator(
          indicatorHeight: 5,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorSize: MD2IndicatorSize.full),
      tabs: myTabs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
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
                            child: CircleAvatar(
                              radius: 18,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(user.photoURL),
                              ),
                            )))
                  ],
                  shadowColor: Theme.of(context).colorScheme.secondary,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [
                      StretchMode.fadeTitle,
                      StretchMode.blurBackground
                    ],
                    centerTitle: true,
                    background: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 10, right: 10, bottom: 0),
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 45.0, bottom: 30),
                                child: Text(
                                  "A LIBRARY OF AMAZING WALLPAPERS!",
                                  style: TextStyle(fontSize: 12),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  findIfStoreHistory();
                                });
                                showSearch(
                                    context: context,
                                    delegate: WallpaperSearch(
                                        defaultSuggestions,
                                        searchHistory,
                                        user.uid.toString(),
                                        storeHistory,
                                        isDark));
                              },
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.5)),
                                  ),
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 54,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Icon(Icons.search),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "SEARCH ACROSS THE LIBRARY OF PEXELS",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  backwardsCompatibility: true,
                  collapsedHeight: 80,
                  bottom: _tabBar,
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
