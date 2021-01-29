import 'package:felexo/Widget/categories-tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatefulWidget {
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  @override
  void initState() {
    initUser();
    super.initState();
  }

  initUser() async {
    user = _auth.currentUser;
    assert(user.email != null);
    assert(user.uid != null);
    assert(user.photoURL != null);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Categories>>(context);
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoriesTile(categories: categories[index]);
      },
    );
  }
}

class Categories {
  final String imgUrl;
  final String categoryName;

  Categories({this.imgUrl, this.categoryName})
      : assert(imgUrl != null),
        assert(categoryName != null);
}
