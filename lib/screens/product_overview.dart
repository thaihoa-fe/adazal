import 'package:adazal_app/providers/cart.dart';
import 'package:adazal_app/providers/products.dart';
import 'package:adazal_app/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/main_drawer.dart';
import '../models/filters.dart';
import 'package:badges/badges.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  Future fetchProductFuture;
  Filters listFilter = Filters.showAll;

  void changeFilters(Filters value) {
    setState(() {
      listFilter = value;
      if (value == Filters.showMyProducts) {
        fetchProductFuture = Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).fetchProductsByUser();
      } else {
        fetchProductFuture = Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).fetchProducts();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProductFuture = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('adazaL'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: changeFilters,
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show favourites'),
                value: Filters.favourite,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: Filters.showAll,
              ),
              PopupMenuItem(
                child: Text('Only my products'),
                value: Filters.showMyProducts,
              ),
            ],
          ),
          IconButton(
            iconSize: 25,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            icon: Consumer<CartProvider>(
              builder: (_, cart, icon) {
                return cart.itemCount != 0
                    ? Badge(
                        animationType: BadgeAnimationType.slide,
                        child: icon,
                        badgeContent: Text('${cart.itemCount}'),
                      )
                    : icon;
              },
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchProductFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ProductsGrid(listFilter);
        },
      ),
    );
  }
}
