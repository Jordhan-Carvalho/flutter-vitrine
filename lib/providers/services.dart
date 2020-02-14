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
  // List<Product> get filterDeliveryItems {
  //   return _items.where((prod) => prod.delivery).toList();
  // }

  // List<Product> get filterTradableItems {
  //   return _items.where((prod) => prod.tradable).toList();
  // }

  // List<Service> get filterTradDeliveryItems() {
  //   return _items.where((prod) => prod.delivery && prod.tradable).toList();
  // }

  // List<Product> get filterSearchDeliveryItems {
  //   return _searchedItems.where((prod) => prod.delivery).toList();
  // }

  // List<Product> get filterSearchTradableItems {
  //   return _searchedItems.where((prod) => prod.tradable).toList();
  // }

  // List<Product> get filterSearchTradDeliveryItems {
  //   return _searchedItems
  //       .where((prod) => prod.delivery && prod.tradable)
  //       .toList();
  // }

  // Product findById(String id) {
  //   return items.firstWhere((prod) => prod.id == id);
  // }

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

  // Future<void> updateProduct(String id, Product newProd) async {
  //   final prodIndex = _items.indexWhere((prod) => prod.id == id);
  //   final prodSearchTerm = KeywordGenerator.searchTerms(newProd.title);
  //   if (prodIndex >= 0) {
  //     try {
  //       await _firestore.collection('products').document(id).updateData({
  //         "title": newProd.title,
  //         "condition": newProd.condition == Condition.Usado ? "Usado" : "Novo",
  //         "category": newProd.category,
  //         "delivery": newProd.delivery,
  //         "description": newProd.description,
  //         "price": newProd.price,
  //         "telNumber": newProd.telNumber,
  //         "tradable": newProd.tradable,
  //         "searchTerms": prodSearchTerm,
  //       });
  //       _items[prodIndex] = newProd;
  //       notifyListeners();
  //     } catch (e) {
  //       throw e;
  //     }
  //   } else {
  //     print('...');
  //   }
  // }

  // Future<void> deleteProduct(String id) async {
  //   final prodIndex = _userItems.indexWhere((prod) => prod.id == id);
  //   var existingProd = _userItems[prodIndex];
  //   _userItems.removeAt(prodIndex);
  //   notifyListeners();
  //   try {
  //     //img path is /images/userId/description&price&title&1 => the number changes 1,2,3,4
  //     existingProd.imageUrl.forEach((imgUl) => print(imgUl));
  //     for (var i = 0; i < existingProd.imageUrl.length; i++) {
  //       String imgPath =
  //           'images/$_userId/${existingProd.description.substring(0, 15)}&${existingProd.price}&${existingProd.title}&$i';
  //       //regex remove white spaces
  //       print(imgPath.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
  //       await _storage
  //           .ref()
  //           .child(imgPath.replaceAll(new RegExp(r"\s+\b|\b\s"), ""))
  //           .delete();
  //     }
  //     await _firestore.collection('products').document(id).delete();
  //   } catch (e) {
  //     _userItems.insert(prodIndex, existingProd);
  //     notifyListeners();
  //     throw e;
  //   }
  //   existingProd = null;
  // }

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
