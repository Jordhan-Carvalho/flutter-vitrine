import 'package:flutter/material.dart';

import '../models/dummy_products.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatelessWidget {
  // const HomeScreen({Key key}) : super(key: key);
  final prod = dummyProducts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      itemCount: prod.length,
      // use Changenotifier.value on grid and list
      itemBuilder: (ctx, index) => ProductItem(prod[index]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
