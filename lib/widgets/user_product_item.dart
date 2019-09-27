import 'package:adazal_app/providers/product.dart';
import 'package:adazal_app/providers/products.dart';
import 'package:adazal_app/screens/edit_product.dart';
import 'package:adazal_app/widgets/confirm_delete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(product.title),
      leading: Container(
        child: ClipOval(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        width: 50,
        height: 50,
      ),
      subtitle: Text('${product.price}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: product.id,
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              final shouldDelete = await showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDismiss();
                },
              );
              if (shouldDelete != null && shouldDelete) {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .removeProduct(product.id);
                } catch (_) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text('Delete product failed!'),
                  ));
                }
              }
            },
          )
        ],
      ),
    );
  }
}
