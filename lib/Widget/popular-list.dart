import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Model/pixabay-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class IllustrationList extends StatefulWidget {
  @override
  _IllustrationListState createState() => _IllustrationListState();
}

class _IllustrationListState extends State<IllustrationList> {
  var foregroundColor;
  bool imagesLoaded = true;
  List<PixaBayModel> wallpapers = [];

  @override
  void initState() {
    getIllustration();
    super.initState();
  }

  Future<List> getIllustration() async {
    var response = await http.get(Uri.parse("https://pixabay.com/api/?key=" +
        pbapiKey +
        "&category=backgrounds&order=latest&editors_choice=true&image_type=illustration&per_page=100"));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print(response.body);
    jsonData["hits"].forEach((item) {
      PixaBayModel wallpaperModel = new PixaBayModel();
      wallpaperModel = PixaBayModel.fromMap(item);
      wallpapers.add(wallpaperModel);
    });
    setState(() {});
    return wallpapers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: imagesLoaded
              ? GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  physics: BouncingScrollPhysics(),
                  childAspectRatio: 0.6,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  children: wallpapers.map((wallpaper) {
                    return GridTile(
                      child: Material(
                        type: MaterialType.card,
                        shadowColor: Theme.of(context).backgroundColor,
                        elevation: 5,
                        borderRadius: BorderRadius.circular(0),
                        child: Container(
                          decoration: BoxDecoration(
                              // color: Hexcolor(wallpaper.avgColor),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(0),
                              shape: BoxShape.rectangle),
                          child: Stack(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 0),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Loading Images...",
                                      style: TextStyle(
                                          color: foregroundColor,
                                          fontFamily: 'Theme Bold'),
                                    )
                                  ],
                                )
                              ],
                            ),
                            GestureDetector(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: CachedNetworkImage(
                                    imageUrl: wallpaper.imgUrl,
                                    fit: BoxFit.fitHeight,
                                    height: 800,
                                  )),
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     ScaleRoute(context,
                                //         page: WallPaperView(
                                //           avgColor: wallpaper.avgColor,
                                //           uid: uid,
                                //           photographerUrl:
                                //               wallpaper.photographerUrl,
                                //           imgUrl: wallpaper.src.portrait,
                                //           originalUrl: wallpaper.src.original,
                                //           photoID: wallpaper.photoID.toString(),
                                //           photographer: wallpaper.photographer,
                                //           photographerID: wallpaper
                                //               .photographerId
                                //               .toString(),
                                //         )));
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     ScaleRoute(context,
                                //         page: WallPaperView(
                                //           avgColor:
                                //               wallpaper.avgColor.toString(),
                                //           uid: uid,
                                //           photographerUrl:
                                //               wallpaper.photographerUrl,
                                //           imgUrl: wallpaper.src.portrait,
                                //           originalUrl: wallpaper.src.original,
                                //           photoID: wallpaper.photoID.toString(),
                                //           photographer: wallpaper.photographer,
                                //           photographerID: wallpaper
                                //               .photographerId
                                //               .toString(),
                                //         )));
                              },
                            )
                          ]),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
        ),
        SizedBox(
          height: 0,
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Visibility(
        //       visible: !_buttonVisible,
        //       child: Container(
        //         width: MediaQuery.of(context).size.width,
        //         height: 50,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.rectangle,
        //           color: Theme.of(context).backgroundColor,
        //         ),
        //         child: Column(
        //           children: [
        //             SizedBox(
        //               width: 550,
        //               height: 5,
        //               child: LinearProgressIndicator(
        //                   backgroundColor:
        //                       Theme.of(context).colorScheme.secondary,
        //                   valueColor: AlwaysStoppedAnimation(
        //                     Theme.of(context).colorScheme.primary,
        //                   )),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.only(top: 10.0),
        //               child: Text(
        //                 "LOADING...",
        //                 style: Theme.of(context).textTheme.button,
        //               ),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             SizedBox(
        //               width: 550,
        //               height: 5,
        //               child: LinearProgressIndicator(
        //                   backgroundColor:
        //                       Theme.of(context).colorScheme.secondary,
        //                   valueColor: AlwaysStoppedAnimation(
        //                     Theme.of(context).colorScheme.primary,
        //                   )),
        //             ),
        //           ],
        //         ),
        //       )),
        // ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Visibility(
        //     visible: _buttonVisible,
        //     child: Container(
        //       width: MediaQuery.of(context).size.width,
        //       height: 50,
        //       child: ElevatedButton(
        //         onPressed: () {
        //           _buttonVisible = !_buttonVisible;
        //           setState(() {});
        //           getMoreWallpapers();
        //         },
        //         style: ElevatedButton.styleFrom(
        //           primary: Theme.of(context).colorScheme.primary,
        //           onPrimary: textColor,
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(0)),
        //         ),
        //         child: Text(
        //           "LOAD MORE",
        //           style: TextStyle(
        //               fontFamily: 'Theme Bold',
        //               color: Theme.of(context).colorScheme.secondary),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
