import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  final Widget content;
  final Function handlePress;
  const ThemeButton(
      {Key key, @required this.content, @required this.handlePress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      child: content,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.white)),
      onPressed: handlePress,
      textColor: Colors.white,
    );
  }
}
