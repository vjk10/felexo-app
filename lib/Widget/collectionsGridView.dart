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
import 'package:shimmer_animation/shimmer_animation.dart';

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
  bool isLoading = true;
  @override
  void initState() {
    getCollections();
    super.initState();
  }

  getCollections() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/collections?page=1&per_page=80"),
        headers: {"Authorization": apiKey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    totalResults = jsonData["total_results"];
    // print("COLLECTIONTOTAL " + jsonData["total_results"].toString());
    jsonData["collections"].forEach((element) {
      CollectionsModel collectionsModel = new CollectionsModel();
      collectionsModel = CollectionsModel.fromMap(element);
      if (element['id'] != "thnxj4c") {
        collections.add(collectionsModel);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer(
            duration: Duration(seconds: 3),
            interval: Duration(seconds: 0),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            enabled: true,
            direction: ShimmerDirection.fromLTRB(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          )
        : SingleChildScrollView(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => CRView(
                                            collectionID:
                                                collection.collectionId,
                                            collectionName:
                                                collection.collectionTitle,
                                          )));
                            },
                            child: CRPreview(
                                collectionsID:
                                    collection.collectionId.toString())),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.5),
                                      width: 1),
                                  color: Theme.of(context).cardColor,
                                ),
                                width: MediaQuery.of(context).size.width - 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 10, bottom: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                collection.collectionTitle
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontSize: 24,
                                                    fontFamily: 'Theme Black'),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                collection.collectionDescription
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.photo_library_outlined,
                                            size: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            collection.photosCount,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
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
