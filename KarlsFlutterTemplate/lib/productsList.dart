import 'package:flutter/material.dart';
import 'package:kft/productDetails.dart';
import 'package:kft/productEditor.dart';
import 'package:kft/webApiClient.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;

  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() {
    setState(() {
      futureProducts = getAllProductsAsync();
    });
  }

  void goToProductEditor() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductEditor(onUpdate: loadProducts)),
    );
  }

  void goToProductDetails(Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetails(
                productId: product.id,
                onDelete: loadProducts,
                onUpdate: loadProducts)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Management'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Text("Products")),
              Tab(icon: Text("Billing")),
              Tab(icon: Text("Information")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: goToProductEditor,
                          child: Text("Add"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<Product>>(
                    future: futureProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                "Error: ${snapshot.error} Is the server running?"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Text("No products available."),
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final product = snapshot.data![index];
                            return Dismissible(
                              key: Key(product.name),
                              onDismissed: (direction) {
                                deleteProductAsync(product);
                              },
                              child: Card(
                                  child: ListTile(
                                title: Text(product.name),
                                subtitle: Text(
                                    "€ ${(product.price / 100).toStringAsFixed(2)}",
                                    style: TextStyle(color: Colors.green)),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  goToProductDetails(product);
                                },
                              )),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
