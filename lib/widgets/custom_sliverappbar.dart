import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatefulWidget {
  final List<String> imagesUrls;
  final FlexibleSpaceBar passFlexibleSpace;
  final int imgIndex;
  CustomSliverAppBar({
    Key key,
    this.imagesUrls,
    this.passFlexibleSpace,
    this.imgIndex,
  }) : super(key: key);

  @override
  _CustomSliverAppBarState createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    Image image = Image.network(widget.imagesUrls[widget.imgIndex]);

    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return FutureBuilder(
        future: completer.future,
        builder: (context, AsyncSnapshot<ui.Image> snapshot) {
          return SliverAppBar(
            pinned: true,
            flexibleSpace: widget.passFlexibleSpace,
            expandedHeight: snapshot.hasData
                ? MediaQuery.of(context).size.width /
                        snapshot.data.width.toDouble() *
                        snapshot.data.height.toDouble() -
                    statusBarHeight
                : 0.0,
          );
        });
  }
}
