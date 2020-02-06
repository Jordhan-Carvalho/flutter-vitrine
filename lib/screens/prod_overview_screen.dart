import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProdOverview extends StatefulWidget {
  final String category;
  final String searchTerm;

  const ProdOverview({
    Key key,
    this.category,
    this.searchTerm,
  }) : super(key: key);
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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('cat ${widget.category}');
    print('rebuild ${widget.searchTerm}');

    _fetchProducts(refresh: true);

    _scrollController.addListener(_infiniteScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_infiniteScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _infiniteScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchProducts();
      double newPos = _scrollController.position.pixels - 50;
      _scrollController.position
          .moveTo(newPos, duration: Duration(milliseconds: 1500));
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
    if (widget.category != null) {
      await Provider.of<Products>(context, listen: false).fetchCategory(
        widget.category,
        refresh: refresh,
        hasMore: _hasMore,
        hasMoreCallback: _hasMoreCallback,
        lastDocumentCallback: _lastDocCallback,
        lastDocument: refresh ? null : _lastDocument,
      );
    } else if (widget.searchTerm != null && widget.searchTerm != "") {
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
        : Consumer<Products>(
            builder: (ctx, productData, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: productData.searchedItems.length == 0
                  ? Center(
                      child: Text('Sem resultados'),
                    )
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return ProductItem(
                                    productData.searchedItems[index]);
                              },
                              childCount: productData.searchedItems.length,
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
                          child: productData.searchedItems.length < 10
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                        ),
                      ],
                    ),
            ),
          );
  }

  Widget _buildBody({bool cat = false}) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () => _fetchProducts(refresh: true),
            child: Consumer<Products>(
              builder: (ctx, productData, child) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: (cat && productData.categoryItems.length == 0)
                    ? Center(
                        child: Text('Sem produtos nessa categoria'),
                      )
                    : CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return ProductItem(cat
                                      ? productData.categoryItems[index]
                                      : productData.items[index]);
                                },
                                childCount: cat
                                    ? productData.categoryItems.length
                                    : productData.items.length,
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
                            child:
                                (cat && productData.categoryItems.length < 10)
                                    ? SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                          ),
                        ],
                      ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.searchTerm != null && widget.searchTerm != "") {
      _fetchProducts(refresh: true);
      return _buildSearch();
    }

    print(widget.searchTerm);
    if (widget.category != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: _buildBody(cat: true),
      );
    } else {
      return _buildBody();
    }
  }
}
