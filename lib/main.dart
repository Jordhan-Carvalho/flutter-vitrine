import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import './screens/nav_tab.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return MaterialApp(
      title: 'Vitrine',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.amber,
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
      home: NavTabs(),
      routes: {
        UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
        ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
      },
    );
  }
}
