import 'dart:convert';

import 'package:felexo/Color/colors.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Services/animation-route.dart';
import 'package:felexo/Views/wallpaper-view.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer_animation/shimmer_animation.dart';

import '../Color/colors.dart';

class Curated extends StatefulWidget {
  @override
  _CuratedState createState() => _CuratedState();
}

class _CuratedState extends State<Curated> {
  List<WallpaperModel> wallpapers = [];
  bool _buttonVisible = false;
  bool loading = true;
  String wallpaperLocation,
      uid,
      imgUrl,
      originalUrl,
      photoID,
      photographer,
      photographerID,
      avgColor,
      nextPage,
      prevPage,
      photographerUrl;
  int noOfImages = 20;
  int pageNumber = 1;
  bool imagesLoaded = false;
  bool moreVisible = false;
  bool _foundLast = false;
  User user;
  var foregroundColor;
  Uri uri = Uri.parse(
      "https://api.pexels.com/v1/collections/thnxj4c?page=1&per_page=10&type=photos");

  @override
  void initState() {
    initUser();
    getLastPage();
    _buttonVisible = true;
    super.initState();
  }

  // Future<List> getTrendingWallpapers() async {
  //   var response = await http.get(
  //       Uri.parse("https://api.pexels.com/v1/curated?per_page=$noOfImages"),
  //       headers: {"Authorization": apiKey}); // print(response.body.toString());

  //   Map<String, dynamic> jsonData = jsonDecode(response.body);
  //   // print(jsonData["next_page"].toString());
  //   nextPage = jsonData["next_page"].toString();
  //   jsonData["photos"].forEach((element) {
  //     // print(element);
  //     WallpaperModel wallpaperModel = new WallpaperModel();
  //     wallpaperModel = WallpaperModel.fromMap(element);
  //     wallpapers.add(wallpaperModel);
  //   });
  //   // print("TrendingState");
  //   imagesLoaded = true;
  //   setState(() {});

  //   return wallpapers;
  // }

  // Future<List> getMoreWallpapers() async {
  //   var response =
  //       await http.get(Uri.parse(nextPage), headers: {"Authorization": apiKey});
  //   Map<String, dynamic> jsonData = jsonDecode(response.body);
  //   jsonData["photos"].forEach((element) {
  //     WallpaperModel wallpaperModel = new WallpaperModel();
  //     wallpaperModel = WallpaperModel.fromMap(element);
  //     wallpapers.add(wallpaperModel);
  //   });
  //   // print("Next" + jsonData["next_page"].toString());
  //   nextPage = jsonData["next_page"].toString();
  //   moreVisible = false;
  //   _buttonVisible = !_buttonVisible;
  //   setState(() {});
  //   return wallpapers;
  // }
  getLastPage() async {
    while (_foundLast == false) {
      var response = await http.get(uri, headers: {
        "Authorization": apiKey
      }); // print(response.body.toString());

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print("NEXTLOOP: " + jsonData["next_page"].toString());
      nextPage = jsonData["next_page"];
      if (nextPage == null) {
        print("URI: " + uri.toString());
        print("NEXT PAGE: " + nextPage.toString());
        getTrendingWallpapers(uri);
        _foundLast = true;
      } else {
        setState(() {
          uri = Uri.parse(nextPage);
        });
      }
    }
  }
  // do {
  //   var response = await http.get(
  //       Uri.parse(
  //           "https://api.pexels.com/v1/collections/thnxj4c?per_page=80&type=photos"),
  //       headers: {
  //         "Authorization": apiKey
  //       }); // print(response.body.toString());

  //   Map<String, dynamic> jsonData = jsonDecode(response.body);
  //   print("NEXT: " + jsonData["next_page"].toString());
  //   nextPage = jsonData["next_page"].toString();
  //   setState(() {});
  //   if (nextPage == null || nextPage == "") {
  //     setState(() {
  //       i = 1;
  //     });
  //   }
  // } while (i == 0);

