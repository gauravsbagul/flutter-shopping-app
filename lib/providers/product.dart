import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  Future toggleFavoriteStatus() async {
    final url =
        'https://flutter-shop-app-5e85a.firebaseio.com/products/$id.json';

    final oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
    } catch (error) {
      print('ERROR: ${error}');
      notifyListeners();
      isFavorite = oldStatus;
    }
  }
}
