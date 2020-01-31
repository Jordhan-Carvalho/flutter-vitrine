import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key key}) : super(key: key);
  static final routeName = '/user-products-screen';

  Future<void> _fetchUserProds(BuildContext context) async {
    print('hi');
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchProducts(filterByUser: true);
    } catch (e) {
      print(e);
    }
    print('ho');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seus produtos'),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
          future: _fetchUserProds(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: EdgeInsets.all(8),
                      child: Consumer<Products>(
                        builder: (ctx, productsData, child) => ListView.builder(
                          itemCount: productsData.userItems.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                productsData.userItems[i],
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    )),
    );
  }
}
