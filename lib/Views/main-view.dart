import 'package:flutter/material.dart';

import 'views.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;

  final pages = [
    HomeView(),
    SearchView(),
    CategoriesView(),
    SettingsView(),
    ProfileView()
  ];

  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 15,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                expandedHeight: 250.0,
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
                // leading: Icon(Icons.brightness_4_outlined),
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
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: Material(
                        shadowColor: Theme.of(context).colorScheme.primary,
                        elevation: 10,
                        borderRadius: BorderRadius.circular(30),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30)),
                              hintText: "Search across the library of Pexels",
                              hintStyle: Theme.of(context).textTheme.caption,
                              prefixIcon: Icon(
                                Icons.search_sharp,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                backwardsCompatibility: true,
                collapsedHeight: 100,
                bottom: TabBar(
                  // isScrollable: true,
                  enableFeedback: true,
                  controller: _tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Theme.of(context).colorScheme.primary,
                  labelStyle: Theme.of(context).textTheme.button,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    const Tab(text: "Curated"),
                    const Tab(text: "Videos"),
                    const Tab(text: "Favorites"),
                    const Tab(text: "Categories"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              HomeView(),
              HomeView(),
              HomeView(),
              CategoriesView(),
            ],
          ),
        ),
      ),
    ));
  }
}
