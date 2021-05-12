import 'dart:async';

import 'package:felexo/Widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String testDevices = "mobileID";

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  User user;
  String wallpaperLocation,
      imgUrl,
      originalUrl,
      photoID,
      photographer,
      photographerID,
      avgColor,
      nextPage,
      photographerUrl;
  var foregroundColor;
  int pageNumber = 1;
  Timer timer;
  bool isLoading = true;
  Map data;
  @override
  void initState() {
    super.initState();
    setState(() {});
    initUser();
  }

  Future initUser() async {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    // print("User: " + user.uid.toString());
    // assert(imgUrl != null);
    // assert(originalUrl != null);
    // assert(photoID != null);
    // assert(photographer != null);
    // assert(photographerID != null);
    // assert(photographerUrl != null);
    // assert(avgColor != null);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Curated(),
          ],
        )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
