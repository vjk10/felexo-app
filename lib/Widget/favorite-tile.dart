import 'package:felexo/Services/favorites-list.dart';
import 'package:felexo/Views/wallpaper-view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:felexo/Color/colors.dart';

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
    return Scaffold(
      body: Material(
        type: MaterialType.card,
        child: Container(
          height: 800,
          decoration: BoxDecoration(
              color: Hexcolor(widget.favorites.avgColor),
              borderRadius: BorderRadius.circular(0),
              shape: BoxShape.rectangle),
          child: Stack(alignment: Alignment.center, children: [
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
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: 'Thene Bold'),
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
                            avgColor: widget.favorites.avgColor,
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
                child: Image.network(
                  widget.favorites.imgUrl,
                  height: 800,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
