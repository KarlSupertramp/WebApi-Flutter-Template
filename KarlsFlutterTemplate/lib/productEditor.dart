import 'package:flutter/material.dart';
import 'package:kft/webApiClient.dart';

class ProductEditor extends StatefulWidget {
  final VoidCallback onUpdate;

  const ProductEditor({super.key, required this.onUpdate});

  @override
  ProductEditorState createState() => ProductEditorState();
}

class ProductEditorState extends State<ProductEditor> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();

    // Add listeners to update button state
    nameController.addListener(updateButtonState);
    priceController.addListener(updateButtonState);
    descriptionController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = nameController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.removeListener(updateButtonState);
    priceController.removeListener(updateButtonState);
    descriptionController.removeListener(updateButtonState);

    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void addProduct() async {
    try {
      Product newProduct = Product(
        id: "null", // Set to null instead of empty string
        name: nameController.text,
        description: descriptionController.text,
        price: (double.tryParse(priceController.text)! * 100).round(),
      );

      await addProductAsync(newProduct);
      widget.onUpdate(); // Call the update function

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product added')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter product name' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || double.tryParse(value) == null)
                    ? 'Enter valid price'
                    : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description')
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? addProduct : null,
                  child: Text("Add"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
