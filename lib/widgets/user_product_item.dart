import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitrine/screens/edit_product_screen.dart';

import '../models/products.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final Product prod;

  UserProductItem(this.prod);

  Future<bool> _deleteConfirmation(BuildContext ctx) {
    // returns a promisse with tru or false after the button is pressed
    return showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
              title: Text('Tem certeza?'),
              content: Text('Quer mesmo apagar esse produto?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  child: Text('Não'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ));
  }

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
              onPressed: () async {
                if (!await _deleteConfirmation(context)) {
                  return;
                }
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(prod.id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
