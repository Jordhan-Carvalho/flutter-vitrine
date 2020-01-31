import 'package:flutter/material.dart';

import './services_screen.dart';
import './market_screen.dart';
import './edit_product_screen.dart';
import './favorites_screen.dart';
import './categories_screen.dart';
import './prod_overview_screen.dart';
import '../widgets/main_drawer.dart';

class NavTabs extends StatefulWidget {
  NavTabs({Key key}) : super(key: key);

  @override
  _NavTabsState createState() => _NavTabsState();
}

class _NavTabsState extends State<NavTabs> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {'page': ProdOverview(), 'title': 'Vitrine'},
      {'page': CategoriesScreen(), 'title': 'Categorias'},
      {'page': MarketScreen(), 'title': 'Lojas'},
      {'page': ServicesScreen(), 'title': 'Serviços'},
      {'page': FavoritesScreen(), 'title': 'Favoritos'},
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_pages[_selectedPageIndex]['title']),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '\$ Vender',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        // backgroundColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        elevation: 10,
        // Optional for effect
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Vitrine'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('Categorias'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            title: Text('Lojas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),
            title: Text('Serviços'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Favoritos'),
          ),
        ],
      ),
    );
  }
}
