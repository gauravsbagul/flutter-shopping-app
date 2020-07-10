import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:state_management_shop_app/providers/products.dart';
import 'package:state_management_shop_app/providers/cart.dart';
import 'package:state_management_shop_app/widgets/badge.dart';
import 'package:state_management_shop_app/widgets/productsGrid.dart';

import 'cartScreen.dart';

enum FilterOptions { Favorites, All, Cart }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedvalue) {
                if (selectedvalue == FilterOptions.Favorites) {
                  // productContainer.showFavorittesOnly();
                  setState(() {
                    _showOnlyFavorites = true;
                  });
                } else {
                  // productContainer.showAll();
                  setState(() {
                    _showOnlyFavorites = false;
                  });
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
