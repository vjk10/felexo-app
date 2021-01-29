import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Services/authentication-service.dart';
import 'package:felexo/Views/favorites-view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User user;
  String uid;
  String verified;
  Map data;
  @override
  void initState() {
    initUser();
    super.initState();
  }

  initUser() async {
    user = FirebaseAuth.instance.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    uid = user.uid.toString();
    print("User: " + user.uid.toString());
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("User").doc(uid);
    documentReference.snapshots().listen((event) {
      setState(() {
        data = event.data();
        verified = data['verified'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor),
        title: Text("Profile", style: Theme.of(context).textTheme.headline6),
        elevation: 5,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                signOutGoogle(context);
              })
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        elevation: 5,
                        shape: CircleBorder(side: BorderSide.none),
                        shadowColor: Theme.of(context).colorScheme.primary,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).appBarTheme.color,
                          radius: 50,
                          backgroundImage: NetworkImage(user.photoURL),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.displayName,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  if (verified == "true")
                                    Icon(
                                      Icons.verified_sharp,
                                      size: 20,
                                      color: Colors.blue,
                                    )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [Text(user.email)],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height - 380,
                          width: MediaQuery.of(context).size.width,
                          child: FavoritesView())
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
