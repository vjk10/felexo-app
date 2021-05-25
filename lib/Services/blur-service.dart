import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Convenience widget to create blurred images.
/// `BlurredImage.asset` behaves like `Image.asset`, and
/// `BlurredImage.network` behaves like `Image.network`.
class BlurredImage extends StatelessWidget {
  BlurredImage.asset(
    String imagePath, {
    Key key,
    this.blurValue = 5,
  })  : imageWidget = Image.asset(
          imagePath,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        super(key: key);

  BlurredImage.network(
    BuildContext context,
    String url, {
    Key key,
    this.blurValue = 5,
  })  : imageWidget = CachedNetworkImage(
          imageUrl: url,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
          fadeInCurve: Curves.easeIn,
          fadeOutCurve: Curves.easeOut,
        ),
        super(key: key);

  final double blurValue;
  final Widget imageWidget;

  @override
  Widget build(BuildContext context) {
    return Blurred(
      imageWidget,
      blurValue: blurValue,
    );
  }
}

/// Wrapper widget that blurs the wudget passed to it.
/// Any widget passed to the `child` argument will not be blurred.
/// The higher the `blurValue`, the stronger the blur effect.
class Blurred extends StatelessWidget {
  const Blurred(
    this.widget, {
    Key key,
    this.child,
    this.blurValue = 5,
    this.alignment = Alignment.center,
  }) : super(key: key);

  final Widget widget;
  final Widget child;
  final double blurValue;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        alignment: alignment,
        children: <Widget>[
          widget,
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
              child: Container(),
            ),
          ),
          if (child != null) child,
        ],
      ),
    );
  }
}
