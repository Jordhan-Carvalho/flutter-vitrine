import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key key}) : super(key: key);
  static final routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ha'),
      ),
      body: Center(
        child: Text('Product detail'),
      ),
    );
  }
}
