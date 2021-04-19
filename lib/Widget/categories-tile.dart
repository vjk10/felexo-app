import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:felexo/Color/colors.dart';
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
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Material(
        child: Container(
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                child: Center(
                  child: Container(
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
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: Container(
                      width: width,
                      height: 200,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 80),
                      alignment: Alignment.bottomRight,
                      child: BorderedText(
                        strokeColor: Colors.black,
                        strokeWidth: 8,
                        child: Text(
                          categories.categoryName.toUpperCase(),
                          style: TextStyle(
                              letterSpacing: 5,
                              fontSize: 30,
                              fontFamily: 'Theme Bold',
                              color: textColor),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
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
