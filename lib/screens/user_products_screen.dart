import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key key}) : super(key: key);
  static final routeName = '/user-products-screen';

  Future<void> _fetchUserProds(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seus produtos'),
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
          ),
        ],
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
                          builder: (ctx, productsData, child) {
                        if (productsData.userItems.isEmpty) {
                          return Center(
                            child: Text("Sem produtos a venda"),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: productsData.userItems.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserProductItem(
                                  productsData.userItems[i],
                                ),
                                Divider(),
                              ],
                            ),
                          );
                        }
                      }),
                    )),
    );
  }
}
