import 'package:flutter/material.dart';
import 'package:vitrine/screens/edit_product_screen.dart';

import '../models/products.dart';

class UserProductItem extends StatelessWidget {
  final Product prod;

  UserProductItem(this.prod);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(prod.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(prod.imageUrl[0]),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: prod.id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
