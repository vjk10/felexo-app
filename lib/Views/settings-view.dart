import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Services/authentication-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:filesize/filesize.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fsref = FirebaseStorage.instance.ref();
  User user;
  String feedbackToken;
  final globalKey = GlobalKey<ScaffoldState>();
  bool isDark = true;
  String appName;
  String packageName;
  String version;
  String buildNumber;
  bool _storeHistory = true;
  bool historyAvail = false;
  TextEditingController subject = new TextEditingController();
  TextEditingController feedback = new TextEditingController();
  var logoPlayStore;
  bool _isVerified = false;
  String cacheMemorySize = "0";
  String appMemorySize = "0";
  bool appMemoryFound = false;
  bool cacheFound = false;
  Directory tempDir;
  Directory appDir;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    _initPackageInfo();
    setState(() {});
    // print(searchHistory.length);
    if (searchHistory.length == null) {
      setState(() {
        historyAvail = false;
      });
    }
    if (searchHistory.length == 0) {
      setState(() {
        historyAvail = false;
      });
    }
    if (searchHistory.length > 0) {
      setState(() {
        historyAvail = true;
      });
    } else {
      setState(() {
        historyAvail = false;
      });
    }
    getCacheMemory();
    getAppMemory();
    getLogo();
    initUser();
    findIfStoreHistory();
    super.initState();
  }

  getCacheMemory() async {
    Directory _tempDir = await getTemporaryDirectory();
    cacheDirStatSync(_tempDir.path);
  }

  getAppMemory() async {
    Directory _appDir = Directory("storage/emulated/0/Pictures/FELEXO");
    print("APP DIRECTORY" + _appDir.path);
    appDirStatSync(_appDir.path);
  }

  getLogo() async {
    await fsref
        .child('ic_launcher-playstore.png')
        .getDownloadURL()
        .then((value) {
      setState(() {
        logoPlayStore = value;
      });
    });
  }

  initUser() async {
    user = _auth.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    setState(() {
      checkVerified();
    });
  }

  checkVerified() async {
    print("CHECK VERIFIED");
    FirebaseFirestore.instance
        .collection('User')
        .snapshots()
        .forEach((element) {
      print(element.docs.map((e) async {
        if (e.get('displayName') == user.displayName) {
          DocumentSnapshot snapshot = await FirebaseFirestore.instance
              .collection('VerifiedCreators')
              .doc(e.get('uid'))
              .get();
          if (snapshot.exists) {
            setState(() {
              _isVerified = true;
            });
          }
        }
      }));
    });
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  findIfStoreHistory() {
    FirebaseFirestore.instance
        .collection("User")
        .doc(user.uid.toString())
        .snapshots()
        .forEach((element) {
      setState(() {
        _storeHistory = element.data()["storeHistory"];
        print("Settingsh" + _storeHistory.toString());
      });
    });
    setState(() {});
  }

  void historyPref(bool value) {
    setState(() {
      _storeHistory = !_storeHistory;
    });
    FirebaseFirestore.instance
        .collection("User")
        .doc(user.uid.toString())
        .update({'storeHistory': _storeHistory});
  }

  Future<void> _deleteCacheDir() async {
    Directory _tempDir = await getTemporaryDirectory();
    setState(() {
      tempDir = _tempDir;
    });
    cacheDirStatSync(_tempDir.path);

    if (_tempDir.existsSync()) {
      _tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final _appDir = Directory("storage/emulated/0/Pictures/FELEXO");
    setState(() {
      appDir = _appDir;
    });
    print("APP DIRECTORY" + appDir.path);
    appDirStatSync(_appDir.path);
    if (_appDir.existsSync()) {
      _appDir.deleteSync(recursive: true);
    }
  }

  Map<String, int> cacheDirStatSync(String dirPath) {
    int fileNum = 0;
    int totalSize = 0;
    var dir = Directory(dirPath);
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
    // print("SIZE " + filesize(totalSize).toString());
    setState(() {
      cacheMemorySize = filesize(totalSize);
      if (totalSize > 0) {
        cacheFound = true;
      }
      if (totalSize <= 0) {
        cacheFound = false;
      }
    });
    return {'fileNum': fileNum, 'size': totalSize};
  }

  Map<String, int> appDirStatSync(String dirPath) {
    int fileNum = 0;
    int totalSize = 0;
    var dir = Directory(dirPath);
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
    // print("SIZE " + filesize(totalSize).toString());
    setState(() {
      appMemorySize = filesize(totalSize);
      if (totalSize > 0) {
        appMemoryFound = true;
      }
      if (totalSize <= 0) {
        appMemoryFound = false;
      }
    });
    return {'fileNum': fileNum, 'size': totalSize};
  }

  @override
  void didChangeDependencies() {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      isDark = true;
      setState(() {});
    }
    if (MediaQuery.of(context).platformBrightness == Brightness.light) {
      isDark = false;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary,
            )),
        title: Text("PROFILE", style: Theme.of(context).textTheme.headline6),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 4),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).accentColor, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(user.photoURL),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 10, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onLongPress: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              duration: const Duration(seconds: 1),
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.account_circle_outlined,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    user.displayName.toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        fontFamily: 'Theme Bold'),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  _isVerified
                                      ? Icon(
                                          Icons.verified,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 300,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  user.displayName.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              _isVerified
                                  ? Icon(
                                      Icons.verified,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 10, 0),
                  child: Text(
                    user.email,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("SEARCH"),
                ),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  title: Text(
                    "CLEAR SEARCH HISTORY",
                    style: Theme.of(context).textTheme.button,
                  ),
                  subtitle: historyAvail
                      ? Text("CLEAR ALL YOUR SEARCH HISTORY",
                          style: TextStyle(fontSize: 10))
                      : Text("YOU HAVE NO SEARCH HISTORY",
                          style: TextStyle(fontSize: 10)),
                  leading: Icon(
                    historyAvail ? Icons.search : Icons.search_off_outlined,
                    color: historyAvail
                        ? isDark
                            ? Colors.greenAccent
                            : Colors.green
                        : Colors.redAccent,
                  ),
                  onTap: () async {
                    if (searchHistory.length > 0) {
                      searchHistory.clear();
                      historyAvail = false;
                      setState(() {});
                      FirebaseFirestore.instance
                          .collection("User")
                          .doc(user.uid)
                          .collection("SearchHistory")
                          .get()
                          .then((value) {
                        for (DocumentSnapshot ds in value.docs) {
                          ds.reference.delete();
                        }
                      }).whenComplete(
                              () => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      duration: const Duration(seconds: 1),
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "SEARCH HISTORY DELETED!",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                fontFamily: 'Theme Bold'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                    }
                    HapticFeedback.mediumImpact();

                    // print("Clicked");
                  },
                ),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  leading: Icon(
                    _storeHistory ? Icons.history : Icons.history_toggle_off,
                    color: _storeHistory
                        ? isDark
                            ? Colors.greenAccent
                            : Colors.green
                        : Colors.redAccent,
                  ),
                  title: Text("SHARE MY SEARCH HISTORY",
                      style: Theme.of(context).textTheme.button),
                  subtitle: Text(
                    "THIS WILL HELP US IMPROVE YOUR SEARCH RECOMMENDATIONS",
                    style: TextStyle(fontSize: 10),
                  ),
                  trailing: Switch(
                      activeColor: isDark ? Colors.greenAccent : Colors.green,
                      inactiveThumbColor: Colors.redAccent,
                      activeTrackColor: isDark
                          ? Colors.greenAccent.withOpacity(0.5)
                          : Colors.green.withOpacity(0.5),
                      inactiveTrackColor: Colors.redAccent.withOpacity(0.5),
                      value: _storeHistory,
                      onChanged: historyPref),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("DEVICE"),
                ),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  title: Text(
                    "CLEAR CACHE",
                    style: Theme.of(context).textTheme.button,
                  ),
                  subtitle: Text(
                    "CLEAR APP CACHE",
                    style: TextStyle(fontSize: 10),
                  ),
                  leading: Icon(
                    cacheFound ? Icons.delete : Icons.delete_outlined,
                    color: cacheFound
                        ? Colors.redAccent
                        : Theme.of(context).colorScheme.primary,
                  ),
                  trailing: Text(
                    cacheMemorySize,
                    style: TextStyle(
                        fontFamily: 'Theme Regular',
                        fontSize: 10,
                        color: cacheFound
                            ? Colors.redAccent
                            : Theme.of(context).colorScheme.primary),
                  ),
                  onTap: () async {
                    HapticFeedback.mediumImpact();
                    if (cacheFound) {
                      _deleteCacheDir().whenComplete(() {
                        cacheDirStatSync(tempDir.path);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "CACHE DELETED!",
                              ),
                            ],
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ));
                      });
                    }
                    if (!cacheFound) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.error_outline_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "NO CACHE TO DELETE!",
                            ),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ));
                    }
                  },
                ),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  title: Text(
                    "DELETE SAVED WALLPAPERS",
                    style: Theme.of(context).textTheme.button,
                  ),
                  subtitle: Text(
                    "ALL SAVED WALLPAPERS WILL BE DELETED",
                    style: TextStyle(fontSize: 10),
                  ),
                  leading: Icon(
                    appMemoryFound
                        ? Icons.delete_forever
                        : Icons.delete_forever_outlined,
                    color: appMemoryFound
                        ? Colors.redAccent
                        : Theme.of(context).colorScheme.primary,
                  ),
                  trailing: Text(
                    appMemorySize,
                    style: TextStyle(
                        fontFamily: 'Theme Regular',
                        fontSize: 10,
                        color: appMemoryFound
                            ? Colors.redAccent
                            : Theme.of(context).colorScheme.primary),
                  ),
                  onTap: () async {
                    HapticFeedback.mediumImpact();
                    if (appMemoryFound) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(0)),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "DELETE WALLPAPERS",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                ),
                                content: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "THIS WILL PERMENANTLY DELETE \nTHE DOWNLOADED FILES!",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("DON'T DELETE")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteAppDir().whenComplete(() {
                                          appDirStatSync(appDir.path);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Row(
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "SAVED WALLPAPERS ARE DELETED!",
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ));
                                        });
                                      },
                                      child: Text("DELETE")),
                                ],
                              ));
                    }
                    if (!appMemoryFound) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.error_outline_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "NO WALLPAPERS TO DELETE!",
                            ),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ));
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("FEEDBACK AND INFO"),
                ),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  leading: Icon(
                    Icons.rate_review_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text("FEEDBACK",
                      style: Theme.of(context).textTheme.button),
                  subtitle: Text("YOUR FEEDBACKS AND SUGGESTIONS GOES HERE",
                      style: TextStyle(fontSize: 10)),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    feedbackForm();
                  },
                ),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  leading: Icon(
                    Icons.build_circle_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text("VERSION AND BUILD NUMBER",
                      style: Theme.of(context).textTheme.button),
                  subtitle: Text(
                    "v" +
                        _packageInfo.version +
                        " (build v" +
                        _packageInfo.buildNumber +
                        ")",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  leading: Icon(
                    Icons.tag,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text("APPLICATION ID",
                      style: Theme.of(context).textTheme.button),
                  subtitle: Text(
                    _packageInfo.packageName,
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  leading: Icon(
                    Icons.info_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    "ABOUT FELEXO",
                    style: Theme.of(context).textTheme.button,
                  ),
                  subtitle: Text(
                    "LICENSES & CERTIFICATES",
                    style: TextStyle(fontSize: 10),
                  ),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => LicensePage(
                                  applicationIcon: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: logoPlayStore,
                                        fadeInCurve: Curves.easeIn,
                                        fadeInDuration:
                                            const Duration(milliseconds: 500),
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                  applicationLegalese:
                                      "Apache License\nVersion 2.0, January 2004",
                                  applicationName: _packageInfo.appName,
                                  applicationVersion: "v" +
                                      _packageInfo.version +
                                      " (build v" +
                                      _packageInfo.buildNumber +
                                      ")",
                                )));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          signOutGoogle(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Theme.of(context).scaffoldBackgroundColor,
                            onPrimary: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.5),
                                    width: 1),
                                borderRadius: BorderRadius.circular(0))),
                        child: Text(
                          "LOGOUT",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void feedbackForm() {
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) => ExpandableBottomSheet(
              persistentContentHeight: MediaQuery.of(context).size.height / 2,
              expandableContent: Container(
                width: MediaQuery.of(context).size.width,
                height: 640,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.maximize_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Form(
                      child: Theme(
                        data: ThemeData(
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          textTheme: TextTheme(
                            bodyText1: Theme.of(context).textTheme.bodyText1,
                            headline1: Theme.of(context).textTheme.headline1,
                            subtitle1: Theme.of(context).textTheme.subtitle1,
                            subtitle2: Theme.of(context).textTheme.subtitle2,
                            bodyText2: Theme.of(context).textTheme.bodyText2,
                            caption: Theme.of(context).textTheme.caption,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2)),
                              counterStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontFamily: 'Theme Bold')),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 15.0, left: 15),
                              child: Material(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: TextFormField(
                                  controller: subject,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                    labelText: "Subject",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 15.0, left: 15),
                              child: Material(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: TextFormField(
                                  controller: feedback,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: null,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                    labelText: "Feedback",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Material(
                              child: InkWell(
                                onTap: () async {
                                  feedbackToken =
                                      "#" + randomAlphaNumeric(5).toString();
                                  await FirebaseFirestore.instance
                                      .collection("Feedbacks")
                                      .doc(feedbackToken)
                                      .set({
                                    "uid": user.uid,
                                    "email": user.email,
                                    "name": user.displayName,
                                    "subject": subject.text,
                                    "feedback": feedback.text
                                  });
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "OK",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button,
                                                ),
                                              )
                                            ],
                                            content: Text(
                                              "Your feedback is received and you can refer back to it by using the token: " +
                                                  feedbackToken,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ));
                                },
                                child: Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    height: 60,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("SEND",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontFamily: 'Theme Bold')),
                                      ],
                                    ),
                                  ),
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
              background: Container(
                color: Colors.transparent,
              ),
            ));
  }

  // void onThemeChanged(String val, ThemeModeNotifier themeModeNotifier) async {
  //   var themeModePrefs = await SharedPreferences.getInstance();
  //   if (val == "ThemeMode.system") {
  //     themeModeNotifier.setMode(ThemeMode.system);
  //   }
  //   if (val == "ThemeMode.dark") {
  //     themeModeNotifier.setMode(ThemeMode.dark);
  //   }
  //   if (val == "ThemeMode.light") {
  //     themeModeNotifier.setMode(ThemeMode.light);
  //   }
  //   themeModePrefs.setString("appTheme", val);
  // }
}
