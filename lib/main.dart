import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './widgets/splash_screen.dart';
import './screens/edit_product_screen.dart';
import './providers/products.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import './screens/nav_tab.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(),
            update: (ctx, authData, prevProds) {
              prevProds..authToken = authData.token;
              prevProds..userId = authData.userId;
              return prevProds;
            }),
      ],
      // whenever auth changes, call rebuild
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Vitrine',
          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.greenAccent,
            canvasColor: Color.fromRGBO(255, 254, 229, 1),
            fontFamily: 'RobotoCondensed',
            iconTheme: IconThemeData(color: Colors.green),
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  body1: TextStyle(fontFamily: 'RobotoCondensed'),
                ),
          ),
          home: authData.isAuth
              ? NavTabs()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          routes: {
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            LoginScreen.routeName: (_) => LoginScreen(),
          },
        ),
      ),
    );
  }
}
