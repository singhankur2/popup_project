import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'product_dialog.dart'; // Assuming this file exists
import 'qr_code_page.dart'; // Assuming this file exists

class RegisterItemsPage extends StatefulWidget {
  @override
  _RegisterItemsPageState createState() => _RegisterItemsPageState();
}

class _RegisterItemsPageState extends State<RegisterItemsPage> {
  final TextEditingController _nameController = TextEditingController(text: 'Product A');
  final TextEditingController _descriptionController = TextEditingController(text: 'abcd1234');
  final TextEditingController _priceController = TextEditingController(text: '100');
  final TextEditingController _quantityController = TextEditingController(text: '2');
  final TextEditingController _supplierController = TextEditingController(text: 'Saler A');
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> _addProduct() async {
    final productName = _nameController.text;
    final description = _descriptionController.text;
    final price = _priceController.text;
    final quantity = _quantityController.text;
    final supplier = _supplierController.text;

    if (productName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill the Product Name')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill the Description')),
      );
      return;
    }

    if (price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill the Price')),
      );
      return;
    }

    if (quantity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill the Quantity')),
      );
      return;
    }

    if (supplier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill the Supplier Name')),
      );
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance.collection('products').doc();
      final productId = docRef.id;

      await docRef.set({
        'Product_name': productName,
        'Description': description,
        'Price': price,
        'Quantity': quantity,
        'Supplier_name': supplier,
        'product_id': productId,
        // 'imageUrl': _image != null ? _image!.path : '', // Add image path if available
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added and QR code generated!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodeScreen(
            price: double.tryParse(price) ?? 0.0,
            itemId: productId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Items'),
        backgroundColor: Colors.orangeAccent[700],
        elevation: 8.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                        color: Colors.grey[200],
                        height: 150,
                        width: 150,
                        child: Icon(Icons.add_a_photo, size: 50, color: Colors.deepOrangeAccent),
                      )
                    : Image.file(File(_image!.path), height: 150, width: 150),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(_nameController, 'Product Name', Icons.production_quantity_limits),
            SizedBox(height: 10),
            _buildTextField(_descriptionController, 'Description', Icons.description),
            SizedBox(height: 10),
            _buildTextField(_priceController, 'Price', Icons.attach_money, keyboardType: TextInputType.number),
            SizedBox(height: 10),
            _buildTextField(_quantityController, 'Quantity', Icons.numbers, keyboardType: TextInputType.number),
            SizedBox(height: 10),
            _buildTextField(_supplierController, 'Supplier Name', Icons.business),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepOrangeAccent,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_box, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Add Product',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.deepOrangeAccent),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
