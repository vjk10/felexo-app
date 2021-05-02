import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:felexo/Data/data.dart';
import 'package:felexo/Services/authentication-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:random_string/random_string.dart';

class SettingsView extends StatefulWidget {
  final bool storeHistory;

  SettingsView({@required this.storeHistory});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  String feedbackToken;
  final globalKey = GlobalKey<ScaffoldState>();
  bool themeBoxOpen = false;
  bool isDark = true;
  String appName;
  String packageName;
  String version;
  String buildNumber;
  bool _storeHistory;
  bool historyAvail = false;
  TextEditingController subject = new TextEditingController();
  TextEditingController feedback = new TextEditingController();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    _initPackageInfo();
    _storeHistory = widget.storeHistory;
    // print(searchHistory.length);
    if (searchHistory.length == 0) {
      historyAvail = false;
      setState(() {});
    }
    if (searchHistory.length > 0) {
      historyAvail = true;
      setState(() {});
    }
    // print(_storeHistory);
    super.initState();
    initUser();
  }

  initUser() async {
    user = _auth.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    setState(() {});
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 4),
                  child: Material(
                    elevation: 5,
                    shadowColor: Theme.of(context).colorScheme.primary,
                    type: MaterialType.circle,
                    color: Theme.of(context).colorScheme.secondary,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(user.photoURL),
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
                      Text(
                        user.displayName,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.lock,
                        color: Colors.redAccent,
                      )
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
                  height: 10,
                ),
                Divider(),
                // ListTile(
                //   minVerticalPadding: 10,
                //   horizontalTitleGap: 20,
                //   title: Text(
                //     "Clear Cache",
                //   ),
                //   leading: Icon(
                //     Icons.delete,
                //     color: Theme.of(context).colorScheme.primary,
                //   ),
                //   onTap: () async {
                //     HapticFeedback.mediumImpact();
                //     var appDir = (await getTemporaryDirectory()).path +
                //         '/com.vlabs.felexo';
                //     new Directory(appDir).delete(recursive: true)
                //       ..whenComplete(() =>
                //           // ignore: deprecated_member_use
                //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //             content: Row(
                //               children: [
                //                 Icon(
                //                   Icons.check,
                //                   color: Theme.of(context).colorScheme.secondary,
                //                 ),
                //                 SizedBox(
                //                   width: 10,
                //                 ),
                //                 Text(
                //                   "Cache Deleted!",
                //                 ),
                //               ],
                //             ),
                //             backgroundColor:
                //                 Theme.of(context).colorScheme.primary,
                //           )));
                //     print(appDir);
                //     print("Clicked");
                //   },
                // ),
                // Divider(),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  title: Text(
                    "Clear Search History",
                  ),
                  subtitle: historyAvail
                      ? Text("Clear all your existing search history")
                      : Text("You Have no search history"),
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
                                            "Search History Deleted!",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                    }
                    if (searchHistory.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.error,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "You have no history to delete!",
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    HapticFeedback.mediumImpact();

                    // print("Clicked");
                  },
                ),
                Divider(),
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
                  title: Text("Share my Search History"),
                  subtitle: Text(
                    "This will help us improve your search recommendations",
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
                Divider(),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  leading: Icon(
                    Icons.rate_review_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text("Feedback"),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    feedbackForm();
                  },
                ),
                Divider(),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  leading: Icon(
                    Icons.build_circle_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text("Version Number"),
                  subtitle: Text(
                    _packageInfo.version +
                        ".BUILD.FBA." +
                        _packageInfo.buildNumber,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Divider(),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  leading: Icon(
                    Icons.tag,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text("Application ID"),
                  subtitle: Text(
                    _packageInfo.packageName,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Divider(),
                ListTile(
                  minVerticalPadding: 10,
                  horizontalTitleGap: 20,
                  leading: Icon(
                    Icons.lightbulb_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text("About and Credits"),
                  subtitle: Text(
                    "Licenses",
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    showAboutDialog(
                        context: context,
                        applicationName: _packageInfo.appName,
                        applicationVersion: _packageInfo.version +
                            ".BUILD.FBA." +
                            _packageInfo.buildNumber,
                        applicationLegalese:
                            "Apache License\nVersion 2.0, January 2004",
                        applicationIcon: Image.network(
                          logoPlayStore,
                          width: 50,
                          height: 50,
                        ));
                  },
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        signOutGoogle(context);
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shadowColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      child: Text(
                        "LOGOUT",
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
