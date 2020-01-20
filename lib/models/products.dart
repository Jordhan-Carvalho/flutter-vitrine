import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final DateTime createdOn;
  final String condition;
  final String zap;
  final bool delivery;
  final bool tradable;
  final String category;
  final List<String> imageUrl;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.createdOn,
    @required this.condition,
    @required this.zap,
    @required this.delivery,
    @required this.tradable,
    @required this.imageUrl,
    @required this.price,
    @required this.category,
  });
}
