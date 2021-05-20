import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Services/favorites-list.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;
  DatabaseService({@required this.uid});

  // List<Favorites> _favoriteListfromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return Favorites(
  //         imgUrl: doc.data()['imgUrl'] ?? '',
  //         originalUrl: doc.data()['originalUrl'] ?? '',
  //         photoID: doc.data()['photoID'] ?? '',
  //         photographer: doc.data()['photographer'] ?? '',
  //         photographerID: doc.data()['photographerID'] ?? '',
  //         avgColor: doc.data()['avgColor'],
  //         photographerUrl: doc.data()['photographerUrl'] ?? '');
  //   }).toList();
  // }
  List<Favorites> _favoriteListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Favorites(
          imgUrl: doc.get('imgUrl') ?? '',
          originalUrl: doc.get('originalUrl') ?? '',
          photoID: doc.get('photoID') ?? '',
          photographer: doc.get('photographer') ?? '',
          photographerID: doc.get('photographerID') ?? '',
          avgColor: doc.get('avgColor'),
          photographerUrl: doc.get('photographerUrl') ?? '');
    }).toList();
  }

  Stream<List<Favorites>> get favorites {
    return FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Favorites")
        .snapshots()
        .map((_favoriteListfromSnapshot));
  }
}
