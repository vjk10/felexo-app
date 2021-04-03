import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class CollectionsView extends StatefulWidget {
  @override
  _CollectionsViewState createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  bool dark;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.platformBrightnessOf(context) == Brightness.dark) {
      dark = true;
      setState(() {});
    }
    if (MediaQuery.platformBrightnessOf(context) == Brightness.light) {
      dark = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 200,
                    height: 200,
                    child: dark
                        ? LottieBuilder.asset(
                            "assets/lottie/comingSoonDark.json")
                        : LottieBuilder.asset("assets/lottie/comingSoon.json"))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: Text(
                      "COLLECTIONS ARE COMING SOON TO FELEXO",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: 'Theme Bold'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       width: MediaQuery.of(context).size.width / 2,
            //       height: 50,
            //       child: TextButton(
            //           style: TextButton.styleFrom(
            //               backgroundColor:
            //                   Theme.of(context).colorScheme.primary,
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.zero)),
            //           onPressed: () {
            //             showDialog(
            //                 context: context,
            //                 builder: (context) => Dialog(
            //                       child: Text("Feature Coming soon"),
            //                     ));
            //           },
            //           child: Text(
            //             "ADD A NEW COLLECTION",
            //             style: TextStyle(
            //                 color: Theme.of(context).colorScheme.secondary),
            //           )),
            //     )
            //   ],
            // ),
          ]),
    );
  }
}
