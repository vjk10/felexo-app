import 'package:felexo/Services/favorites-list.dart';
import 'package:felexo/Views/wallpaper-view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoriteTile extends StatefulWidget {
  final Favorites favorites;
  FavoriteTile({this.favorites});

  @override
  _FavoriteTileState createState() => _FavoriteTileState();
}

class _FavoriteTileState extends State<FavoriteTile> {
  User user;

  @override
  initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    print("User: " + user.uid.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Material(
        type: MaterialType.card,
        elevation: 5,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
              shape: BoxShape.rectangle),
          child: Stack(alignment: Alignment.center, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Loading Images...",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: 'Circular Bold'),
                    )
                  ],
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WallPaperView(
                            uid: user.uid,
                            imgUrl: widget.favorites.imgUrl,
                            originalUrl: widget.favorites.originalUrl,
                            photoID: widget.favorites.photoID.toString(),
                            photographer: widget.favorites.photographer,
                            photographerID: widget.favorites.photographerID,
                            photographerUrl:
                                widget.favorites.photographerUrl)));
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FadeInImage.assetNetwork(
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                      fadeInCurve: Curves.easeIn,
                      fadeInDuration: const Duration(seconds: 1),
                      placeholder: "assets/images/loading.gif",
                      image: widget.favorites.imgUrl)),
            ),
          ]),
        ),
      ),
    );
  }
}
