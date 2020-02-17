import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../screens/product_detail_screen.dart';
import '../models/product.dart';
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
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(ProductDetailScreen.routeName, arguments: prod),
      child: ListTile(
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
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: prod.id);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  if (!await _deleteConfirmation(context)) {
                    return;
                  }
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(prod.id);
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text('Deletado com sucesso'),
                        duration: Duration(milliseconds: 2000),
                      ));
                  } catch (e) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text('Falha em deletar'),
                        duration: Duration(milliseconds: 2000),
                      ));
                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
