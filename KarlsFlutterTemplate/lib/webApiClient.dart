import 'dart:convert';
import 'package:http/http.dart' as http;

class Product 
{
  final String id;
  final String name;
  final String description;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description, 
    required this.price
  });

  // Factory constructor to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) 
  {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

// Replace server IP
final String baseUrl = "http://192.168.178.43:5000/api";

Future<List<Product>> getAllProductsAsync() async 
{
  final String header = "$baseUrl/Products";
  
  try 
  {
    final response = await http.get(Uri.parse(header));

    if (response.statusCode == 200) 
    {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } 
    else
    {
      throw Exception("Failed to load products, Status Code: ${response.statusCode}");
    }
  } 
  catch (error) 
  {
    throw Exception("Error fetching products: $error");
  }
}

Future<void> deleteProductAsync(Product product) async 
{
  final String url = "$baseUrl/Products/${product.id}";

  try 
  {
    final response = await http.delete(Uri.parse(url), headers: 
    {
      "Connection": "close"  // Helps prevent redirects
    });

    if (response.statusCode == 204 || response.statusCode == 200) 
    {
      // -> YAY!
    } 
    else 
    {
      throw Exception("Failed to delete product, Status Code: ${response.statusCode}");
    }
  } 
  catch (error) 
  {
    throw Exception("Error deleting product: $error");
  }
}

Future<void> postProductAsync(Product product) async 
{
  final String url = "$baseUrl/Products";

  try 
  {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "id": product.id,
        "name": product.name,
        "description": product.description,
        "price": product.price,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) 
    {
      // Successfully added product
    } 
    else 
    {
      throw Exception("Failed to add product, Status Code: ${response.statusCode}");
    }
  } 
  catch (error) 
  {
    throw Exception("Error adding product: $error");
  }
}