import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/service.dart';

class Services with ChangeNotifier {
  Firestore _firestore = Firestore.instance;
  List<Service> _items = [];

  String _userId;

  set userId(String value) {
    _userId = value;
  }

  List<Service> get items {
    return [..._items];
  }

  List<Service> filterBySubcategories(String subcategory) {
    return _items
        .where((service) => service.subcategory == subcategory)
        .toList();
  }

  Future<void> addService(Service service) async {
    final _timeCreated = DateTime.now();

    try {
      DocumentReference resp = await _firestore.collection('services').add({
        "title": service.title,
        "category": service.category,
        "city": "Barreiras",
        "createdOn": _timeCreated.toIso8601String(),
        "subcategory": service.subcategory,
        "description": service.description,
        "telNumber": service.telNumber,
        "imagesUrl": service.imagesUrl,
        "ownerId": _userId,
        "serviceTags": service.serviceTags,
        "approved": true,
        "slogan": service.slogan,
        "tier": service.tier.index,
        "portfolio": service.portfolio
      });

      _items.insert(
          0,
          Service(
            id: resp.documentID,
            title: service.title,
            category: service.category,
            createdOn: _timeCreated,
            city: service.city,
            subcategory: service.subcategory,
            description: service.description,
            telNumber: service.telNumber,
            imagesUrl: service.imagesUrl,
            ownerId: _userId,
            serviceTags: service.serviceTags,
            slogan: service.slogan,
            tier: service.tier,
            portfolio: service.portfolio,
          ));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCategory(String category) async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await _firestore
          .collection('services')
          .where('category', isEqualTo: category)
          .where('approved', isEqualTo: true)
          .limit(10)
          .getDocuments();

      print('querysnapshot ${querySnapshot.documents.length}');

      print(querySnapshot.documents.length);

      var servicesList = <Service>[];

      querySnapshot.documents.forEach((item) {
        servicesList.add(Service(
          id: item.documentID,
          subcategory: item.data['subcategory'],
          category: item.data['category'],
          description: item.data['description'],
          telNumber: item.data['telNumber'],
          title: item.data['title'],
          city: item.data['city'] == "Barreiras" ? City.Barreiras : City.LEM,
          createdOn: DateTime.parse(item.data['createdOn']),
          imagesUrl: item.data['imagesUrl'].cast<String>(),
          serviceTags: item.data['serviceTags'].cast<String>(),
          ownerId: item.data['ownerId'],
          slogan: item.data['slogan'],
          tier: Tier.values[item.data['tier']],
          portfolio: item.data['portfolio'],
        ));
      });

      _items = servicesList;

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
