import 'package:adazal_app/widgets/main_drawer.dart';
import 'package:adazal_app/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_product.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static final routeName = '/user-products';

  Future<void> loadProducts(context) {
    return Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).fetchProductsByUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Products management'),
      ),
      body: FutureBuilder(
        future: loadProducts(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => loadProducts(context),
            child: Consumer<ProductsProvider>(
              builder: (context, productsProvider, _) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: productsProvider.items.isEmpty
                      ? Center(
                          child: Text('Empty'),
                        )
                      : ListView.builder(
                          itemBuilder: (context, i) {
                            return UserProductItem(productsProvider.items[i]);
                          },
                          itemCount: productsProvider.items.length,
                        ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        },
      ),
    );
  }
}
