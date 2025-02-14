import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kft/productDetails.dart';
import 'package:kft/webApiClient.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    loadProducts();

    // Add listeners to enable/disable the button when inputs change
    nameController.addListener(validateInput);
    priceController.addListener(validateInput);
    descriptionController.addListener(validateInput);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  /// Reloads products
  void loadProducts() {
    setState(() {
      futureProducts = getAllProductsAsync();
    });
  }

  /// Validates if all fields have data to enable the button
  void validateInput() {
    setState(() {
      isButtonDisabled = nameController.text.isEmpty ||
          priceController.text.isEmpty ||
          descriptionController.text.isEmpty;
    });
  }

  /// Adds a product and updates the UI
  Future<void> addProduct() async {
    String name = nameController.text;
    double price = double.tryParse(priceController.text) ?? 0.0;
    String description = descriptionController.text;

    var product = Product(id: "null", name: name, description: description, price: price);
    await postProductAsync(product);
    loadProducts();

    // Clear the fields after adding a product
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Padding to all input elements
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Price in a Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Name"),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter name...',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Price (€)"),
                          TextField(
                            controller: priceController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter price...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Description Field
                const Text("Description"),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter description...',
                  ),
                ),
                const SizedBox(height: 10),
                // Add Product Button                
               Align(
                  alignment: Alignment.centerRight,
                  child: Visibility(
                    visible: !isButtonDisabled, // Hides when true
                    child: FloatingActionButton.extended(
                      onPressed: addProduct,
                      label: const Text("+ Add Product"),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
          // Product List without Padding
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) 
                {
                  return const Center(child: CircularProgressIndicator());
                } 
                else if (snapshot.hasError) 
                {
                  return Center(child: Text("Error: ${snapshot.error} - Is the server running?"));
                } 
                else if (!snapshot.hasData || snapshot.data!.isEmpty) 
                {
                  return const Center(child: Text("No products available"));
                }
                 else
                {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text("€ ${product.price.toStringAsFixed(2)}"),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  product: product,
                                  onDelete: loadProducts, // Pass function to refresh after delete
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
