import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../models/product.dart';
import '../screens/edit_product_screen.dart';

class ProdOverview extends StatefulWidget {
  final String category;
  final String searchTerm;
  final bool showDelivery;
  final bool showTradable;
  final Function filterCallback;

  const ProdOverview(
      {Key key,
      this.category,
      this.searchTerm,
      this.showDelivery,
      this.showTradable,
      this.filterCallback})
      : super(key: key);
  static final routeName = '/prod-overview';

  @override
  _ProdOverviewState createState() => _ProdOverviewState();
}

class _ProdOverviewState extends State<ProdOverview>
    with AutomaticKeepAliveClientMixin<ProdOverview> {
  ScrollController _scrollController = ScrollController();
  bool _hasMore = true;
  bool _hasMoreSearch = true;
  bool _isLoading = false;
  DocumentSnapshot _lastDocument;
  DocumentSnapshot _lastSearchDocument;
  String dropdownValue = 'Todos';
  List<String> subcategories = ['Todos'];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    print('init  ${widget.showTradable}');
    if (widget.category != null && widget.category != '') {
      subcategories = [
        ...subcategories,
        ...Product.loadCategories[widget.category]
      ];
    }

    _fetchProducts(refresh: true);

    _scrollController.addListener(_infiniteScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_infiniteScroll);
    _scrollController.dispose();
    if (widget.showDelivery != null || widget.showTradable != null) {
      widget.filterCallback(false);
    }
    super.dispose();
  }

  void _infiniteScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchProducts();
      //Animation
      // double newPos = _scrollController.position.pixels - 50;
      // _scrollController.position
      //     .moveTo(newPos, duration: Duration(milliseconds: 1500));
    }
  }

  _lastDocCallback(DocumentSnapshot newValue) {
    _lastDocument = newValue;
  }

  _lastSearchDocCallback(DocumentSnapshot newValue) {
    _lastSearchDocument = newValue;
  }

  _hasMoreCallback(bool newValue) {
    _hasMore = newValue;
  }

  //Fixing the no more products after fetching search and coming back
  _hasMoreSearchCallback(bool newValue) {
    _hasMoreSearch = newValue;
  }

  Future<void> _fetchProducts({refresh = false}) async {
    if (widget.category != null && dropdownValue != 'Todos') {
      await Provider.of<Products>(context, listen: false).fetchSubcategory(
        dropdownValue,
        refresh: refresh,
        hasMore: _hasMore,
        hasMoreCallback: _hasMoreCallback,
        lastDocumentCallback: _lastDocCallback,
        lastDocument: refresh ? null : _lastDocument,
      );
      print('has more subcat $_hasMore');
    } else if (widget.category != null) {
      await Provider.of<Products>(context, listen: false).fetchCategory(
        widget.category,
        refresh: refresh,
        hasMore: _hasMore,
        hasMoreCallback: _hasMoreCallback,
        lastDocumentCallback: _lastDocCallback,
        lastDocument: refresh ? null : _lastDocument,
      );
      print('has more cat $_hasMore');
    } else if (widget.searchTerm != null &&
        widget.searchTerm != "" &&
        widget.searchTerm != " ") {
      Provider.of<Products>(context, listen: false).fetchSearch(
          widget.searchTerm,
          refresh: refresh,
          hasMore: _hasMoreSearch,
          hasMoreCallback: _hasMoreSearchCallback,
          lastDocumentCallback: _lastSearchDocCallback,
          lastDocument: refresh ? null : _lastSearchDocument);
    } else {
      await Provider.of<Products>(context, listen: false).fetchProducts(
        refresh: refresh,
        hasMore: _hasMore,
        hasMoreCallback: _hasMoreCallback,
        lastDocumentCallback: _lastDocCallback,
        lastDocument: refresh ? null : _lastDocument,
      );
    }
  }

  Widget _buildSearch() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Consumer<Products>(builder: (ctx, productData, child) {
            List<Product> newProdData = [];
            if (widget.showDelivery == true && widget.showTradable == true) {
              newProdData = productData.filterSearchTradDeliveryItems;
              if (_hasMoreSearch == true) {
                _fetchProducts();
              }
            } else if (widget.showTradable == true) {
              newProdData = productData.filterSearchTradableItems;
              if (_hasMoreSearch == true) {
                _fetchProducts();
              }
            } else if (widget.showDelivery == true) {
              newProdData = productData.filterSearchDeliveryItems;
              if (_hasMoreSearch == true) {
                _fetchProducts();
              }
            } else {
              newProdData = productData.searchedItems;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: newProdData.length == 0
                  ? Center(
                      child: Text('Sem resultados'),
                    )
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 2),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return ProductItem(newProdData[index]);
                              },
                              childCount: newProdData.length,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: newProdData.length < 10
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                        ),
                      ],
                    ),
            );
          });
  }

  Widget _buildBody({bool cat = false}) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () => _fetchProducts(refresh: true),
            child: Consumer<Products>(builder: (ctx, productData, child) {
              List<Product> newProdData = [];
              if (widget.showDelivery == true && widget.showTradable == true) {
                newProdData = productData.filterTradDeliveryItems;
                if (_hasMore == true) {
                  _fetchProducts();
                }
              } else if (widget.showTradable == true) {
                newProdData = productData.filterTradableItems;
                if (_hasMore == true) {
                  _fetchProducts();
                }
              } else if (widget.showDelivery == true) {
                newProdData = productData.filterDeliveryItems;
                if (_hasMore == true) {
                  _fetchProducts();
                }
              } else if (cat == true && dropdownValue == 'Todos') {
                print('categoria');
                newProdData = productData.categoryItems;
              } else if (cat == true && dropdownValue != 'Todos') {
                newProdData = productData.subcategoryItems;
                if (_hasMore == true) {
                  // _fetchProducts();
                }
              } else {
                newProdData = productData.items;
                //2020-02-14T17:21:02.598648
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: (cat && productData.categoryItems.length == 0)
                    ? Center(
                        child: Text('Sem produtos nessa categoria'),
                      )
                    : CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          if (cat)
                            SliverFixedExtentList(
                              itemExtent: 50,
                              delegate: SliverChildListDelegate([
                                Container(
                                  height: 150,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Filtro: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      DropdownButton<String>(
                                        value: dropdownValue,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                          });
                                          _fetchProducts(refresh: true);
                                        },
                                        items: subcategories
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 2),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return ProductItem(
                                    newProdData[index],
                                  );
                                },
                                childCount: newProdData.length,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: (_hasMore == false)
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                          ),
                        ],
                      ),
              );
            }),
          );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.searchTerm != null && widget.searchTerm != "") {
      _fetchProducts(refresh: true);
      return _buildSearch();
    }

    if (widget.category != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
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
            )
          ],
        ),
        body: _buildBody(cat: true),
      );
    } else {
      return _buildBody();
    }
  }
}
