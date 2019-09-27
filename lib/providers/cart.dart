import 'package:flutter/foundation.dart';
import './product.dart';

class CartItemProvider with ChangeNotifier {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  CartItemProvider({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.productId,
  });

  Map<String, dynamic> toJSON() {
    return {
      'id': this.id,
      'title': this.title,
      'quantity': this.quantity,
      'price': this.price,
      'productId': this.productId,
    };
  }
}

class CartProvider with ChangeNotifier {
  Map<String, CartItemProvider> _items = {};

  Map<String, CartItemProvider> get items {
    return {..._items};
  }

  List<CartItemProvider> get itemsList {
    return _items.values.toList();
  }

  bool isInCart(Product product) {
    return _items.containsKey(product.id);
  }

  int get itemCount {
    return _items.values
        .fold(0, (result, cartItem) => result + cartItem.quantity);
  }

  double get totalAmount {
    return _items.values.fold(0.0,
        (result, cartItem) => result + (cartItem.price * cartItem.quantity));
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existingItem) {
        return CartItemProvider(
          productId: product.id,
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        );
      });
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItemProvider(
          productId: product.id,
          id: DateTime.now().toString(),
          price: product.price,
          title: product.title,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItemProvider(
          title: existingItem.title,
          id: existingItem.id,
          price: existingItem.price,
          productId: existingItem.productId,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
