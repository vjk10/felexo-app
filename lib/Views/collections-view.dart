import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CollectionsView extends StatefulWidget {
  @override
  _CollectionsViewState createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Text("Collections Coming here"),
      ),
    );
  }
}
