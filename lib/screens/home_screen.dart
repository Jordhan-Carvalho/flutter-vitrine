import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _fetchProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchProducts(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              // ...error handling
              return Center(
                child: Text('Error'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => _fetchProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, productData, child) => GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    itemCount: productData.items.length,
                    // use Changenotifier.value on grid and list
                    itemBuilder: (ctx, index) =>
                        ProductItem(productData.items[index]),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                  ),
                ),
              );
            }
          }
        });
  }
}
