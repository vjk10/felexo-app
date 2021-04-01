import 'package:felexo/Data/categories-data.dart';
import 'package:felexo/Services/categories-list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatefulWidget {
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Categories>>.value(
        value: CategoryService().categories, child: CategoriesList());
  }
}
