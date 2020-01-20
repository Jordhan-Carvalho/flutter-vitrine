import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key key}) : super(key: key);
  static final routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meus produtos'),
        ),
        drawer: MainDrawer(),
        body: Center(
          child: Text('User products screen'),
        ));
  }
}
