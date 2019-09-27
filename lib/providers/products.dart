import 'package:adazal_app/repositories/products.dart';
import 'package:flutter/widgets.dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  String authToken;
  String userId;
  ProductsProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  ProductsRepository get repository {
    return ProductsRepository(this.authToken);
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Future<void> fetchProducts() async {
    _items = await repository.fetchProducts(userId);
    notifyListeners();
  }

  Future<void> fetchProductsByUser() async {
    _items = await repository.fetchProducts(userId, true);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final id = await repository.addProduct(product, this.userId);
    _items.add(product.copyWith(id: id));
    notifyListeners();
  }

  Future<void> editProduct(Product newData) async {
    await repository.updateProduct(newData);
    var index = _items.indexWhere((p) => p.id == newData.id);
    if (index >= 0) {
      _items[index] = newData;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String productId) async {
    final index = _items.indexWhere((item) => item.id == productId);
    var existingItem = _items[index];
    _items.removeAt(index);
    notifyListeners();
    try {
      await repository.deleteProduct(productId);
      existingItem = null;
    } catch (error) {
      _items.insert(index, existingItem);
      notifyListeners();
      throw error;
    }
  }

  Product findById(String productId) {
    return _items.firstWhere((p) => p.id == productId);
  }
}
