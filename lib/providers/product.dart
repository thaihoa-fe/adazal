import 'package:flutter/foundation.dart';
import '../repositories/products.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    this.description,
    this.price,
    this.imageUrl,
    bool isFavourite,
  }) : this.isFavourite = isFavourite ?? false;

  Product.empty()
      : this.id = null,
        this.description = null,
        this.title = null,
        this.imageUrl = null,
        this.price = 0;

  Product.fromMap(String id, Map map)
      : this(
          id: id,
          description: map['description'],
          imageUrl: map['imageUrl'],
          price: map['price'] as double,
          title: map['title'],
          isFavourite: map['isFavourite'],
        );

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
  }) {
    var product = Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
    product.isFavourite = this.isFavourite ?? false;
    return product;
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': this.id,
      'description': this.description,
      'title': this.title,
      'price': this.price,
      'imageUrl': this.imageUrl,
      'isFavourite': this.isFavourite,
    };
  }

  Future<void> toggleFavourite(String authToken, String userId) async {
    this.isFavourite = !this.isFavourite;
    notifyListeners();
    try {
      await ProductsRepository(authToken).toggleFavourite(this, userId);
    } catch (error) {
      this.isFavourite = !this.isFavourite;
      notifyListeners();
    }
  }
}
