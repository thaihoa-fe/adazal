import 'package:adazal_app/providers/auth.dart';
import 'package:adazal_app/screens/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.7),
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (_, product, __) {
                return Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                );
              },
            ),
            color: Theme.of(context).accentColor,
            onPressed: () => product.toggleFavourite(auth.token, auth.userId),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              cart.addItem(product);
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.black.withOpacity(0.6),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                    content: Row(
                      children: <Widget>[
                        Icon(Icons.check),
                        SizedBox(width: 10),
                        Text('${product.title} has been added to cart'),
                      ],
                    ),
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}
