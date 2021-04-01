import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Color/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WallpaperSearch extends SearchDelegate<String> {
  // final defaultSuggestions = ["Abstract", "Architexture"];
  var defaultSuggestions = [];
  final suggestions = FirebaseFirestore.instance;
  List searchHistory = [];
  WallpaperSearch(this.defaultSuggestions);

  @override
  List<Widget> buildActions(BuildContext context) {
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
    // TODO: implement buildResults
    throw UnimplementedError();
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
        title: Text(
          suggestionList[index],
          style: Theme.of(context).textTheme.subtitle2,
        ),
        trailing: Icon(
          Icons.north_west_outlined,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
    // ignore: dead_code
    throw UnimplementedError();
  }
}
