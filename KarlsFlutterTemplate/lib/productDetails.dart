import 'package:flutter/material.dart';
import 'webApiClient.dart';

class ProductDetails extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductDetails({super.key, required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    Future<void> deleteProduct(Product product) async {
      await deleteProductAsync(product);
      onDelete();
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Product details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(product.description, style: const TextStyle(fontSize: 15)),
            Text("€ ${product.price.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20, color: Colors.green)),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton.extended(
                onPressed: () => deleteProduct(product),
                label: const Text("Delete Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
