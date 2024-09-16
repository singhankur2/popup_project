import 'package:flutter/material.dart';
import 'product_service.dart';

class ProductDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductAdded;

  ProductDialog({required this.onProductAdded});

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final TextEditingController _productIdController =
      TextEditingController(text: 'yVPqSci5eIFrev2YHYxt'); // Default Product ID
  final TextEditingController _quantityController =
      TextEditingController(text: '1'); // Default quantity is 1
  final ProductService _productService = ProductService();
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: Text(
        'Add Product',
        style: TextStyle(color: Colors.deepOrangeAccent),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _productIdController,
            decoration: InputDecoration(
              labelText: 'Product ID',
              labelStyle: TextStyle(color: Colors.deepOrangeAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              prefixIcon: Icon(Icons.qr_code, color: Colors.deepOrangeAccent),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.confirmation_number, color: Colors.deepOrangeAccent),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove, color: Colors.pink),
                onPressed: () {
                  setState(() {
                    if (_quantity > 1) _quantity--;
                    _quantityController.text = _quantity.toString();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.pink),
                onPressed: () {
                  setState(() {
                    _quantity++;
                    _quantityController.text = _quantity.toString();
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.pink),
          ),
        ),
        TextButton(
          onPressed: () async {
            final productId = _productIdController.text;
            final quantity = int.tryParse(_quantityController.text) ?? 1;

            // Fetch product data
            final productData = await _productService.fetchProductDataFromFirestore(productId);
            if (productData != null) {
              final priceString = productData['Price']?.toString() ?? '0.0';
              final price = double.tryParse(priceString) ?? 0.0; // Convert price to double
              final productDetails = {
                'Sold_product_id': productId,
                'Product_name': productData['Product_name'],
                'Sold_quantity': quantity,
                'Price': price,
                'Total_sale_amount': price * quantity,
              };

              widget.onProductAdded(productDetails);
              Navigator.of(context).pop();
            } else {
              // Show error if product is not found
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product not found!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text(
            'Done',
            style: TextStyle(color: Colors.pink),
          ),
        ),
      ],
    );
  }
}
