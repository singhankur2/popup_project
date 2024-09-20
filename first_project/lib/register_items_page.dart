import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'qr_code_page.dart';

class RegisterItemsPage extends StatefulWidget {
  const RegisterItemsPage({super.key});

  @override
  _RegisterItemsPageState createState() => _RegisterItemsPageState();
}

class _RegisterItemsPageState extends State<RegisterItemsPage> {
  final TextEditingController _nameController = TextEditingController(text: 'Product A');
  final TextEditingController _descriptionController = TextEditingController(text: 'abcd1234');
  final TextEditingController _priceController = TextEditingController(text: '100');
  final TextEditingController _quantityController = TextEditingController(text: '2');
  final TextEditingController _supplierController = TextEditingController(text: 'Saler A');
  final TextEditingController _commissionController = TextEditingController(text: '10');
  List<XFile>? _images = [];

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    if (source == ImageSource.gallery) {
      final List<XFile>? selectedImages = await picker.pickMultiImage();
      if (selectedImages != null) {
        setState(() {
          _images = selectedImages;
        });
      }
    } else {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _images = [image];
        });
      }
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<String>> _uploadImages(List<XFile> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".png";
        final ref = FirebaseStorage.instance.ref().child('product_images/$fileName');
        await ref.putFile(File(image.path));
        String downloadURL = await ref.getDownloadURL();
        imageUrls.add(downloadURL);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    return imageUrls;
  }

  Future<void> _addProduct() async {
    final productName = _nameController.text;
    final description = _descriptionController.text;
    final price = _priceController.text;
    final quantity = _quantityController.text;
    final supplier = _supplierController.text;
    final commissionPercent = _commissionController.text;

    if (productName.isEmpty || description.isEmpty || price.isEmpty || quantity.isEmpty || supplier.isEmpty || commissionPercent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      List<String> imageUrls = [];
      if (_images != null && _images!.isNotEmpty) {
        imageUrls = await _uploadImages(_images!);
      }

      final docRef = FirebaseFirestore.instance.collection('products').doc();
      final productId = docRef.id;

      final priceValue = double.tryParse(price) ?? 0.0;
      final commissionValue = (double.tryParse(commissionPercent) ?? 0.0) / 100 * priceValue;

      await docRef.set({
        'Product_name': productName,
        'Description': description,
        'Price': priceValue,
        'Quantity': quantity,
        'Supplier_name': supplier,
        'Commission': commissionValue,
        'product_id': productId,
        'Product_images': imageUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added and QR code generated!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodeScreen(
            price: priceValue,
            itemId: productId,
            productName: productName, // Pass product name
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
        title: const Text('Register Items'),
        backgroundColor: Colors.orangeAccent[700],
        elevation: 8.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
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
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showImageSourceOptions,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.deepOrangeAccent.withOpacity(0.5),
                      backgroundImage: _images != null && _images!.isNotEmpty
                          ? FileImage(File(_images!.first.path))
                          : null,
                      child: _images == null || _images!.isEmpty
                          ? const Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap to select image',
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, 'Product Name', Icons.production_quantity_limits),
            const SizedBox(height: 10),
            _buildTextField(_descriptionController, 'Description', Icons.description),
            const SizedBox(height: 10),
            _buildTextField(_priceController, 'Price', Icons.attach_money, keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _buildTextField(_quantityController, 'Quantity', Icons.numbers, keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _buildTextField(_commissionController, 'Commission (%)', Icons.percent, keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _buildTextField(_supplierController, 'Supplier Name', Icons.business),
            const SizedBox(height: 20),

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
                  padding: const EdgeInsets.all(20),
                ),
                child: const Row(
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
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}

