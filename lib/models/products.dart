import 'package:flutter/foundation.dart';

enum Condition { Novo, Usado }

enum City { Barreiras, LEM }

// Dart doesnt support enum to store numbers or strings  https://github.com/dart-lang/language/issues/158
// enum Category { Imóveis, }

class Product {
  final String id;
  final String title;
  final int price;
  final String description;
  final DateTime createdOn;
  Condition condition;
  bool delivery;
  bool tradable;
  String category;
  final List<String> imageUrl;
  int telNumber;
  final City city;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    this.createdOn,
    @required this.condition,
    @required this.delivery,
    @required this.tradable,
    this.imageUrl,
    @required this.price,
    @required this.category,
    this.city,
    @required this.telNumber,
  });

  static List<String> get loadCategories {
    return [
      "Imóveis",
      "Veiculos e Peças",
      "Moda e Beleza",
      "Eletrônicos e Celulares",
      "Casa e Eletrodomésticos",
      "Esporte e Lazer",
      "Livros, Brinquedos e Variados"
    ];
  }
}
