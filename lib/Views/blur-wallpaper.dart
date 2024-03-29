import 'dart:io';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:felexo/Color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class BlurWallpaperView extends StatefulWidget {
  final String url, photoID, photographer, avgColor;
  final int location;
  final foregroundColor;
  BlurWallpaperView(
      {@required this.photoID,
      @required this.location,
      @required this.photographer,
      @required this.url,
      @required this.avgColor,
      @required this.foregroundColor});

  @override
  _BlurWallpaperViewState createState() => _BlurWallpaperViewState();
}

class _BlurWallpaperViewState extends State<BlurWallpaperView> {
  double sliderValue = 0;
  final sliderMaxValue = 20.0;
  bool downloading = false;
  String progressString;
  double progressValue;
  ScreenshotController _screenshotController = new ScreenshotController();

  @override
  void didChangeDependencies() {
    // Navigator.pop(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Theme.of(context).accentColor.withOpacity(0.5)),
                color: widget.foregroundColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 20,
                  color: widget.foregroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Hexcolor(widget.avgColor),
            ),
            // Screenshot(
            //   controller: _screenshotController,
            //   child: BlurredImage.network(
            //     context,
            //     widget.url,
            //     blurValue: sliderValue,
            //   ),
            // ),
            Screenshot(
              controller: _screenshotController,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    imageUrl: widget.url,
                    fadeInCurve: Curves.easeIn,
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: sliderValue, sigmaY: sliderValue),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.3,
              child: BlurryContainer(
                blur: 5,
                borderRadius: BorderRadius.zero,
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("SELECT BLUR VALUE",
                        style: TextStyle(
                            color: widget.foregroundColor,
                            fontFamily: 'Theme Bold',
                            fontSize: 14)),
                    SfSlider(
                      min: 0.0,
                      max: 20.0,
                      value: sliderValue,
                      // showLabels: true,
                      activeColor: widget.foregroundColor,
                      inactiveColor: widget.foregroundColor.withOpacity(0.5),
                      enableTooltip: true,
                      interval: 5,
                      showDivisors: true,
                      onChanged: (dynamic value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                    Container(
                      width: 150,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          _screenshotController
                              .captureAndSave("storage/emulated/0/Pictures",
                                  fileName: widget.photoID.toString() +
                                      widget.photographer.toString() +
                                      ".jpg",
                                  pixelRatio: 1,
                                  delay: const Duration(milliseconds: 10))
                              .then((value) {
                            setWallpaper(widget.location);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.transparent,
                          onPrimary: widget.foregroundColor,
                          onSurface: widget.foregroundColor,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: widget.foregroundColor, width: 1),
                              borderRadius: BorderRadius.circular(00)),
                        ),
                        child: Text(
                          "SET WALLPAPER",
                          style: TextStyle(
                              fontFamily: 'Theme Bold',
                              color: widget.foregroundColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> setWallpaper(int location) async {
    setState(() {
      downloading = true;
    });
    try {
      // final file = await DefaultCacheManager().getSingleFile(url);
      // var response = await http.get(Uri.parse(url));
      // var filePath =
      //     await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
      try {
        final String result = await WallpaperManager.setWallpaperFromFile(
          "storage/emulated/0/Pictures/" +
              widget.photoID.toString() +
              widget.photographer.toString() +
              ".jpg",
          location,
        ).whenComplete(() {
          downloading = false;
          final file = File("storage/emulated/0/Pictures/" +
              widget.photoID.toString() +
              widget.photographer.toString() +
              ".jpg");
          file.delete();
          setState(() {});
          HapticFeedback.heavyImpact();
          Fluttertoast.showToast(
              msg: "Your wallpaper is set",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.secondary,
              fontSize: 16.0);
          Navigator.pop(context);
        });
        print(result);
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }
}