  Future<List> getTrendingWallpapers(Uri _uri) async {
    var response = await http.get(_uri,
        headers: {"Authorization": apiKey}); // print(response.body.toString());
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print("NEXT: " + jsonData["prev_page"].toString());
    prevPage = jsonData["prev_page"].toString();
    print("TOTAL RESULTS: " + jsonData['total_results'].toString());
    if (prevPage == "null") {
      setState(() {
        loading = false;
      });
    }
    jsonData["media"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    wallpapers = wallpapers.reversed.toList();
    imagesLoaded = true;
    setState(() {});
    return wallpapers;
  }

  Future<List> getMoreWallpapers() async {
    var response =
        await http.get(Uri.parse(prevPage), headers: {"Authorization": apiKey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["media"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    // print("Next" + jsonData["next_page"].toString());
    prevPage = jsonData["prev_page"].toString();
    if (prevPage == "null") {
      setState(() {
        loading = false;
      });
    }
    moreVisible = false;
    _buttonVisible = !_buttonVisible;
    setState(() {});
    return wallpapers;
  }

  Future initUser() async {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    // print("User: " + user.uid.toString());
    uid = user.uid.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imagesLoaded
        ? Column(
            children: [
              SingleChildScrollView(
                  child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                physics: BouncingScrollPhysics(),
                childAspectRatio: 0.6,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
                children: wallpapers.map((wallpaper) {
                  foregroundColor =
                      Hexcolor(wallpaper.avgColor).computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white;
                  setState(() {});
                  return GridTile(
                    child: Material(
                      type: MaterialType.card,
                      shadowColor: Theme.of(context).backgroundColor,
                      elevation: 0,
                      borderRadius: BorderRadius.circular(0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Hexcolor(wallpaper.avgColor),
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
                                    loadingMessage,
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
                                child: Image.network(
                                  wallpaper.src.portrait,
                                  height: 800,
                                  fit: BoxFit.fill,
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  ScaleRoute(context,
                                      page: WallPaperView(
                                        avgColor: wallpaper.avgColor,
                                        uid: user.uid,
                                        photographerUrl:
                                            wallpaper.photographerUrl,
                                        imgUrl: wallpaper.src.portrait,
                                        originalUrl: wallpaper.src.original,
                                        photoID: wallpaper.photoID.toString(),
                                        photographer: wallpaper.photographer,
                                        photographerID:
                                            wallpaper.photographerId.toString(),
                                      )));
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  ScaleRoute(context,
                                      page: WallPaperView(
                                        avgColor: wallpaper.avgColor.toString(),
                                        uid: uid,
                                        photographerUrl:
                                            wallpaper.photographerUrl,
                                        imgUrl: wallpaper.src.portrait,
                                        originalUrl: wallpaper.src.original,
                                        photoID: wallpaper.photoID.toString(),
                                        photographer: wallpaper.photographer,
                                        photographerID:
                                            wallpaper.photographerId.toString(),
                                      )));
                            },
                          )
                        ]),
                      ),
                    ),
                  );
                }).toList(),
              )),
              SizedBox(
                height: 0,
              ),
              loading
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                          visible: !_buttonVisible,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Theme.of(context).backgroundColor,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 550,
                                  height: 5,
                                  child: LinearProgressIndicator(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      valueColor: AlwaysStoppedAnimation(
                                        Theme.of(context).colorScheme.primary,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    loadingText,
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 550,
                                  height: 5,
                                  child: LinearProgressIndicator(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      valueColor: AlwaysStoppedAnimation(
                                        Theme.of(context).colorScheme.primary,
                                      )),
                                ),
                              ],
                            ),
                          )),
                    )
                  : Container(),
              loading
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        visible: _buttonVisible,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _buttonVisible = !_buttonVisible;
                              setState(() {});
                              getMoreWallpapers();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.primary,
                              onPrimary: textColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                            ),
                            child: Text(
                              loadMoreMessage,
                              style: TextStyle(
                                  fontFamily: 'Theme Bold',
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
        : Shimmer(
            child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ));
  }
}

