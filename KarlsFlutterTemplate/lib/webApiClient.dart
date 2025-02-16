import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price});

  // Factory constructor to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
    );
  }

  String toJson()
  {
      return json.encode({
        "id": id,
        "name": name,
        "description": description,
        "price": price,
      }).toString();
  }
}

Future<String> getServerUrl() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('server_url') ?? "";  
}

Future<List<Product>> getAllProductsAsync() async {
  String baseUrl = await getServerUrl();
  final String header = "$baseUrl/api/Products";

  try {
    final response = await http.get(Uri.parse(header));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception(
          "Failed to load products, Status Code: ${response.statusCode}");
    }
  } catch (error) {
    throw Exception("Error fetching products: $error");
  }
}

Future<void> deleteProductAsync(Product product) async {
  String baseUrl = await getServerUrl();
  final String url = "$baseUrl/api/Products/${product.id}";

  try {
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 204 || response.statusCode == 200) {
      // -> YAY!
    } else {
      throw Exception(
          "Failed to delete product, Status Code: ${response.statusCode}");
    }
  } catch (error) {
    throw Exception("Error deleting product: $error");
  }
}

Future<Product> getProductAsync(String id) async {  
  String baseUrl = await getServerUrl();
  final String url = "$baseUrl/api/Products/$id";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body.isNotEmpty) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception("Product not found or no content available.");
      }
    } else {
      throw Exception(
          "Failed to fetch product, Status Code: ${response.statusCode}");
    }
  } catch (error) {
    throw Exception("Error fetching product: $error");
  }
}

Future<void> addProductAsync(Product product) async {
  String baseUrl = await getServerUrl();
  final String url = "$baseUrl/api/Products";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: product.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Successfully added product
    } else {
      throw Exception(
          "Failed to add product, Status Code: ${response.statusCode}");
    }
  } catch (error) {
    throw Exception("Error adding product: $error");
  }
}

Future<void> updateProductAsync(Product product) async {
  String baseUrl = await getServerUrl();
  final String url = "$baseUrl/api/Products/${product.id}";

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json'
      },
      body: product.toJson(),
    );

    if (response.statusCode == 204) {
      // Successfully updated product (No Content response)
    } else if (response.statusCode == 404) {
      throw Exception("Product not found");
    } else {
      throw Exception(
          "Failed to update product, Status Code: ${response.statusCode}");
    }
  } catch (error) {
    throw Exception("Error updating product: $error");
  }
}


