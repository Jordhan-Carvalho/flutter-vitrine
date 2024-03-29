import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/forbidden_exception.dart';
import '../helpers/gen_search_terms.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  Firestore _firestore = Firestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://vitrine-3da15.appspot.com');
  List<Product> _items = [];
  List<Product> _favItems = [];
  List<Product> _categoryItems = [];
  List<Product> _userItems = [];
  List<Product> _searchedItems = [];
  List<Product> _subcategoryItems = [];

  String _userId;
  String _userName;

  set userName(String value) {
    _userName = value;
  }

  set userId(String value) {
    _userId = value;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get filterDeliveryItems {
    return _items.where((prod) => prod.delivery).toList();
  }

  List<Product> get filterTradableItems {
    return _items.where((prod) => prod.tradable).toList();
  }

  List<Product> get filterTradDeliveryItems {
    return _items.where((prod) => prod.delivery && prod.tradable).toList();
  }

  // List<Product> filterBySubcategory(String subcat) {
  //   return _categoryItems.where((prod) => prod.subcategory == subcat).toList();
  // }

  List<Product> get favoriteItems {
    return [..._favItems];
  }

  List<Product> get categoryItems {
    return [..._categoryItems];
  }

  List<Product> get subcategoryItems {
    return [..._subcategoryItems];
  }

  List<Product> get userItems {
    return [..._userItems];
  }

  List<Product> get searchedItems {
    return [..._searchedItems];
  }

  List<Product> get filterSearchDeliveryItems {
    return _searchedItems.where((prod) => prod.delivery).toList();
  }

  List<Product> get filterSearchTradableItems {
    return _searchedItems.where((prod) => prod.tradable).toList();
  }

  List<Product> get filterSearchTradDeliveryItems {
    return _searchedItems
        .where((prod) => prod.delivery && prod.tradable)
        .toList();
  }

  Product findUserProdById(String id) {
    return userItems.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product prod, DateTime timeCreated) async {
    final titleSearchTerm = KeywordGenerator.searchTerms(prod.title);
    final subcatSearchTerm = KeywordGenerator.searchTerms(prod.subcategory);
    final descSearchTerm =
        KeywordGenerator.searchTerms(prod.description.substring(0, 15));

    final prodSearchTerms = [
      ...titleSearchTerm,
      ...subcatSearchTerm,
      ...descSearchTerm,
    ].toSet().toList();

    try {
      DocumentReference resp = await _firestore.collection('products').add({
        "title": prod.title,
        "category": prod.category,
        "subcategory": prod.subcategory,
        "city": "Barreiras",
        "condition": prod.condition == Condition.Usado ? "Usado" : "Novo",
        "createdOn": timeCreated.toIso8601String(),
        "delivery": prod.delivery,
        "description": prod.description,
        "price": prod.price,
        "telNumber": prod.telNumber,
        "tradable": prod.tradable,
        "imageUrl": prod.imageUrl,
        "ownerId": _userId,
        "ownerName": _userName,
        "searchTerms": prodSearchTerms,
        "approved": true,
      });

      _items.insert(
          0,
          Product(
            id: resp.documentID,
            title: prod.title,
            category: prod.category,
            subcategory: prod.subcategory,
            city: prod.city,
            condition: prod.condition,
            createdOn: timeCreated,
            delivery: prod.delivery,
            description: prod.description,
            price: prod.price,
            telNumber: prod.telNumber,
            tradable: prod.tradable,
            imageUrl: prod.imageUrl,
            ownerName: _userName,
            searchTerms: prodSearchTerms,
            ownerId: _userId,
          ));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchProducts({
    bool filterByUser = false,
    bool hasMore,
    Function hasMoreCallback,
    DocumentSnapshot lastDocument,
    Function lastDocumentCallback,
    bool refresh = false,
  }) async {
    QuerySnapshot querySnapshot;
    try {
      if (filterByUser) {
        querySnapshot = await _firestore
            .collection('products')
            .where("ownerId", isEqualTo: _userId)
            .orderBy("createdOn", descending: true)
            .getDocuments();
      } else {
        if (!hasMore && !refresh) {
          print('No More Products');
          return;
        }
        print('fetching');
        if (lastDocument == null) {
          querySnapshot = await _firestore
              .collection('products')
              .where('approved', isEqualTo: true)
              .orderBy("createdOn", descending: true)
              .limit(10)
              .getDocuments();
        } else {
          querySnapshot = await _firestore
              .collection('products')
              .where('approved', isEqualTo: true)
              .orderBy("createdOn", descending: true)
              .startAfterDocument(lastDocument)
              .limit(10)
              .getDocuments();
        }
        if (querySnapshot.documents.length < 10) {
          hasMore = false;
          hasMoreCallback(hasMore);
        }
        if (querySnapshot.documents.length == 10) {
          hasMore = true;
          hasMoreCallback(hasMore);
        }
        lastDocumentCallback(
            querySnapshot.documents[querySnapshot.documents.length - 1]);
      }

      var loadedProds = <Product>[];

      querySnapshot.documents.forEach((item) {
        loadedProds.add(Product(
            id: item.documentID,
            condition: item.data['condition'] == "Usado"
                ? Condition.Usado
                : Condition.Novo,
            category: item.data['category'],
            subcategory: item.data['subcategory'],
            delivery: item.data['delivery'],
            description: item.data['description'],
            price: item.data['price'],
            telNumber: item.data['telNumber'],
            title: item.data['title'],
            tradable: item.data['tradable'],
            city: item.data['city'] == "Barreiras" ? City.Barreiras : City.LEM,
            createdOn: DateTime.parse(item.data['createdOn']),
            imageUrl: item.data['imageUrl'].cast<String>(),
            ownerName: item.data['ownerName'],
            ownerId: item.data['ownerId']));
      });

      if (filterByUser) {
        _userItems = loadedProds;
      } else {
        if (refresh) {
          _items = loadedProds;
        } else {
          _items.addAll(loadedProds);
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProd) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final prodSearchTerm = KeywordGenerator.searchTerms(newProd.title);
    if (prodIndex >= 0) {
      try {
        await _firestore.collection('products').document(id).updateData({
          "title": newProd.title,
          "condition": newProd.condition == Condition.Usado ? "Usado" : "Novo",
          "category": newProd.category,
          "subcategory": newProd.subcategory,
          "delivery": newProd.delivery,
          "description": newProd.description,
          "price": newProd.price,
          "telNumber": newProd.telNumber,
          "tradable": newProd.tradable,
          "searchTerms": prodSearchTerm,
        });
        _items[prodIndex] = newProd;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    } else {
      try {
        await _firestore.collection('products').document(id).updateData({
          "title": newProd.title,
          "condition": newProd.condition == Condition.Usado ? "Usado" : "Novo",
          "category": newProd.category,
          "subcategory": newProd.subcategory,
          "delivery": newProd.delivery,
          "description": newProd.description,
          "price": newProd.price,
          "telNumber": newProd.telNumber,
          "tradable": newProd.tradable,
          "searchTerms": prodSearchTerm,
        });
        notifyListeners();
      } catch (e) {
        throw e;
      }
    }
  }

  Future<void> deleteProduct(String id, {bool admin = false}) async {
    Product existingProd;
    int prodIndex;
    if (admin) {
      prodIndex = _items.indexWhere((prod) => prod.id == id);
      existingProd = _items[prodIndex];
      _items.removeAt(prodIndex);
    } else {
      prodIndex = _userItems.indexWhere((prod) => prod.id == id);
      existingProd = _userItems[prodIndex];
      _userItems.removeAt(prodIndex);
    }
    notifyListeners();
    try {
      //img path is /images/userId/description&price&title&1 => the number changes 1,2,3,4
      // existingProd.imageUrl.forEach((imgUl) => print(imgUl));
      for (var i = 0; i < existingProd.imageUrl.length; i++) {
        String imgPath =
            'images/${existingProd.ownerId}/${existingProd.createdOn.toString()}&$i';
        //regex remove white spaces
        // print(imgPath.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
        await _storage
            .ref()
            .child(imgPath.replaceAll(new RegExp(r"\s+\b|\b\s"), ""))
            .delete();
      }
      await _firestore.collection('products').document(id).delete();
    } catch (e) {
      if (admin) {
        _items.insert(prodIndex, existingProd);
      } else {
        _userItems.insert(prodIndex, existingProd);
      }
      notifyListeners();
      throw e;
    }
    existingProd = null;
  }

  Future<void> fetchFavorites() async {
    // Firestore data structure are: Collection - document - Collection - document - Collection - document
    //E g: db.collection("app").document("users").collection(uid).document("notifications")
    try {
      QuerySnapshot resp = await _firestore
          .collection('userSettings')
          .document('$_userId')
          .collection('favorites')
          .getDocuments();

      var favoriteProds = <Product>[];

      resp.documents.forEach((item) {
        favoriteProds.add(Product(
          id: item.documentID,
          condition: item.data['condition'] == "Usado"
              ? Condition.Usado
              : Condition.Novo,
          category: item.data['category'],
          subcategory: item.data['subcategory'],
          delivery: item.data['delivery'],
          description: item.data['description'],
          price: item.data['price'],
          telNumber: item.data['telNumber'],
          title: item.data['title'],
          tradable: item.data['tradable'],
          city: item.data['city'] == "Barreiras" ? City.Barreiras : City.LEM,
          createdOn: DateTime.parse(item.data['createdOn']),
          imageUrl: item.data['imageUrl'].cast<String>(),
          ownerName: item.data['ownerName'],
          ownerId: item.data['ownerId'],
        ));
      });
      _favItems = favoriteProds;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addFavorite(Product prod) async {
    try {
      await _firestore
          .collection('userSettings')
          .document('$_userId')
          .collection('favorites')
          .document(prod.id)
          .setData({
        "title": prod.title,
        "telNumber": prod.telNumber,
        "condition": prod.condition == Condition.Usado ? "Usado" : "Novo",
        "category": prod.category,
        "subcategory": prod.subcategory,
        "delivery": prod.delivery,
        "description": prod.description,
        "price": prod.price,
        "tradable": prod.tradable,
        "imageUrl": prod.imageUrl,
        "createdOn": prod.createdOn.toIso8601String(),
        "city": prod.city == City.Barreiras ? "Barreiras" : "LEM",
        "ownerName": prod.ownerName,
      });

      _favItems.insert(0, prod);

      print("added to favorites");
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> deleteFavorite(String prodId) async {
    final int favIndex =
        _favItems.indexWhere((element) => element.id == prodId);
    var existingFav = _favItems[favIndex];
    _favItems.removeAt(favIndex);
    notifyListeners();
    try {
      await _firestore
          .collection('userSettings')
          .document('$_userId')
          .collection('favorites')
          .document(prodId)
          .delete();
      print('deletado');
    } catch (e) {
      _favItems.insert(favIndex, existingFav);
      notifyListeners();
      print(e);
      throw e;
    }
  }

  Future<void> fetchCategory(
    String category, {
    bool filterByUser = false,
    bool hasMore,
    Function hasMoreCallback,
    DocumentSnapshot lastDocument,
    Function lastDocumentCallback,
    bool refresh = false,
  }) async {
    QuerySnapshot querySnapshot;
    try {
      if (!hasMore && !refresh) {
        print('No More Products');
        return;
      }
      if (lastDocument == null) {
        querySnapshot = await _firestore
            .collection('products')
            .where('category', isEqualTo: category)
            .where('approved', isEqualTo: true)
            .orderBy("createdOn", descending: true)
            .limit(10)
            .getDocuments();
      } else {
        querySnapshot = await _firestore
            .collection('products')
            .where('category', isEqualTo: category)
            .where('approved', isEqualTo: true)
            .orderBy("createdOn", descending: true)
            .startAfterDocument(lastDocument)
            .limit(10)
            .getDocuments();
      }
      print('querysnapshot ${querySnapshot.documents.length}');
      if (querySnapshot.documents.length < 10) {
        hasMore = false;
        hasMoreCallback(hasMore);
      }
      if (querySnapshot.documents.length == 10) {
        hasMore = true;
        hasMoreCallback(hasMore);
      }
      if (querySnapshot.documents.length != 0) {
        lastDocumentCallback(
            querySnapshot.documents[querySnapshot.documents.length - 1]);
      }

      print(querySnapshot.documents.length);

      var categoryProds = <Product>[];

      querySnapshot.documents.forEach((item) {
        categoryProds.add(Product(
          id: item.documentID,
          condition: item.data['condition'] == "Usado"
              ? Condition.Usado
              : Condition.Novo,
          category: item.data['category'],
          subcategory: item.data['subcategory'],
          delivery: item.data['delivery'],
          description: item.data['description'],
          price: item.data['price'],
          telNumber: item.data['telNumber'],
          title: item.data['title'],
          tradable: item.data['tradable'],
          city: item.data['city'] == "Barreiras" ? City.Barreiras : City.LEM,
          createdOn: DateTime.parse(item.data['createdOn']),
          imageUrl: item.data['imageUrl'].cast<String>(),
          ownerName: item.data['ownerName'],
          ownerId: item.data['ownerId'],
        ));
      });

      if (refresh) {
        _categoryItems = categoryProds;
      } else {
        _categoryItems.addAll(categoryProds);
      }

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchSubcategory(
    String subcategory, {
    bool filterByUser = false,
    bool hasMore,
    Function hasMoreCallback,
    DocumentSnapshot lastDocument,
    Function lastDocumentCallback,
    bool refresh = false,
  }) async {
    QuerySnapshot querySnapshot;
    try {
      if (!hasMore && !refresh) {
        print('No More Products');
        return;
      }
      if (lastDocument == null) {
        querySnapshot = await _firestore
            .collection('products')
            .where('subcategory', isEqualTo: subcategory)
            .where('approved', isEqualTo: true)
            .orderBy("createdOn", descending: true)
            .limit(10)
            .getDocuments();
      } else {
        querySnapshot = await _firestore
            .collection('products')
            .where('subcategory', isEqualTo: subcategory)
            .where('approved', isEqualTo: true)
            .orderBy("createdOn", descending: true)
            .startAfterDocument(lastDocument)
            .limit(10)
            .getDocuments();
      }
      print('querysnapshot ${querySnapshot.documents.length}');
      if (querySnapshot.documents.length < 10) {
        hasMore = false;
        hasMoreCallback(hasMore);
      }
      if (querySnapshot.documents.length == 10) {
        hasMore = true;
        hasMoreCallback(hasMore);
      }
      if (querySnapshot.documents.length != 0) {
        lastDocumentCallback(
            querySnapshot.documents[querySnapshot.documents.length - 1]);
      }

      print(querySnapshot.documents.length);

      var subcategoryProds = <Product>[];

      querySnapshot.documents.forEach((item) {
        subcategoryProds.add(Product(
          id: item.documentID,
          condition: item.data['condition'] == "Usado"
              ? Condition.Usado
              : Condition.Novo,
          category: item.data['category'],
          subcategory: item.data['subcategory'],
          delivery: item.data['delivery'],
          description: item.data['description'],
          price: item.data['price'],
          telNumber: item.data['telNumber'],
          title: item.data['title'],
          tradable: item.data['tradable'],
          city: item.data['city'] == "Barreiras" ? City.Barreiras : City.LEM,
          createdOn: DateTime.parse(item.data['createdOn']),
          imageUrl: item.data['imageUrl'].cast<String>(),
          ownerName: item.data['ownerName'],
          ownerId: item.data['ownerId'],
        ));
      });

      if (refresh) {
        _subcategoryItems = subcategoryProds;
      } else {
        _subcategoryItems.addAll(subcategoryProds);
      }

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchSearch(
    String searchedProd, {
    bool hasMore,
    Function hasMoreCallback,
    DocumentSnapshot lastDocument,
    Function lastDocumentCallback,
    bool refresh = false,
  }) async {
    QuerySnapshot querySnapshot;

    final noSpaceSearch = searchedProd
        .replaceAll(new RegExp(r'[^A-Za-z0-9éêáàãâíóôõúç]'), "")
        .trim();

    try {
      if (!hasMore && !refresh) {
        print('No More Products');
        return;
      }
      if (lastDocument == null) {
        querySnapshot = await _firestore
            .collection('products')
            .where('approved', isEqualTo: true)
            .where("searchTerms", arrayContains: noSpaceSearch)
            .orderBy("createdOn", descending: true)
            .limit(10)
            .getDocuments();
      } else {
        querySnapshot = await _firestore
            .collection('products')
            .where('approved', isEqualTo: true)
            .where("searchTerms", arrayContains: noSpaceSearch)
            .orderBy("createdOn", descending: true)
            .startAfterDocument(lastDocument)
            .limit(10)
            .getDocuments();
      }
      print('querysnapshot ${querySnapshot.documents.length}');
      if (querySnapshot.documents.length < 10) {
        hasMore = false;
        hasMoreCallback(hasMore);
      }
      if (querySnapshot.documents.length == 10) {
        hasMore = true;
        hasMoreCallback(hasMore);
      }
      if (querySnapshot.documents.length != 0) {
        lastDocumentCallback(
            querySnapshot.documents[querySnapshot.documents.length - 1]);
      }

      print(querySnapshot.documents.length);

      var searchProds = <Product>[];

      querySnapshot.documents.forEach((item) {
        searchProds.add(Product(
          id: item.documentID,
          condition: item.data['condition'] == "Usado"
              ? Condition.Usado
              : Condition.Novo,
          category: item.data['category'],
          subcategory: item.data['subcategory'],
          delivery: item.data['delivery'],
          description: item.data['description'],
          price: item.data['price'],
          telNumber: item.data['telNumber'],
          title: item.data['title'],
          tradable: item.data['tradable'],
          city: item.data['city'] == "Barreiras" ? City.Barreiras : City.LEM,
          createdOn: DateTime.parse(item.data['createdOn']),
          imageUrl: item.data['imageUrl'].cast<String>(),
          ownerName: item.data['ownerName'],
          ownerId: item.data['ownerId'],
        ));
      });

      if (refresh) {
        _searchedItems = searchProds;
      } else {
        _searchedItems.addAll(searchProds);
      }
      print(searchProds);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> reportProduct(String prodId) async {
    try {
      DocumentSnapshot docResult =
          await _firestore.collection('products').document(prodId).get();
      List<String> reports = [];

      if (docResult.data['reports'] != null) {
        reports = [...docResult.data['reports'].cast<String>()];
        print(reports);
      }

      if (reports.contains(_userId)) {
        throw ForbiddenException("Usuário já reportou");
      } else {
        reports.add(_userId);
        await _firestore.collection('products').document(prodId).updateData({
          "reports": reports,
        });

        if (reports.length > 2) {
          await _firestore.collection('products').document(prodId).updateData({
            "approved": false,
          });
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
