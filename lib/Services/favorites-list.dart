import 'package:felexo/Color/colors.dart';
import 'package:felexo/Views/wallpaper-view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FavoritesList extends StatefulWidget {
  @override
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  var foregroundColor;

  @override
  void initState() {
    super.initState();

    initUser();
  }

  initUser() async {
    user = _auth.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<List<Favorites>>(context);

    if (favorites.length.toInt() == 0) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/lottie/404.json", width: 150, height: 150)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No Favorites Added Yet!",
                    style: Theme.of(context).textTheme.headline6),
              ],
            )
          ],
        ),
      );
    }
    if (favorites.length != null) {
      // return ListView.builder(
      //   scrollDirection: Axis.horizontal,
      //   itemCount: favorites.length,
      //   itemBuilder: (context, index) {
      //     return FavoriteTile(favorites: favorites[index]);
      //   },
      // );
      // return GridView.builder(
      //     gridDelegate:
      //         SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: ),
      //     itemCount: favorites.length,
      //     itemBuilder: (context, index) {
      //       return FavoriteTile(
      //         favorites: favorites[index],
      //       );
      //     });
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        physics: BouncingScrollPhysics(),
        childAspectRatio: 0.6,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        children: favorites.map((favorite) {
          foregroundColor = Hexcolor(favorite.avgColor).computeLuminance() > 0.5
              ? Colors.black
              : Colors.white;
          setState(() {});
          return GridTile(
            child: Material(
              type: MaterialType.card,
              shadowColor: Theme.of(context).backgroundColor,
              elevation: 5,
              borderRadius: BorderRadius.circular(0),
              child: Container(
                decoration: BoxDecoration(
                    color: Hexcolor(favorite.avgColor),
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
                                fontFamily: 'Theme Black'),
                          )
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.network(
                          favorite.imgUrl,
                          height: 800,
                          fit: BoxFit.fill,
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WallPaperView(
                                  avgColor: favorite.avgColor,
                                  uid: user.uid,
                                  imgUrl: favorite.imgUrl,
                                  originalUrl: favorite.originalUrl,
                                  photoID: favorite.photoID.toString(),
                                  photographer: favorite.photographer,
                                  photographerID: favorite.photographerID,
                                  photographerUrl: favorite.photographerUrl)));
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WallPaperView(
                                  avgColor: favorite.avgColor,
                                  uid: user.uid,
                                  imgUrl: favorite.imgUrl,
                                  originalUrl: favorite.originalUrl,
                                  photoID: favorite.photoID.toString(),
                                  photographer: favorite.photographer,
                                  photographerID: favorite.photographerID,
                                  photographerUrl: favorite.photographerUrl)));
                    },
                    // child: Padding(
                    //   padding: const EdgeInsets.only(top: 200.0),
                    //   child: Container(
                    //     height: 200,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(0),
                    //         gradient: LinearGradient(
                    //             colors: [
                    //               Colors.transparent,
                    //               Colors.black12,
                    //               Colors.black38,
                    //               Colors.black45
                    //             ],
                    //             begin: Alignment.center,
                    //             end: Alignment.bottomCenter)),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         crossAxisAlignment:
                    //             CrossAxisAlignment.end,
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           Row(
                    //             children: [
                    //               Align(
                    //                 alignment: Alignment.bottomLeft,
                    //                 child: AutoSizeText(
                    //                   wallpaper.photographer,
                    //                   style: TextStyle(
                    //                       color: textColor,
                    //                       fontFamily:
                    //                           'Circular Black',
                    //                       fontSize: 20),
                    //                   maxLines: 1,
                    //                   minFontSize: 5,
                    //                   maxFontSize: 8,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           Row(
                    //             children: [
                    //               Align(
                    //                 alignment: Alignment.bottomLeft,
                    //                 child: AutoSizeText(
                    //                   wallpaper.photographerId
                    //                       .toString(),
                    //                   style: TextStyle(
                    //                       color: textColor,
                    //                       fontFamily:
                    //                           'Circular Black',
                    //                       fontSize: 15),
                    //                   maxLines: 1,
                    //                   minFontSize: 5,
                    //                   maxFontSize: 10,
                    //                 ),
                    //               ),
                    //             ],
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  )
                ]),
              ),
            ),
          );
        }).toList(),
      );
    }
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
          ),
          Text(
            "Finding Favorites...",
            style: TextStyle(fontFamily: 'Theme Bold'),
          )
        ],
      ),
    );
  }
}

class Favorites {
  final String imgUrl;
  final String originalUrl;
  final String photographerUrl;
  final String photoID;
  final String photographerID;
  final String photographer;
  final String avgColor;

  Favorites(
      {this.imgUrl,
      this.originalUrl,
      this.photoID,
      this.photographer,
      this.photographerID,
      this.avgColor,
      this.photographerUrl})
      : assert(imgUrl != null),
        assert(originalUrl != null),
        assert(photoID != null),
        assert(avgColor != null),
        assert(photographer != null),
        assert(photographerID != null),
        assert(photographerUrl != null);
}
