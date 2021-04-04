import 'package:felexo/Widget/popular-list.dart';
import 'package:flutter/material.dart';

class IllustrationView extends StatefulWidget {
  @override
  _IllustrationViewState createState() => _IllustrationViewState();
}

class _IllustrationViewState extends State<IllustrationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: IllustrationList(),
        ),
      ),
    );
  }
}
