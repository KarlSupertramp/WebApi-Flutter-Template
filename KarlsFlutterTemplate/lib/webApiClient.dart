import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

///------------- Product model ---------------------------

class Product {
  final String id;
  final String name;
  final String description;
  final int price;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
        price: (json['price'] ?? 0) is int
            ? json['price']
            : int.tryParse(json['price']?.toString() ?? '') ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
      };
}

///--------------------- API client --------------------------

class ProductApi {
  static final ProductApi _instance = ProductApi._internal();
  factory ProductApi() => _instance;
  ProductApi._internal();

  final http.Client _client = http.Client();
  String _baseUrl = "";

  Map<String, String> get _headers => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<void> _init() async {
    if (_baseUrl.isNotEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('server_url') ?? 'http://localhost:5000';
    _baseUrl = _normalizeBaseUrl(savedUrl);
  }

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  // -------------------- CRUD-API --------------------

  Future<List<Product>> getAllProductsAsync() async {
    await _init();
    final res = await _client.get(_uri('/api/products'), headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('Failed to load products: ${res.statusCode} ${res.body}');
    }
    final data = json.decode(res.body);
    if (data is! List) throw Exception('Unexpected response for products list.');
    return compute(_parseProducts, data);
  }

  Future<Product> getProductAsync(String id) async {
    await _init();
    final res = await _client.get(_uri('/api/products/$id'), headers: _headers);
    if (res.statusCode == 404) throw Exception('Product not found');
    if (res.statusCode != 200) {
      throw Exception('Failed to load product: ${res.statusCode} ${res.body}');
    }
    return Product.fromJson(json.decode(res.body));
  }

  Future<Product> addProductAsync(Product product) async {
    await _init();
    final body = json.encode({
      "name": product.name,
      "description": product.description,
      "price": product.price,
    });

    final res = await _client.post(
      _uri('/api/products'),
      headers: _headers,
      body: body,
    );

    if (res.statusCode != 201) {
      throw Exception('Failed to create product: ${res.statusCode} ${res.body}');
    }

    return Product.fromJson(json.decode(res.body));
  }

  Future<void> updateProductAsync(Product product) async {
    await _init();
    final body = json.encode({
      "id": product.id,
      "name": product.name,
      "description": product.description,
      "price": product.price,
    });

    final res = await _client.put(
      _uri('/api/products/${product.id}'),
      headers: _headers,
      body: body,
    );

    if (res.statusCode == 404) throw Exception('Product not found');
    if (res.statusCode != 204) {
      throw Exception('Failed to update product: ${res.statusCode} ${res.body}');
    }
  }

  Future<void> deleteProductAsync(String id) async {
    await _init();
    final res =
        await _client.delete(_uri('/api/products/$id'), headers: _headers);
    if (res.statusCode == 404) throw Exception('Product not found');
    if (res.statusCode != 204) {
      throw Exception('Failed to delete product: ${res.statusCode} ${res.body}');
    }
  }

  void close() => _client.close();

  // -------------------- Helpers --------------------

  static String _normalizeBaseUrl(String raw) {
    var url = raw.trim();
    if (url.isEmpty) {
      throw ArgumentError('Base URL is empty. Set `server_url` in preferences.');
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'http://$url';
    }
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }
}

List<Product> _parseProducts(List<dynamic> jsonList) =>
    jsonList.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
