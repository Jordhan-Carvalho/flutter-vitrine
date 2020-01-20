import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vitrine'),
      ),
      body: Center(
        child: Text('Vitrine main screen'),
      ),
    );
  }
}
