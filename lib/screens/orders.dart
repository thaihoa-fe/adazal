import 'package:adazal_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static final String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future fetchOrdersFuture;

  @override
  void initState() {
    super.initState();
    fetchOrdersFuture =
        Provider.of<OrdersProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: FutureBuilder(
        future: fetchOrdersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (ordersProvider.orders.isEmpty) {
            return Center(
              child: Text('You have no order'),
            );
          }

          return ListView.builder(
            itemCount: ordersProvider.orders.length,
            itemBuilder: (context, i) => OrderItem(ordersProvider.orders[i]),
          );
        },
      ),
    );
  }
}
