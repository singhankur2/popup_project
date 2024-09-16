import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateItemsPage extends StatefulWidget {
  @override
  _UpdateItemsPageState createState() => _UpdateItemsPageState();
}

class _UpdateItemsPageState extends State<UpdateItemsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productIdController = TextEditingController(text: 'gvh1QQKWbd7pJocWhNaW');
  final TextEditingController _productNameController = TextEditingController(text: 'Product B');
  final TextEditingController _descriptionController = TextEditingController(text: 'abcdevfhij1234');
  final TextEditingController _priceController = TextEditingController(text: '150');
  final TextEditingController _quantityController = TextEditingController(text: '5');
  final TextEditingController _supplierNameController = TextEditingController(text: 'Saler B');

  // Method to update product information in Firestore based on Product ID
  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      final productId = _productIdController.text;

      FirebaseFirestore.instance.collection('products')
        .doc(productId)
        .update({
          'Description': _descriptionController.text,
          'Price': double.tryParse(_priceController.text) ?? 0.0,
          'Quantity': int.tryParse(_quantityController.text) ?? 0,
          'Supplier_name': _supplierNameController.text,
          'Product_name': _productNameController.text,
        }).then((_) {
          _showUpdateDialog();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update product: $error')));
        });
    }
  }

  // Method to show a dialog after successful update
  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepOrangeAccent[100], // Subtle color matching the app theme
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30), // Attractive success icon
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Update Successful',
                  style: TextStyle(color: Colors.deepOrangeAccent[800], fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            'Product information has been updated successfully!',
            style: TextStyle(color: Colors.deepOrangeAccent[700]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the update page
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.deepOrangeAccent[800]), // Button text color
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Item'),
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Product ID Field
              _buildTextField(
                controller: _productIdController,
                label: 'Product ID',
                icon: Icons.card_membership,
                readOnly: true,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2), // Adjusted color
              ),
              SizedBox(height: 10),
              // Product Name Field
              _buildTextField(
                controller: _productNameController,
                label: 'Product Name',
                icon: Icons.production_quantity_limits,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2), // Adjusted color
              ),
              SizedBox(height: 10),
              // Description Field
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2), // Adjusted color
              ),
              SizedBox(height: 10),
              // Price Field
              _buildTextField(
                controller: _priceController,
                label: 'Price',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2), // Adjusted color
              ),
              SizedBox(height: 10),
              // Quantity Field
              _buildTextField(
                controller: _quantityController,
                label: 'Quantity',
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2), // Adjusted color
              ),
              SizedBox(height: 10),
              // Supplier Name Field
              _buildTextField(
                controller: _supplierNameController,
                label: 'Supplier Name',
                icon: Icons.business,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2), // Adjusted color
              ),
              SizedBox(height: 20),
              // Update Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _updateProduct,
                  icon: Icon(Icons.update, size: 24),
                  label: Text('Update Product', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent, // Button background color
                    foregroundColor: Colors.white, // Text and icon color
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    required Color fillColor,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepOrangeAccent),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
        ),
        fillColor: fillColor,
        filled: true,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
