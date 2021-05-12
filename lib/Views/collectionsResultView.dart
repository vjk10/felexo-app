import 'package:felexo/Widget/widgets.dart';
import 'package:flutter/material.dart';

class CRView extends StatefulWidget {
  final String collectionID, collectionName;
  CRView({@required this.collectionID, @required this.collectionName});
  @override
  _CRViewState createState() => _CRViewState();
}

class _CRViewState extends State<CRView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          widget.collectionName.toUpperCase(),
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CRGrid(
              collectionsID: widget.collectionID,
            ),
          ],
        ),
      ),
    );
  }
}
