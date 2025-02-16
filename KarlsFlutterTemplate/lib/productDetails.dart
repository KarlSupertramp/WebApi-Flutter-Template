import 'package:flutter/material.dart';
import 'webApiClient.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const ProductDetails(
      {super.key, required this.productId, required this.onDelete, required this.onUpdate});

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  late Future<Product> productFuture;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    productFuture = getProductAsync(widget.productId);
  }

  void startEditing(Product product) {
    setState(() {
      isEditing = true;
      nameController = TextEditingController(text: product.name);
      descriptionController = TextEditingController(text: product.description);
      priceController =
          TextEditingController(text: (product.price / 100).toStringAsFixed(2));
    });
  }

  Future<void> updateProduct() async {
    final updatedProduct = Product(
      id: widget.productId,
      name: nameController.text,
      description: descriptionController.text,
      price: (double.tryParse(priceController.text)! * 100).round(),
    );

    await updateProductAsync(updatedProduct).whenComplete(() {
      widget.onUpdate();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product updated successfully")),
      );
    }

    setState(() {
      isEditing = false;
      productFuture = Future.value(updatedProduct);
    });
  }

  Future<void> deleteProduct() async {
    await deleteProductAsync(await productFuture).whenComplete(() {
      widget.onDelete();
    });

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Product deleted")));
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
                  child: isEditing
                      ? TextField(
                          controller: nameController,
                          decoration:
                              const InputDecoration(labelText: "Product Name"),
                        )
                      : Text(product.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/placeholder.jpg',
                  height: 250,
                ),
                isEditing
                    ? TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: "Description"),
                        maxLines: 3,
                      )
                    : Text(product.description,
                        style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: isEditing
                      ? TextField(
                          controller: priceController,
                          decoration:
                              const InputDecoration(labelText: "Price (€)"),
                          keyboardType: TextInputType.number,
                        )
                      : Text("€ ${(product.price / 100).toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.green)),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: isEditing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() => isEditing = false);
                              },
                              child: const Text("Cancel"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: updateProduct,
                              child: const Text("Save"),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: deleteProduct,
                              style: ElevatedButton.styleFrom(),
                              child: const Text("Delete"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => startEditing(product),
                              child: const Text("Edit"),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
