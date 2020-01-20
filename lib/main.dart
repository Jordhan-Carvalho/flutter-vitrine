import 'package:flutter/material.dart';

import './screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vitrine',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Color.fromRGBO(0, 125, 125, 1),
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'RobotoCondensed',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              body1: TextStyle(fontFamily: 'RobotoCondensed'),
            ),
      ),
      home: HomeScreen(),
    );
  }
}
