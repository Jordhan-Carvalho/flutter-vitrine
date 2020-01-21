import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';

// import '../providers/product.dart';
import '../models/products.dart';
import '../screens/product_detail_screen.dart';
// import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context);
    // final authData = Provider.of<Auth>(context, listen: false);

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
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl[0]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Text(
            '${describeEnum(product.condition)}',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Row(
            children: <Widget>[
              if (product.tradable)
                const Tooltip(
                  child: Icon(Icons.autorenew),
                  message: 'Trocável',
                ),
              if (product.delivery)
                const Tooltip(
                  child: Icon(Icons.local_shipping),
                  message: 'Entrega disponível',
                ),
            ],
          ),
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          subtitle: Text('R\$ ${product.price.toString()}'),
        ),
      ),
    );
  }
}
