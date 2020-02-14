import 'package:flutter/material.dart';

enum City { Barreiras, LEM }
enum Tier { Basic, Advanced, Premium }

class Service {
  final String id;
  final String category;
  final String subcategory;
  final String title;
  final String slogan;
  final String ownerId;
  final int telNumber;
  final List<String> imagesUrl;
  final List<String> serviceTags;
  final String description;
  final bool approved;
  final DateTime createdOn;
  final City city;
  final String portfolio;
  Tier tier;

  Service({
    @required this.id,
    @required this.ownerId,
    @required this.telNumber,
    @required this.category,
    @required this.slogan,
    this.approved,
    @required this.createdOn,
    @required this.subcategory,
    @required this.title,
    @required this.imagesUrl,
    @required this.serviceTags,
    @required this.description,
    @required this.city,
    @required this.tier,
    this.portfolio,
  });

  static Map<String, Map<String, dynamic>> get loadCategories {
    return {
      "Assistência Técnica": {
        "icon": Icon(Icons.build),
        'subcategory': [
          'Aparelhos Eletrônicos',
          'Eletrodomésticos',
          'Informática e Telefonia',
        ]
      },
      "Aulas": {
        "icon": Icon(Icons.school),
        "subcategory": [
          'Acadêmicos',
          'Variados',
        ]
      },
      "Autos": {
        "icon": Icon(Icons.directions_car),
        "subcategory": [
          '4 rodas',
          '2 rodas',
        ]
      },
      "Consultoria": {
        "icon": Icon(Icons.show_chart),
        "subcategory": [
          'Mídia',
          'Negócios',
          'Jurídico',
          'Pessoal',
        ]
      },
      "Design e Tecnologia": {
        "icon": Icon(Icons.phonelink),
        "subcategory": [
          'Tecnologia',
          'Gráfica',
          'Áudio / Visual',
        ]
      },
      "Eventos": {
        "icon": Icon(Icons.speaker),
        "subcategory": [
          'Equipe e Suporte',
          'Comes e bebes',
          'Música e animação',
          'Serviços Complementares',
        ]
      },
      'Moda e Beleza': {
        "icon": Icon(Icons.face),
        "subcategory": [
          'Beleza',
          'Estilo',
        ]
      },
      'Construção e Reparos': {
        "icon": Icon(Icons.format_paint),
        "subcategory": [
          'Construção',
          'Reformas e Reparos',
          'Serviços Gerais',
        ]
      },
      'Saúde': {
        "icon": Icon(Icons.local_hospital),
        "subcategory": [
          'Para o Corpo',
          'Para a Mente',
          'Para a Família',
        ]
      },
      'Serviços Domésticos': {
        "icon": Icon(Icons.group),
        "subcategory": [
          'Para a Casa',
          'Para a Família',
          'Para os Pets',
        ]
      }
    };
  }
}
