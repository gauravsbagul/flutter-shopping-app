import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/prodcut-details-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('productId $productId'),
      ),
    );
  }
}
