import 'dart:convert';

import 'package:felexo/Data/data.dart';
import 'package:felexo/Model/collections-model.dart';
import 'package:felexo/Model/wallpapers-model.dart';
import 'package:felexo/Views/collectionsResultView.dart';
import 'package:felexo/Widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class CollectionsGrid extends StatefulWidget {
  @override
  _CollectionsGridState createState() => _CollectionsGridState();
}

class _CollectionsGridState extends State<CollectionsGrid> {
  List<CollectionsModel> collections = [];
  List<WallpaperModel> collectionsResult = [];
  String collectionID;
  int totalResults;
  SliverGridDelegate gridDelegate;
  bool hasDesc = false;
  @override
  void initState() {
    getCollections();
    super.initState();
  }

  getCollections() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/collections?page=1&per_page=250"),
        headers: {"Authorization": apiKey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    totalResults = jsonData["total_results"];
    // print("COLLECTIONTOTAL " + jsonData["total_results"].toString());
    jsonData["collections"].forEach((element) {
      CollectionsModel collectionsModel = new CollectionsModel();
      collectionsModel = CollectionsModel.fromMap(element);
      collections.add(collectionsModel);
    });
    // print(response.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 1,
        physics: BouncingScrollPhysics(),
        childAspectRatio: 1.2,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        children: collections.map((collection) {
          setState(() {});
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => CRView(
                                      collectionID: collection.collectionId,
                                      collectionName:
                                          collection.collectionTitle,
                                    )));
                      },
                      child: CRPreview(
                          collectionsID: collection.collectionId.toString())),
                  SizedBox(
                    height: 5,
                  ),
                  Material(
                    elevation: 10,
                    shadowColor: Theme.of(context).colorScheme.primary,
                    child: Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: MediaQuery.of(context).size.width - 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        collection.collectionTitle
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            fontSize: 24,
                                            fontFamily: 'Theme Black'),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        collection.collectionDescription,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.photo_library_outlined,
                                    size: 14,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    collection.photosCount,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
