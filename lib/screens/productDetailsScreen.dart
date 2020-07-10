import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:state_management_shop_app/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/prodcut-details-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
