import 'dart:convert';

import 'package:felexo/Data/data.dart';
import 'package:felexo/Model/pixabay-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class CollectionsView extends StatefulWidget {
  @override
  _CollectionsViewState createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  bool dark;
  bool illustrationLoaded = false;
  List<PixaBayModel> wallpapers = [];
  @override
  void initState() {
    getPixabay();
    super.initState();
  }

  Future<List> getPixabay() async {
    var response = await http.get(Uri.parse("https://pixabay.com/api/?key=" +
        pbapiKey +
        "&category=backgrounds&order=latest&editors_choice=true&image_type=illustration&per_page=10"));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print(response.body);
    jsonData["hits"].forEach((item) {
      PixaBayModel wallpaperModel = new PixaBayModel();
      wallpaperModel = PixaBayModel.fromMap(item);
      wallpapers.add(wallpaperModel);
    });
    illustrationLoaded = true;
    setState(() {});
    return wallpapers;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.platformBrightnessOf(context) == Brightness.dark) {
      dark = true;
      setState(() {});
    }
    if (MediaQuery.platformBrightnessOf(context) == Brightness.light) {
      dark = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: Text(
          "ADD A COLLECTION",
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                illustrationLoaded
                    ? Row(
                        children: [
                          Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return Material(
                                elevation: 0,
                                borderRadius: BorderRadius.circular(10),
                                shadowColor:
                                    Theme.of(context).colorScheme.primary,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    wallpapers.elementAt(index).imgUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            duration: 1000,
                            itemCount: wallpapers.length,
                            itemWidth: 300.0,
                            itemHeight: 300.0,
                            layout: SwiperLayout.TINDER,
                            containerHeight: 300,
                            containerWidth: 300,
                            autoplay: true,
                            scrollDirection: Axis.vertical,
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                              "ILLUSTRATIONS",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          )
                        ],
                      )
                    : Container(
                        width: 300,
                        height: 300,
                      ),
              ],
            ),
          ]),
    );
  }
}
