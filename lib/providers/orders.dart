import 'package:adazal_app/providers/cart.dart';
import 'package:flutter/foundation.dart';
import '../repositories/orders.dart';

class OrderItemProvider {
  final String id;
  final double amount;
  final List<CartItemProvider> products;
  final DateTime dateTime;

  const OrderItemProvider({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

  Map<String, dynamic> toJSON() {
    return {
      'amount': this.amount,
      'dateTime': this.dateTime.toIso8601String(),
      'products': this.products.map((cartItem) => cartItem.toJSON()).toList(),
    };
  }

  OrderItemProvider copyWith({
    String id,
    double amount,
    List<CartItemProvider> products,
    DateTime dateTime,
  }) {
    return OrderItemProvider(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      products: products ?? this.products,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

class OrdersProvider extends ChangeNotifier {
  List<OrderItemProvider> _orders = [];

  String authToken;
  String userId;

  OrdersProvider(this.authToken, this.userId, this._orders);

  OrdersRepository get repository {
    return OrdersRepository(this.authToken);
  }

  List<OrderItemProvider> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    try {
      _orders = await repository.fetchOrders(userId);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(
    List<CartItemProvider> products,
    double totalAmount,
  ) async {
    final item = OrderItemProvider(
      id: DateTime.now().toString(),
      amount: totalAmount,
      products: products,
      dateTime: DateTime.now(),
    );
    try {
      final id = await repository.saveOrder(item, userId);
      _orders.insert(
        0,
        item.copyWith(id: id),
      );
      notifyListeners();
    } catch (e) {
      _orders.removeAt(0);
      notifyListeners();
      throw e;
    }
  }
}
