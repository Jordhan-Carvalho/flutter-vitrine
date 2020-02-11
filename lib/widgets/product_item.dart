import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: product);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl[0]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Text(
            'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(product.price / 100).toString()}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: Row(
            children: <Widget>[
              if (product.tradable)
                const Tooltip(
                  child: const Icon(
                    Icons.autorenew,
                    size: 15,
                  ),
                  message: 'Trocável',
                ),
              if (product.delivery)
                const Tooltip(
                  child: const Icon(
                    Icons.local_shipping,
                    size: 15,
                  ),
                  message: 'Entrega disponível',
                ),
            ],
          ),
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
          title: Text(
            product.title,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