// Widget wallpaperGrid({@required context, @required String uid}) {
//   return Column(
//     children: [
//       Container(
//         child: GridView.count(
//           shrinkWrap: true,
//           crossAxisCount: 2,
//           physics: BouncingScrollPhysics(),
//           childAspectRatio: 0.6,
//           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//           mainAxisSpacing: 5.0,
//           crossAxisSpacing: 5.0,
//           children: wallpapers.map((wallpaper) {
//             return GridTile(
//               child: Material(
//                 type: MaterialType.card,
//                 shadowColor: Theme.of(context).backgroundColor,
//                 elevation: 5,
//                 borderRadius: BorderRadius.circular(12),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: HexColor(wallpaper.avgColor),
//                       borderRadius: BorderRadius.circular(12),
//                       shape: BoxShape.rectangle),
//                   child: Stack(children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(bottom: 10),
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Loading Images...",
//                               style: TextStyle(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   fontFamily: 'Circular Black'),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                     GestureDetector(
//                       child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             wallpaper.src.portrait,
//                             height: 800,
//                             fit: BoxFit.fill,
//                           )),
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             ScaleRoute(context,
//                                 page: WallPaperView(
//                                   avgColor: wallpaper.avgColor,
//                                   uid: uid,
//                                   photographerUrl: wallpaper.photographerUrl,
//                                   imgUrl: wallpaper.src.portrait,
//                                   originalUrl: wallpaper.src.original,
//                                   photoID: wallpaper.photoID.toString(),
//                                   photographer: wallpaper.photographer,
//                                   photographerID:
//                                       wallpaper.photographerId.toString(),
//                                 )));
//                       },
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             ScaleRoute(context,
//                                 page: WallPaperView(
//                                   avgColor: wallpaper.avgColor.toString(),
//                                   uid: uid,
//                                   photographerUrl: wallpaper.photographerUrl,
//                                   imgUrl: wallpaper.src.portrait,
//                                   originalUrl: wallpaper.src.original,
//                                   photoID: wallpaper.photoID.toString(),
//                                   photographer: wallpaper.photographer,
//                                   photographerID:
//                                       wallpaper.photographerId.toString(),
//                                 )));
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 200.0),
//                         child: Container(
//                           height: 200,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               gradient: LinearGradient(
//                                   colors: [
//                                     Colors.transparent,
//                                     Colors.black12,
//                                     Colors.black38,
//                                     Colors.black45
//                                   ],
//                                   begin: Alignment.center,
//                                   end: Alignment.bottomCenter)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.bottomLeft,
//                                       child: AutoSizeText(
//                                         wallpaper.photographer,
//                                         style: TextStyle(
//                                             color: textColor,
//                                             fontFamily: 'Circular Black',
//                                             fontSize: 20),
//                                         maxLines: 1,
//                                         minFontSize: 5,
//                                         maxFontSize: 8,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.bottomLeft,
//                                       child: AutoSizeText(
//                                         wallpaper.photographerId.toString(),
//                                         style: TextStyle(
//                                             color: textColor,
//                                             fontFamily: 'Circular Black',
//                                             fontSize: 15),
//                                         maxLines: 1,
//                                         minFontSize: 5,
//                                         maxFontSize: 10,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                     // Padding(
//                     //   padding: const EdgeInsets.only(bottom: 15.0),
//                     //   child: Align(
//                     //     alignment: Alignment.bottomRight,
//                     //     child: Hero(
//                     //       tag: wallpaper.src.portrait,
//                     //       child: IconButton(
//                     //         iconSize: 24,
//                     //         onPressed: () {
//                     //           Navigator.push(
//                     //               context,
//                     //               FadeRoute(context,
//                     //                   page: WallPaperView(
//                     //                     imgUrl: wallpaper.src.portrait,
//                     //                     photoID: wallpaper.photoID.toString(),
//                     //                     photographer: wallpaper.photographer,
//                     //                     photographerID:
//                     //                         wallpaper.photographerId.toString(),
//                     //                   )));
//                     //         },
//                     //         icon: Icon(
//                     //           Icons.open_in_new,
//                     //           color: Colors.black,
//                     //         ),
//                     //         splashColor: secondaryColor,
//                     //       ),
//                     //     ),
//                     //   ),
//                     // )
//                   ]),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     ],
//   );
// }
