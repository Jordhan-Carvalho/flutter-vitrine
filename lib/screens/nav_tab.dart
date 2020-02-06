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
  //search bar
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";
  //search bar
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': ProdOverview(
          searchTerm: searchQuery,
        ),
        'title': 'Vitrine'
      },
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

//Search

  void changeQueryValueCallback(String query) {}

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Procurar produto...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery,
      onSubmitted: (value) => updateSearchQuery(value),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

//Search
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: _isSearching ? const BackButton() : Container(),
        title: _selectedPageIndex == 0
            ? (_isSearching ? _buildSearchField() : Text('Vitrine'))
            : Text(_pages[_selectedPageIndex]['title']),
        actions: <Widget>[
          if (_selectedPageIndex == 0) ..._buildActions(),
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
      body: _selectedPageIndex == 0
          ? ProdOverview(
              searchTerm: searchQuery,
            )
          : _pages[_selectedPageIndex]['page'],
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
