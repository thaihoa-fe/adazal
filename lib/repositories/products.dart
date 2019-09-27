import 'package:adazal_app/models/http_exeption.dart';
import 'package:adazal_app/providers/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsRepository {
  String authToken;
  ProductsRepository(this.authToken);

  Future<String> addProduct(Product product, String userId) async {
    final url =
        'https://adazal-8d5b6.firebaseio.com/products.json?auth=$authToken';

    Map productMap = product.toJSON();
    productMap['creatorId'] = userId;

    final response = await http.post(
      url,
      body: json.encode(productMap),
    );
    final body = json.decode(response.body);
    return body['name'];
  }

  Future<List<Product>> fetchProducts(String userId,
      [bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://adazal-8d5b6.firebaseio.com/products.json?auth=$authToken$filterString';
    final response = await http.get(url);

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw HttpExeption(body["error"]);
    }
    final userFavourite = await fetchUserFavourite(userId);
    var items = <Product>[];
    body.forEach((id, data) {
      final product = Product.fromMap(id, data);
      product.isFavourite =
          userFavourite == null ? false : userFavourite[id] ?? false;
      items.add(product);
    });
    return items;
  }

  Future<Map<String, dynamic>> fetchUserFavourite(String userId) async {
    final url =
        'https://adazal-8d5b6.firebaseio.com/usersFavourite/${userId}.json?auth=$authToken';

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HttpExeption('Error when deleting product');
    }
    final body = json.decode(response.body);
    return body;
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        'https://adazal-8d5b6.firebaseio.com/products/$productId.json?auth=$authToken';
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw HttpExeption('Error when deleting product');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final url =
        'https://adazal-8d5b6.firebaseio.com/products/${product.id}.json?auth=$authToken';

    final response = await http.patch(url, body: json.encode(product.toJSON()));
    if (response.statusCode != 200) {
      throw HttpExeption('Error when deleting product');
    }
    final body = json.decode(response.body) as Map;

    return Product.fromMap(body['id'], body);
  }

  Future<bool> toggleFavourite(Product product, String userId) async {
    final url =
        'https://adazal-8d5b6.firebaseio.com/usersFavourite/${userId}/${product.id}.json?auth=$authToken';

    final response = await http.put(url,
        body: json.encode(
          product.isFavourite,
        ));
    if (response.statusCode != 200) {
      throw HttpExeption('Error when deleting product');
    }
    final body = json.decode(response.body);

    return body;
  }
}
