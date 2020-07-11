import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:state_management_shop_app/providers/products.dart';
import 'package:state_management_shop_app/screens/editProductScreen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(this.title, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => productsData.deleteProduct(id),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
