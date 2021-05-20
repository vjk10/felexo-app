import 'dart:convert';

import 'package:felexo/Color/colors.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Model/wallpapers-model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CRPreview extends StatefulWidget {
  final String collectionsID;

  CRPreview({@required this.collectionsID});

  @override
  _CRPreviewState createState() => _CRPreviewState();
}

class _CRPreviewState extends State<CRPreview> {
  List<WallpaperModel> crPreview = [];
  String p1;
  String p2;
  String p3;
  bool _p3avail = false;
  int totalResults;
  var foregroundColor;

  getPreviews() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/collections/" +
            widget.collectionsID +
            "?&type=photos&page=1&per_page=80"),
        headers: {"Authorization": apiKey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    // print("TOTALRESULTS " + jsonData["total_results"].toString());
    totalResults = (jsonData["total_results"] - 2);
    jsonData["media"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      crPreview.add(wallpaperModel);
    });
    // print("LENGTH " + crPreview.length.toString());
    p1 = crPreview.last.src.portrait;
    p2 = crPreview.first.src.portrait;
    if (totalResults != 0) {
      _p3avail = true;
      foregroundColor = Hexcolor(crPreview[2].avgColor).computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;
      p3 = crPreview[2].src.portrait;
    }
    // print(totalResults);
    setState(() {});
    // print(response.body.toString());
  }

  @override
  void initState() {
    getPreviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          p1 ?? loadingAnimation,
          width: MediaQuery.of(context).size.width / 1.7639,
          height: 250,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace trace) {
            return Container(
              color: Theme.of(context).colorScheme.primary,
            );
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              p2 ?? loadingAnimation,
              width: MediaQuery.of(context).size.width / 2.47,
              height: 160,
              errorBuilder:
                  (BuildContext context, Object exception, StackTrace trace) {
                return Container(
                  color: Theme.of(context).colorScheme.primary,
                );
              },
              fit: BoxFit.cover,
            ),
            _p3avail
                ? Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.47,
                        height: 90,
                        child: Image.network(
                          p3 ?? loadingAnimation,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace trace) {
                            return Container(
                              color: Theme.of(context).colorScheme.primary,
                            );
                          },
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 2.47,
                          height: 90,
                          color: foregroundColor.withOpacity(0.3) ??
                              Theme.of(context).scaffoldBackgroundColor,
                          child: Center(
                            child: Text(
                              "VIEW MORE",
                              style: TextStyle(
                                  color: foregroundColor,
                                  fontFamily: 'Theme Bold',
                                  fontSize: 16),
                            ),
                          )),
                    ],
                  )
                : Container(
                    width: 160,
                    height: 90,
                    // color:
                    //     Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    child: Center(
                      child: Text("VIEW MORE"),
                    ))
          ],
        )
      ],
    );
  }
}
