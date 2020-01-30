import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  bool _hasMore = true;
  bool _isLoading = false;

  DocumentSnapshot _lastDocument;

  @override
  void initState() {
    super.initState();
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
      double newPos = _scrollController.position.pixels - 40;
      _scrollController.position
          .moveTo(newPos, duration: Duration(milliseconds: 1500));
    }
  }

  _lastDocCallback(DocumentSnapshot newValue) {
    _lastDocument = newValue;
  }

  _hasMoreCallback(bool newValue) {
    _hasMore = newValue;
  }

  Future<void> _fetchProducts({refresh = false}) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(
      refresh: refresh,
      hasMore: _hasMore,
      hasMoreCallback: _hasMoreCallback,
      lastDocumentCallback: _lastDocCallback,
      lastDocument: refresh ? null : _lastDocument,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () => _fetchProducts(refresh: true),
            child: Consumer<Products>(
              builder: (ctx, productData, child) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductItem(productData.items[index]);
                        },
                        childCount: productData.items.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
