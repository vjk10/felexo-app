import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felexo/Services/categories-list.dart';

class CategoryService {
  // List<Categories> _favoriteListfromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return Categories(
  //         imgUrl: doc.data()['imgUrl'],
  //         categoryName: doc.data()['CategoryName']);
  //   }).toList();
  // }
  List<Categories> _favoriteListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Categories(
          imgUrl: doc.get('imgUrl'), categoryName: doc.get('CategoryName'));
    }).toList();
  }

  Stream<List<Categories>> get categories {
    return FirebaseFirestore.instance
        .collection("Categories")
        .snapshots()
        .map((_favoriteListfromSnapshot));
  }
}
