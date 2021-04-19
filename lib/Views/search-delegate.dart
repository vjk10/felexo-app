import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Views/search-view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WallpaperSearch extends SearchDelegate<String> {
  // final defaultSuggestions = ["Abstract", "Architexture"];
  List defaultSuggestions;
  List searchHistory;
  String uid;
  bool storeHistory;
  WallpaperSearch(
      this.defaultSuggestions, this.searchHistory, this.uid, this.storeHistory);

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 20,
                fontFamily: 'Theme Regular',
                color: Theme.of(context).colorScheme.primary),
            headline2: TextStyle(
                fontSize: 20,
                fontFamily: 'Theme Regular',
                color: Theme.of(context).colorScheme.primary),
            headline3: TextStyle(
                fontSize: 20,
                fontFamily: 'Theme Regular',
                color: Theme.of(context).colorScheme.primary),
            headline4: TextStyle(
                fontSize: 20,
                fontFamily: 'Theme Regular',
                color: Theme.of(context).colorScheme.primary),
            headline5: TextStyle(
                fontSize: 20,
                fontFamily: 'Theme Regular',
                color: Theme.of(context).colorScheme.primary),
            headline6: TextStyle(
                fontSize: 18,
                fontFamily: 'Theme Regular',
                color: Theme.of(context).colorScheme.primary)),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleSpacing: 0,
          textTheme: TextTheme(
              headline1: TextStyle(
                  fontFamily: 'Theme Regular',
                  color: Theme.of(context).colorScheme.primary),
              headline2: TextStyle(
                  fontFamily: 'Theme Regular',
                  color: Theme.of(context).colorScheme.primary),
              headline3: TextStyle(
                  fontFamily: 'Theme Regular',
                  color: Theme.of(context).colorScheme.primary),
              headline4: TextStyle(
                  fontFamily: 'Theme Regular',
                  color: Theme.of(context).colorScheme.primary),
              headline5: TextStyle(
                  fontFamily: 'Theme Regular',
                  color: Theme.of(context).colorScheme.primary),
              headline6: TextStyle(
                  fontFamily: 'Theme Regular',
                  color: Theme.of(context).colorScheme.primary)),
          toolbarTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Theme Regular'),
          titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Theme Regular'),
        ),
        inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            isDense: true,
            fillColor: Theme.of(context).colorScheme.primary.withAlpha(20),
            filled: true,
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'Theme Regular')));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    print(searchHistory);
    print(defaultSuggestions);
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Container(
          width: 0,
          height: 0,
          // decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Theme.of(context).colorScheme.primary.withAlpha(50),
          //     border:
          //         Border.all(color: Colors.redAccent.withAlpha(50), width: 3)),
          // child: Center(
          //   child: IconButton(
          //       icon: Icon(
          //         Icons.mic_outlined,
          //         size: 17,
          //         color: Theme.of(context).colorScheme.primary,
          //       ),
          //       onPressed: () {
          //         print("Recorder Function");
          //       }),
          // ),
        ),
      )
    ];
    // ignore: dead_code
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => MainView()),
          //     (route) => false);
          close(context, null);
        });
    // ignore: dead_code
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // return Center(
    //   child: Container(
    //     width: 100,
    //     height: 100,
    //     child: Text(
    //       query,
    //       style: Theme.of(context).textTheme.bodyText1,
    //     ),
    //   ),
    // );
    return SafeArea(
      child: SearchView(
        searchQuery: query,
      ),
    );
    // ignore: dead_code
    throw UnimplementedError();
  }

  @override
  void showResults(BuildContext context) {
    String suggestionString;
    suggestionString = query[0].toUpperCase() + query.substring(1);
    print(suggestionString);
    searchHistory.toList();
    if (searchHistory.isEmpty) {
      FirebaseFirestore.instance
          .collection("User")
          .doc(uid)
          .collection("SearchHistory")
          .doc(query.toString())
          .set({"searchHistory": suggestionString});
    }
    if (!searchHistory.contains(query)) {
      if (storeHistory) {
        FirebaseFirestore.instance
            .collection("SearchSuggestions")
            .doc(query.toString())
            .set({"term": suggestionString});
      }
      FirebaseFirestore.instance
          .collection("User")
          .doc(uid)
          .collection("SearchHistory")
          .doc(query.toString())
          .set({"searchHistory": suggestionString});

      searchHistory.insert(0, suggestionString);
    }

    super.showResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? searchHistory.isEmpty
            ? defaultSuggestions
            : searchHistory
        : defaultSuggestions
            .where((p) =>
                p.startsWith('${query[0].toUpperCase()}${query.substring(1)}'))
            .toList();
    var icon = query.isEmpty
        ? searchHistory.isEmpty
            ? Icons.insights_outlined
            : Icons.history
        : Icons.search;

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style: TextStyle(
                  fontFamily: 'Theme Regular', color: Colors.redAccent),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(
                        fontFamily: 'Theme Regular',
                        color: Theme.of(context).colorScheme.primary)),
              ]),
        ),
        trailing: InkWell(
          onTap: () {
            query = suggestionList[index].toString();
          },
          child: Icon(
            Icons.north_west_outlined,
            size: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
    // ignore: dead_code
    throw UnimplementedError();
  }
}
