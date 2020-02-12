import 'package:flutter/material.dart';

import './buy_services.dart';
import './about_screen.dart';
import './services_screen.dart';
import './market_screen.dart';
import './edit_product_screen.dart';
import './favorites_screen.dart';
import './categories_screen.dart';
import './prod_overview_screen.dart';
import '../widgets/main_drawer.dart';

enum FilterOptions {
  Delivery,
  Tradable,
}

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
  var _showTradable = false;
  var _showDelivery = false;

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

  void _filterCallback(newValue) {
    _showDelivery = newValue;
    _showTradable = newValue;
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
        centerTitle: _selectedPageIndex == 0 ? false : true,
        title: _selectedPageIndex == 0
            ? (_isSearching ? _buildSearchField() : Text('Vitrine'))
            : Text(_pages[_selectedPageIndex]['title']),
        actions: <Widget>[
          if (_selectedPageIndex == 0) ..._buildActions(),
          if (_selectedPageIndex == 0)
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Delivery) {
                    _showDelivery = !_showDelivery;
                  } else if (selectedValue == FilterOptions.Tradable) {
                    _showTradable = !_showTradable;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.local_shipping,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        'Entrega Disponível',
                        style: TextStyle(
                            color: _showDelivery ? Colors.green : Colors.black),
                      ),
                      !_showDelivery
                          ? Icon(
                              Icons.check_box_outline_blank,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(
                              Icons.check_box,
                              color: Theme.of(context).primaryColor,
                            ),
                    ],
                  ),
                  value: FilterOptions.Delivery,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.autorenew,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        'Aceita Trocas',
                        style: TextStyle(
                            color: _showTradable ? Colors.green : Colors.black),
                      ),
                      !_showTradable
                          ? Icon(
                              Icons.check_box_outline_blank,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(
                              Icons.check_box,
                              color: Theme.of(context).primaryColor,
                            ),
                    ],
                  ),
                  value: FilterOptions.Tradable,
                ),
                PopupMenuItem(
                  child: Center(
                    child: FlatButton.icon(
                      label: Text("Sobre"),
                      icon: Icon(
                        Icons.info,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AboutScreen.routeName);
                      },
                    ),
                  ),
                  value: null,
                ),
              ],
            ),
          _selectedPageIndex == 3
              ? FlatButton.icon(
                  textColor: Colors.white,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(BuyServices.routeName),
                  icon: Icon(Icons.group),
                  label: Text("Anunciar"))
              : FlatButton(
                  child: Text(
                    '\$ Vender',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName),
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
              showTradable: _showTradable,
              showDelivery: _showDelivery,
              filterCallback: _filterCallback,
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
