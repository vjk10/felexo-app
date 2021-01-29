import 'package:felexo/Color/colors.dart';
import 'package:flutter/material.dart';

Widget dailySpecial(
    {@required BuildContext context, String dsUrl, String tfUrl}) {
  assert(dsUrl != null);
  assert(tfUrl != null);
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  dsUrl,
                  fit: BoxFit.fitWidth,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black26),
            ),
            Column(
              children: [
                Text("Wall",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Circular Bold",
                        fontSize: 20)),
                Text("Of",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Circular Bold",
                        fontSize: 20)),
                Text("The Day",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Circular Bold",
                        fontSize: 20)),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  tfUrl,
                  fit: BoxFit.fitWidth,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black26),
            ),
            Column(
              children: [
                Text("Daily",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Circular Bold",
                        fontSize: 20)),
                Text("Specials",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Circular Bold",
                        fontSize: 20)),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  dsUrl,
                  fit: BoxFit.fitWidth,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black26),
            ),
            Column(
              children: [
                Text("Top",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Circular Bold",
                        fontSize: 20)),
                Text("Find",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor,
                        fontFamily: "Circular Bold",
                        fontSize: 20)),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}
