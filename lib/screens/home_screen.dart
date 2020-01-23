import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Products>(context, listen: false).items;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      itemCount: prod.length,
      // use Changenotifier.value on grid and list
      itemBuilder: (ctx, index) => ProductItem(prod[index]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
