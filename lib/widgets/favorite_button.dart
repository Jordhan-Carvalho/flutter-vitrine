import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './theme_button.dart';
import '../providers/products.dart';
import '../models/product.dart';

class FavoriteButton extends StatefulWidget {
  final Product prod;
  FavoriteButton({Key key, @required this.prod}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite;

  void checkIsFavorite(List<Product> favoriteItems) {
    if (favoriteItems.isNotEmpty) {
      List<String> favoriteItemsIds = [];
      favoriteItems.forEach((favItem) {
        favoriteItemsIds.add(favItem.id);
      });
      if (favoriteItemsIds.contains(widget.prod.id)) {
        isFavorite = true;
      } else {
        isFavorite = false;
      }
    } else {
      isFavorite = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteItems = Provider.of<Products>(context).favoriteItems;
    checkIsFavorite(favoriteItems);
    return ThemeButton(
      content: Row(
        children: <Widget>[
          const Text('Favoritos'),
          isFavorite
              ? Icon(
                  Icons.star,
                  // color: Theme.of(context).primaryColor,
                )
              : Icon(Icons.star_border),
        ],
      ),
      handlePress: () async {
        if (isFavorite) {
          await Provider.of<Products>(context, listen: false)
              .deleteFavorite(widget.prod.id);
        } else {
          await Provider.of<Products>(context, listen: false)
              .addFavorite(widget.prod);
        }
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
