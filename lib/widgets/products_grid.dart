import 'package:adazal_app/providers/product.dart';
import 'package:adazal_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../models/filters.dart';

class ProductsGrid extends StatelessWidget {
  final Filters filter;

  ProductsGrid(this.filter);

  List<Product> _getProducts(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    switch (filter) {
      case Filters.favourite:
        return productsProvider.favouriteItems;

      case Filters.showAll:
      default:
        return productsProvider.items;
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _getProducts(context);

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        );
      },
    );
  }
}
