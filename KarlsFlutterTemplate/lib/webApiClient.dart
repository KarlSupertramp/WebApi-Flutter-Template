import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class Product {
  final String id;
  final String name;
  final String description;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? UniqueKey().toString(),
      name: json['Name'] ?? '',
      description: json['Description'] ?? '',
      price: json['Price'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
      };

  String toJson() => json.encode(toMap());
}

// In-memory data list
List<Product> _products = [];

Future<List<Product>> getAllProductsAsync() async {
  if (_products.isNotEmpty) return _products;

  final jsonString = await rootBundle.loadString('assets/data.json');
  final List<dynamic> jsonList = json.decode(jsonString);

  _products = jsonList.map((item) => Product.fromJson(item)).toList();
  return _products;
}

Future<Product> getProductAsync(String id) async {
  await getAllProductsAsync();
  final product = _products.firstWhere((p) => p.id == id, orElse: () => throw Exception("Product not found"));
  return product;
}

Future<void> deleteProductAsync(Product product) async {
  _products.removeWhere((p) => p.id == product.id);
}

Future<void> addProductAsync(Product product) async {
  _products.add(product);
}

Future<void> updateProductAsync(Product product) async {
  final index = _products.indexWhere((p) => p.id == product.id);
  if (index == -1) throw Exception("Product not found");
  _products[index] = product;
}
