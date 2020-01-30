import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with AutomaticKeepAliveClientMixin<FavoritesScreen> {
  bool _isLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print('init');
    _fetchProducts();
    super.initState();
  }

  Future<void> _fetchProducts() async {
    await Provider.of<Products>(context, listen: false).fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // because we use the keep alive mixin.
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Consumer<Products>(
            builder: (ctx, productData, child) => GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              itemCount: productData.favoriteItems.length,
              // use Changenotifier.value on grid and list
              itemBuilder: (ctx, index) =>
                  ProductItem(productData.favoriteItems[index]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          );
  }
}
