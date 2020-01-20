import 'package:flutter/material.dart';

import './favorites_screen.dart';
import './categories_screen.dart';
import './home_screen.dart';
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
      {'page': HomeScreen(), 'title': 'Vitrine'},
      {'page': CategoriesScreen(), 'title': 'Categorias'},
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
        title: Text(_pages[_selectedPageIndex]['title']),
        actions: <Widget>[
          RaisedButton(
            child: Row(
              children: <Widget>[
                Text('Vender'),
                Icon(Icons.attach_money),
              ],
            ),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        // Optional for effect
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            // Optional for effect
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.shopping_cart),
            title: Text('Geral'),
          ),
          BottomNavigationBarItem(
            // Optional for effect
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            title: Text('Categorias'),
          ),
          BottomNavigationBarItem(
            // Optional for effect
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            title: Text('Favoritos'),
          ),
        ],
      ),
    );
  }
}
