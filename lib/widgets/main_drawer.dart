import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/about_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildItem(
      IconData icon, String title, Function tapHandler, BuildContext ctx) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            icon,
            color: Theme.of(ctx).primaryColor,
          ),
          title: Text(title),
          onTap: tapHandler,
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Center(
              child: Image(
                image: AssetImage('assets/images/logo-branco-menor.png'),
                height: 68,
                // fit: BoxFit.fill,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          _buildItem(
            Icons.shopping_cart,
            'Vitrine',
            () => Navigator.of(context).pushReplacementNamed('/'),
            context,
          ),
          _buildItem(
            Icons.widgets,
            'Meus produtos',
            () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName),
            context,
          ),
          _buildItem(
            Icons.info,
            'Sobre',
            () => Navigator.of(context).pushNamed(AboutScreen.routeName),
            context,
          ),
          _buildItem(
            Icons.exit_to_app,
            'Sair',
            () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            context,
          ),
        ],
      ),
    );
  }
}
