import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Views/search-view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WallpaperSearch extends SearchDelegate<String> {
  // final defaultSuggestions = ["Abstract", "Architexture"];
  List defaultSuggestions;
  List searchHistory;
  String uid;
  WallpaperSearch(this.defaultSuggestions, this.searchHistory, this.uid);

  get http => null;

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleSpacing: 0,
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
    return [
      IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            query = "";
          })
    ];
    // ignore: dead_code
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(
          CupertinoIcons.back,
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
    searchHistory.toList();
    if (searchHistory.isEmpty) {
      FirebaseFirestore.instance
          .collection("User")
          .doc(uid)
          .collection("SearchHistory")
          .doc(query.toString())
          .set({"searchHistory": query.toString()});
    }
    if (!searchHistory.contains(query)) {
      FirebaseFirestore.instance
          .collection("User")
          .doc(uid)
          .collection("SearchHistory")
          .doc(query.toString())
          .set({"searchHistory": query.toString()});
      FirebaseFirestore.instance
          .collection("SearchSuggestions")
          .doc(query.toString())
          .set({"term": query.toString()});
      searchHistory.insert(0, query);
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
                  fontFamily: 'Theme Bold',
                  color: Theme.of(context).colorScheme.primary),
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
