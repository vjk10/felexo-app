import 'package:felexo/Widget/collectionsGridView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CollectionsView extends StatefulWidget {
  @override
  _CollectionsViewState createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CollectionsGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
