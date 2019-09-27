import 'package:adazal_app/models/http_exeption.dart';
import 'package:adazal_app/providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/orders.dart';

class OrdersRepository {
  String authToken;
  OrdersRepository(this.authToken);

  Future<String> saveOrder(OrderItemProvider item, String userId) async {
    final url =
        'https://adazal-8d5b6.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.post(url, body: json.encode(item.toJSON()));

    if (response.statusCode != 200) {
      throw HttpExeption('Error occured');
    }

    final body = json.decode(response.body);
    return body['name'];
  }

  Future<List<OrderItemProvider>> fetchOrders(String userId) async {
    final url =
        'https://adazal-8d5b6.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw HttpExeption('Error occured');
    }

    Map<String, dynamic> body = json.decode(response.body);
    final items = <OrderItemProvider>[];
    if (body != null) {
      body.forEach((id, data) {
        items.add(OrderItemProvider(
          id: id,
          dateTime: DateTime.parse(data['dateTime']),
          amount: data['amount'],
          products: (data['products'] as List).map((cartItem) {
            return CartItemProvider(
              id: cartItem['id'],
              title: cartItem['title'],
              price: cartItem['price'],
              productId: cartItem['productId'],
              quantity: cartItem['quantity'],
            );
          }).toList(),
        ));
      });
    }

    return items;
  }
}
