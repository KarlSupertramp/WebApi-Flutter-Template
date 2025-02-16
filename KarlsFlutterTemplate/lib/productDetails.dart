import 'package:flutter/material.dart';
import 'webApiClient.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  final VoidCallback onDelete;

  const ProductDetails(
      {super.key, required this.productId, required this.onDelete});

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  late Future<Product> productFuture;

  @override
  void initState() {
    super.initState();
    productFuture = getProductAsync(widget.productId);
  }

  Future<void> deleteProduct() async {
    await deleteProductAsync(await productFuture).whenComplete(() {
      widget.onDelete();      
    });

    if (mounted) {
       ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Product deleted")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product details")),
      body: FutureBuilder<Product>(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No product found"));
          }

          final product = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(product.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/placeholder.jpg',
                  height: 250,
                ),
                Text(product.description, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("€ ${product.price.toStringAsFixed(2)}",
                      style:
                          const TextStyle(fontSize: 20, color: Colors.green)),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: deleteProduct,
                    child: const Text("Delete"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
