import 'package:felexo/Widget/favorite-tile.dart';
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
      return GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return FavoriteTile(
              favorites: favorites[index],
            );
          });
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
            style: TextStyle(fontFamily: 'Circular Bold'),
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
