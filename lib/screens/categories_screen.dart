import 'package:flutter/material.dart';

import '../widgets/category_item.dart';
import '../models/product.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key key}) : super(key: key);

  final List<String> categories = Product.loadCategories;

  @override
  Widget build(BuildContext context) {
    return GridView(
      children: <Widget>[
        CategoryItem(
          category: categories[0],
          imgPath: "assets/images/imoveis.jpg",
        ),
        CategoryItem(
          category: categories[1],
          imgPath: "assets/images/veic.jpg",
        ),
        CategoryItem(
          category: categories[2],
          imgPath: "assets/images/moda.jpg",
        ),
        CategoryItem(
          category: categories[3],
          imgPath: "assets/images/eletronicos.jpg",
        ),
        CategoryItem(
          category: categories[4],
          imgPath: "assets/images/casa.jpg",
        ),
        CategoryItem(
          category: categories[5],
          imgPath: "assets/images/esporte.jpg",
        ),
        CategoryItem(
          category: categories[6],
          imgPath: "assets/images/variados.jpg",
        ),
      ],
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
