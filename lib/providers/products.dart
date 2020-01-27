import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/products.dart';

class Products with ChangeNotifier {
  Firestore _firestore = Firestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://vitrine-3da15.appspot.com');
  StorageUploadTask _uploadTask;

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product prod) async {
    final _timeCreated = DateTime.now();
    try {
      DocumentReference resp = await _firestore.collection('products').add({
        "title": prod.title,
        "category": prod.category,
        "city": "Barreiras",
        "condition": prod.condition == Condition.Usado ? "Usado" : "Novo",
        "createdOn": _timeCreated.toIso8601String(),
        "delivery": prod.delivery,
        "description": prod.description,
        "price": prod.price,
        "telNumber": prod.telNumber,
        "tradable": prod.tradable,
        "imageUrl": prod.imageUrl,
      });

      _items.insert(
          0,
          Product(
            id: resp.documentID,
            title: prod.title,
            category: prod.category,
            city: prod.city,
            condition: prod.condition,
            createdOn: _timeCreated,
            delivery: prod.delivery,
            description: prod.description,
            price: prod.price,
            telNumber: prod.telNumber,
            tradable: prod.tradable,
            imageUrl: prod.imageUrl,
          ));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot resp =
          await _firestore.collection('products').getDocuments();

      var loadedProds = <Product>[];

      resp.documents.forEach((item) {
        loadedProds.add(Product(
          id: item.documentID,
          condition: item.data['condition'] == "Usado"
              ? Condition.Usado
              : Condition.Novo,
          category: item.data['category'],
          delivery: item.data['delivery'],
          description: item.data['description'],
          price: item.data['price'],
          telNumber: item.data['telNumber'],
          title: item.data['title'],
          tradable: item.data['tradable'],
          city: item.data['city'] == "Barreiras" ? City.Barreiras : City.LEM,
          createdOn: DateTime.parse(item.data['createdOn']),
          imageUrl: item.data['imageUrl'].cast<String>(),
        ));
      });

      _items = loadedProds;
      print('feteched');
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProd) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await _firestore.collection('products').document(id).updateData({
          "title": newProd.title,
          "condition": newProd.condition == Condition.Usado ? "Usado" : "Novo",
          "category": newProd.category,
          "delivery": newProd.delivery,
          "description": newProd.description,
          "price": newProd.price,
          "telNumber": newProd.telNumber,
          "tradable": newProd.tradable,
        });
        _items[prodIndex] = newProd;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProd = _items[prodIndex];
    _items.removeAt(prodIndex);
    notifyListeners();
    try {
      await _firestore.collection('products').document(id).delete();

      // TO DO -- After auth modify uploader.dart /images/userId/price+description+title
      //  await _storage.ref().child(filePath).delete();

    } catch (e) {
      _items.insert(prodIndex, existingProd);
      notifyListeners();
      throw e;
    }
    existingProd = null;
  }
}
