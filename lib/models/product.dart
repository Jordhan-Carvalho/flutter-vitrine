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
  String subcategory;
  List<String> imageUrl;
  int telNumber;
  final City city;
  bool isFavorite;
  final String ownerName;
  List<String> searchTerms;
  bool approved;

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
    this.approved,
    @required this.subcategory,
  });

  static Map<String, List<String>> get loadCategories {
    return {
      "Imóveis": [
        "Aluguel",
        "Compra e venda",
      ],
      "Veiculos e Peças": [
        'Carros',
        'Motos',
        'Aquático',
        'Peças',
      ],
      "Moda e Beleza": [
        "Vestuário",
        "Beleza e cuidado pessoal",
        "Acessórios",
      ],
      "Eletrônicos e Celulares": [
        "Celulares",
        "Informática",
        "Games",
        "TV",
        "Eletrônicos Áudio e Vídeo",
      ],
      "Para casa": [
        "Eletrodomésticos",
        "Cama Mesa e Banho",
        "Móveis",
        "Utilidades domésticas",
        "Jardins e Exteriores",
      ],
      "Esporte e Lazer": [
        "Fitness e Musculação",
        "Camping, Caça e Pesca",
        "Esporte em equipe",
        "Esporte individual",
        "Hobbie",
      ],
      "Livros, Brinquedos e Variados": [
        "Livros, Revistas e Comics",
        "Brinquedos",
        "Variados",
      ],
    };
  }
}
