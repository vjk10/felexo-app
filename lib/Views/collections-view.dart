import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CollectionsView extends StatefulWidget {
  @override
  _CollectionsViewState createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 50,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    shadowColor: Theme.of(context).colorScheme.primary),
                child: Text("ADD A COLLECTION")),
          )
        ],
      ),
    );
  }
}
