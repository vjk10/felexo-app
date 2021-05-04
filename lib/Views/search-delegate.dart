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
  bool isDark;
  WallpaperSearch(this.defaultSuggestions, this.searchHistory, this.uid,
      this.storeHistory, this.isDark)
      : super(
            searchFieldLabel: "Search by keywords or color",
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search);

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
                fontSize: 16,
                fontFamily: 'Theme Regular',
                color: Theme.of(context).colorScheme.primary)),
        appBarTheme: AppBarTheme(
          shadowColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          titleSpacing: 0,
          elevation: 0,
          toolbarTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Theme Regular'),
          titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Theme Regular'),
        ),
        inputDecorationTheme: InputDecorationTheme(
            contentPadding:
                const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 15),
            isDense: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Theme.of(context).accentColor.withAlpha(80),
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide.none),
            hintStyle: TextStyle(
                fontSize: 12,
                color: Theme.of(context).accentColor,
                fontFamily: 'Theme Regular')));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    print(searchHistory);
    print(defaultSuggestions);
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor.withOpacity(0.5),
                  shape: BoxShape.circle),
              child: Center(
                child: InkWell(
                  onTap: () {
                    query = '';
                  },
                  child: Icon(
                    Icons.clear,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
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
    if (!searchHistory.contains(suggestionString)) {
      if (storeHistory) {
        FirebaseFirestore.instance
            .collection("SearchSuggestions")
            .doc(suggestionString.toString())
            .set({"term": suggestionString});
        if (!defaultSuggestions.contains(suggestionString)) {
          defaultSuggestions.insert(0, suggestionString);
        }
      }
      FirebaseFirestore.instance
          .collection("User")
          .doc(uid)
          .collection("SearchHistory")
          .doc(query.toString())
          .set({"searchHistory": suggestionString});
      if (!searchHistory.contains(suggestionString)) {
        searchHistory.insert(0, suggestionString);
      }
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
        // onTap: () {
        //   query = suggestionList[index].toString();
        //   showResults(context);
        // },
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: InkWell(
          onTap: () {
            query = suggestionList[index].toString();
            showResults(context);
          },
          child: RichText(
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
