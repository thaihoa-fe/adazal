import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/confirm_delete.dart';

class CartItem extends StatelessWidget {
  final CartItemProvider cartItem;

  CartItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final product = productsProvider.findById(cartItem.productId);

    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog<bool>(
          context: context,
          builder: (context) {
            return ConfirmDismiss();
          },
        );
      },
      onDismissed: (_) {
        cartProvider.removeItem(cartItem.productId);
      },
      background: Container(
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(right: 16.0),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: ListTile(
            leading: ClipOval(
              child: Image.network(
                product.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(cartItem.title),
            trailing: Container(
              width: 100,
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  Text('${cartItem.price}\$'),
                  SizedBox(width: 5),
                  Text('x${cartItem.quantity}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
