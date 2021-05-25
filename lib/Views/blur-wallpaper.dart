import 'dart:io';
import 'dart:typed_data';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Services/blur-service.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class BlurWallpaperView extends StatefulWidget {
  final String url, photoID, photographer, avgColor;
  final int location;
  BlurWallpaperView(
      {@required this.photoID,
      @required this.location,
      @required this.photographer,
      @required this.url,
      @required this.avgColor});

  @override
  _BlurWallpaperViewState createState() => _BlurWallpaperViewState();
}

class _BlurWallpaperViewState extends State<BlurWallpaperView> {
  double sliderValue = 0;
  final sliderMaxValue = 20.0;
  bool downloading = false;
  Uint8List _imageFile;
  String progressString;
  double progressValue;
  ScreenshotController _screenshotController;
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
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
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
            Screenshot(
              controller: _screenshotController,
              child: BlurredImage.network(
                context,
                widget.url,
                blurValue: sliderValue,
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
                        style: Theme.of(context).textTheme.button),
                    SfSlider(
                      min: 0.0,
                      max: sliderMaxValue,
                      value: sliderValue,
                      showLabels: true,
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      enableTooltip: false,
                      minorTicksPerInterval: 1,
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
                          _screenshotController.captureAndSave(
                              "storage/emulated/0/Pictures/",
                              fileName: widget.photographer +
                                  widget.photoID.toString(),
                              pixelRatio: 1,
                              delay: const Duration(milliseconds: 10));
                          // _screenshotController
                          //     .capture(
                          //         pixelRatio: 1.5, delay: Duration(seconds: 1))
                          //     .then((Uint8List image) {
                          //   setState(() {
                          //     _imageFile = image;
                          //     setWallpaper(image, widget.location);
                          //   });
                          // });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.transparent,
                          onPrimary: Theme.of(context).colorScheme.primary,
                          onSurface: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1),
                              borderRadius: BorderRadius.circular(00)),
                        ),
                        child: Text(
                          "SET WALLPAPER",
                          style: TextStyle(
                              fontFamily: 'Theme Bold',
                              color: Theme.of(context).colorScheme.primary),
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

  Future<Null> setWallpaper(Uint8List image, int location) async {
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
              widget.photographer +
              widget.photoID.toString() +
              ".jpg",
          location,
        ).whenComplete(() {
          downloading = false;
          final file = File("storage/emulated/0/Pictures/" +
              widget.photographer +
              widget.photoID.toString() +
              ".jpg");
          file.delete();
          setState(() {});
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1,
                            color:
                                Theme.of(context).accentColor.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(0)),
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    title: Text("FELEXO",
                        style: Theme.of(context).textTheme.button),
                    content: Text("YOUR WALLPAPER IS SET",
                        style: Theme.of(context).textTheme.button),
                    actions: [
                      TextButton(
                        child: Text("OK",
                            style: Theme.of(context).textTheme.button),
                        onPressed: () {
                          setState(() {
                            progressString = "0%";
                            progressValue = 0;
                          });
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
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
