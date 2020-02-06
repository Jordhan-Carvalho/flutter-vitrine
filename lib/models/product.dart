import 'package:flutter/foundation.dart';

enum Condition { Novo, Usado }

enum City { Barreiras, LEM }

enum Category {
  Imoveis,
  VeiculosPecas,
  ModaBeleza,
  EletronicosCelulares,
  CasaEletrodomesticos,
  EsporteLazer,
  LivrosBrinquedosVariados
}
// Dart doesnt support enum to store numbers or strings  https://github.com/dart-lang/language/issues/158
// enum Category { Imóveis, }

class Product {
  final String id;
  String title;
  int price;
  String description;
  final DateTime createdOn;
  Condition condition;
  bool delivery;
  bool tradable;
  String category;
  List<String> imageUrl;
  int telNumber;
  final City city;
  bool isFavorite;
  final String ownerName;
  List<String> searchTerms;

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
    this.ownerName,
    this.searchTerms,
  });

  static List<String> get loadCategories {
    return [
      "Imóveis",
      "Veiculos e Peças",
      "Moda e Beleza",
      "Eletrônicos e Celulares",
      "Para casa",
      "Esporte e Lazer",
      "Livros, Brinquedos e Variados"
    ];
  }
}
