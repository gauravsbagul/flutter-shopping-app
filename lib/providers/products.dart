import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:state_management_shop_app/models/hhtpExeption.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  final String authToken;
  final String userId;

  Products(this.authToken, this._items, this.userId);

  Future<bool> fetchAndSetproducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-shop-app-5e85a.firebaseio.com/products.json?auth=$authToken&filterString';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return true;
      }

      var favoriteUrl =
          'https://flutter-shop-app-5e85a.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

      final favoriteResponse = await http.get(favoriteUrl);
      final faoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              faoriteData == null ? false : faoriteData[prodId] ?? false,
        ));
      });

      _items = loadedProducts;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
      // throw error;
    }
  }

  Future<bool> addProduct(Product product) async {
    final url =
        'https://flutter-shop-app-5e85a.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'creatorId': userId,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );

      _items.add(newProduct);
      notifyListeners();

      return Future.value(true);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> updateProdut(String id, Product newProduct) async {
    final url =
        'https://flutter-shop-app-5e85a.firebaseio.com/products/$id.json?auth=$authToken';

    try {
      final prodIndex = _items.indexWhere((prod) => prod.id == id);
      if (prodIndex >= 0) {
        final response = await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite,
          }),
        );
        _items[prodIndex] = newProduct;
        notifyListeners();
      } else {}

      notifyListeners();

      return Future.value(true);
    } catch (error) {
      throw error;
    }
  }

  void deleteProduct(String id) async {
    try {
      final url =
          'https://flutter-shop-app-5e85a.firebaseio.com/products/$id.json?auth=$authToken';
      final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
      var existingProduct = _items[existingProductIndex];
      _items.removeAt(existingProductIndex);
      notifyListeners();

      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpExeption('Colud not delete product');
      }
      existingProduct = null;
    } catch (error) {
      throw error;
    }
  }
}
