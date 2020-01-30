import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products.dart';

class CategorieOverviewScreen extends StatelessWidget {
  static const routeName = '/categorie-overview';

  const CategorieOverviewScreen({
    Key key,
  }) : super(key: key);

  Future<void> _fetchData(BuildContext ctx, String category) async {
    // await Provider.of<Products>(ctx).fetchCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: FutureBuilder(
        future: _fetchData(context, category),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('Error'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => _fetchData(context, category),
                child: Consumer<Products>(
                  builder: (ctx, prodData, child) => ListView.builder(
                    itemCount: prodData.categoryItems.length,
                    itemBuilder: (ctx, i) =>
                        ProductItem(prodData.categoryItems[i]),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
