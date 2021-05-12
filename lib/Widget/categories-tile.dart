import 'package:cached_network_image/cached_network_image.dart';
import 'package:felexo/Services/categories-list.dart';
import 'package:felexo/Views/categoriesResult-view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parallax/flutter_parallax.dart';

class CategoriesTile extends StatelessWidget {
  final Categories categories;
  CategoriesTile({this.categories});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Theme.of(context).scaffoldBackgroundColor),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Parallax.inside(
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: categories.imgUrl,
                ),
                mainAxisExtent: 200.0,
                direction: AxisDirection.up,
                flipDirection: true,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.9),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 75),
                alignment: Alignment.bottomRight,
                child: Text(
                  categories.categoryName.toUpperCase(),
                  style: TextStyle(
                      shadows: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 20,
                            spreadRadius: 10)
                      ],
                      letterSpacing: 5,
                      fontSize: 25,
                      fontFamily: 'Theme Bold',
                      color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => CategoriesResult(
                      categoryName: categories.categoryName,
                    )));
      },
    );
  }
}
