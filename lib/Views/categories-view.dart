import 'package:felexo/Color/colors.dart';
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
  Widget build(BuildContext context) {
    return StreamProvider<List<Categories>>.value(
        value: CategoryService().categories,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(color: iconColor),
              title: Text("Categories",
                  style: Theme.of(context).textTheme.headline6),
              elevation: 5,
            ),
            body: CategoriesList()));
  }
}
