import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Color/colors.dart';
import 'package:felexo/Screens/landing-page.dart';
import 'package:felexo/Screens/main-screen.dart';
import 'package:felexo/Services/animation-route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

// ignore: missing_return
Future<String> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final User user = (await _auth.signInWithCredential(authCredential)).user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);
    print("UID: " + user.uid);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("User").doc(user.uid.toString());
    documentReference.get().then((value) {
      if (!value.exists) {
        FirebaseFirestore.instance.collection("User").doc(user.uid).set({
          "uid": user.uid,
          "displayName": user.displayName,
          "email": user.email,
          "verified": "false"
        });
      }
    });

    Navigator.pushAndRemoveUntil(
        context, FadeRoute(context, page: MainScreen()), (route) => false);
  } catch (e) {
    String message = e.message;
    if (e is PlatformException) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black, width: 3)),
                title: Text(
                  "Error",
                  style: TextStyle(
                      fontFamily: 'Nunito-ExtraBold', color: textColor),
                ),
                content: Text(
                  "$message",
                  style: TextStyle(
                      fontFamily: 'Nunito-ExtraBold', color: textColor),
                ),
                actions: [
                  FlatButton(
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontFamily: 'Nunito-ExtraBold', color: textColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black, width: 8)),
                title: Text(
                  "Error",
                  style: TextStyle(
                      fontFamily: 'Nunito-ExtraBold', color: textColor),
                ),
                content: Text(
                  "Something is wrong! Please Try Again...",
                  style: TextStyle(
                      fontFamily: 'Nunito-ExtraBold', color: textColor),
                ),
                actions: [
                  FlatButton(
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontFamily: 'Nunito-ExtraBold', color: textColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
    }
  }
}

void signOutGoogle(BuildContext context) async {
  await _auth.signOut();
  await _googleSignIn.signOut();
  Navigator.pushAndRemoveUntil(
      context, FadeRoute(context, page: LandingPage()), (route) => false);
}
