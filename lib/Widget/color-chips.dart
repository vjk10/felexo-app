import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorChips extends StatefulWidget {
  final Color foregroundchip;
  final Color backgroundchip;
  final Color chipColor;
  final String colorchip;

  const ColorChips(
      {@required this.foregroundchip,
      @required this.backgroundchip,
      @required this.chipColor,
      @required this.colorchip});
  @override
  _ColorChipsState createState() => _ColorChipsState();
}

class _ColorChipsState extends State<ColorChips> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 110,
      decoration: BoxDecoration(
          color: widget.chipColor, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Stack(alignment: Alignment.center, children: [
            CircleAvatar(
              backgroundColor: widget.backgroundchip,
              radius: 10,
            ),
            CircleAvatar(
              backgroundColor: widget.foregroundchip,
              radius: 8,
            ),
          ]),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AutoSizeText(
                widget.colorchip,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                maxFontSize: 15,
                minFontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
