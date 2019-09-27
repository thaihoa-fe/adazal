import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adazal_app/providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_item.dart';
import '../screens/orders.dart';

class CartScreen extends StatefulWidget {
  static final String routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Builder(
            builder: (context) => _buildCartSummary(context),
          ),
          _buildItems(context),
        ],
      ),
    );
  }

  Widget _buildItems(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Expanded(
      child: ListView.builder(
        primary: true,
        itemCount: cartProvider.itemsList.length,
        itemBuilder: (context, i) {
          return CartItem(cartProvider.itemsList[i]);
        },
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final scaffold = Scaffold.of(context);
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text(
              'Total',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Chip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Text(
                cartProvider.totalAmount.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.title.color,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  child: _isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 2.0,
                        )
                      : Text('Order Now'),
                  onPressed: cartProvider.totalAmount <= 0
                      ? null
                      : () async {
                          try {
                            _showLoading();
                            await Provider.of<OrdersProvider>(
                              context,
                              listen: false,
                            ).addOrder(
                              cartProvider.itemsList,
                              cartProvider.totalAmount,
                            );
                            cartProvider.clear();
                            Navigator.of(context)
                                .pushReplacementNamed(OrdersScreen.routeName);
                          } catch (e) {
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          } finally {
                            _hideLoading();
                          }
                        },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
