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

  Future<bool> fetchAndSetproducts() async {
    const url = 'https://flutter-shop-app-5e85a.firebaseio.com/products.json';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
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

  Future<bool> addProdut(Product product) async {
    const url = 'https://flutter-shop-app-5e85a.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
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
        'https://flutter-shop-app-5e85a.firebaseio.com/products/$id.json';

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
          'https://flutter-shop-app-5e85a.firebaseio.com/products/$id.json';
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
