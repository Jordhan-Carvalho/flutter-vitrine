import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  CardContainer(
      {@required this.child, @required this.height, @required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: height,
      width: width,
      child: child,
    );
  }
}
