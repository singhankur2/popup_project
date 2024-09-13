import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore package
import './qr_code_page.dart'; // Import the QR code screen

class RegisterItemsPage extends StatefulWidget {
  @override
  _RegisterItemsPageState createState() => _RegisterItemsPageState();
}

class _RegisterItemsPageState extends State<RegisterItemsPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _supplierController = TextEditingController();
  XFile? _image;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _addProduct() async {
    // Gather product details
    final productName = _nameController.text;
    final description = _descriptionController.text;
    final price = _priceController.text;
    final quantity = _quantityController.text;
    final supplier = _supplierController.text;

    // Check if each field is filled and show corresponding message
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
      // Generate a new document ID
      final docRef = FirebaseFirestore.instance.collection('products').doc();
      final productId = docRef.id;

      // Save product to Firestore with the generated product ID
      await docRef.set({
        'Product_name': productName,
        'Description': description,
        'Price': price,
        'Quantity': quantity,
        'Supplier_name': supplier,
        'product_id': productId,
        // 'imageUrl': _image != null ? _image!.path : '', // Add image path if available
      });

      // Show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added and QR code generated!')),
      );

      // Navigate to QR Code Screen after saving to Firestore
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodeScreen(
            productName: productName,
            description: description,
            price: price,
            quantity: quantity,
            supplier: supplier,
            itemId: productId, // Pass the product ID here
          ),
        ),
      );
    } catch (e) {
      // Show error message
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
      ),
      body: Padding(
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
                        child: Icon(Icons.add_a_photo, size: 50),
                      )
                    : Image.file(File(_image!.path), height: 150, width: 150),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _supplierController,
              decoration: InputDecoration(labelText: 'Supplier Name'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addProduct,
                child: Text('Add Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
