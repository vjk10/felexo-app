import 'package:felexo/Color/colors.dart';
import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor),
        title: Text(
          "About",
          style: Theme.of(context).textTheme.headline6,
        ),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Felexo",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Circular Black',
                            fontSize: 50),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Powered by Flutter"),
                      SizedBox(
                        height: 50,
                      ),
                      ListTile(
                        title: Text("auto_size_text"),
                        subtitle: Text("1 License"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: Text("bordered_text"),
                        subtitle: Text("1 License"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
