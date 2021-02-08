import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:felexo/Views/views.dart';
import 'package:felexo/model/wallpapers-model.dart';
import 'package:flutter/material.dart';

Widget wallpaperList(
    {@required List<WallpaperModel> wallpapers,
    @required context,
    @required String uid}) {
  return Column(
    children: [
      Container(
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            itemCount: wallpapers.length,
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle),
                  child: Stack(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Loading Images...",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontFamily: 'Circular Black'),
                            )
                          ],
                        )
                      ],
                    ),
                    Hero(
                      tag: wallpapers.elementAt(index),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3),
                            borderRadius: BorderRadius.circular(12)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            fit: BoxFit.fitHeight,
                            height: 800,
                            imageUrl: wallpapers.elementAt(index).src.portrait,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 65.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2),
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              "Creator: " +
                                  wallpapers.elementAt(index).photographer,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontFamily: 'Circular Black',
                                  fontSize: 20),
                              maxLines: 1,
                              minFontSize: 5,
                              maxFontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 15.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2),
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(2)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              "ID: " +
                                  wallpapers
                                      .elementAt(index)
                                      .photoID
                                      .toString(),
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontFamily: 'Circular Black',
                                  fontSize: 20),
                              maxLines: 1,
                              minFontSize: 5,
                              maxFontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          iconSize: 24,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WallPaperView(
                                        uid: uid,
                                        imgUrl: wallpapers
                                            .elementAt(index)
                                            .src
                                            .portrait,
                                        originalUrl: wallpapers
                                            .elementAt(index)
                                            .src
                                            .original,
                                        photoID: wallpapers
                                            .elementAt(index)
                                            .photoID
                                            .toString(),
                                        photographer: wallpapers
                                            .elementAt(index)
                                            .photographer,
                                        photographerID: wallpapers
                                            .elementAt(index)
                                            .photographerId
                                            .toString(),
                                        photographerUrl: wallpapers
                                            .elementAt(index)
                                            .photographerUrl)));
                          },
                          icon: Material(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                border: Border.all(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              child: Icon(
                                Icons.open_in_new,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              );
            }),
      ),
    ],
  );
}
