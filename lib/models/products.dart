import 'package:flutter/foundation.dart';

enum Condition { Novo, Usado }

enum City { Barreiras, LEM }

// Dart doesnt support enum to store numbers or strings  https://github.com/dart-lang/language/issues/158
// enum Category { Imóveis, }

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final DateTime createdOn;
  final Condition condition;
  final String zap;
  final bool delivery;
  final bool tradable;
  final String category;
  final List<String> imageUrl;
  final City city;

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
    @required this.city,
  });
}
