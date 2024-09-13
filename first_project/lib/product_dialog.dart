import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProductDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductAdded;

  ProductDialog({required this.onProductAdded});

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String _productData = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Product Name'),
            onChanged: (value) => _updateProductData(),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            onChanged: (value) => _updateProductData(),
          ),
          TextField(
            controller: quantityController,
            decoration: InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
            onChanged: (value) => _updateProductData(),
          ),
          TextField(
            controller: priceController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => _updateProductData(),
          ),
          SizedBox(height: 20),
          _productData.isNotEmpty
              ? QrImageView(
                  data: _productData,
                  version: QrVersions.auto,
                  size: 200.0,
                )
              : Container(),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final product = {
              'name': nameController.text,
              'description': descriptionController.text,
              'quantity': int.tryParse(quantityController.text) ?? 0,
              'price': double.tryParse(priceController.text) ?? 0.0,
            };
            widget.onProductAdded(product);
            Navigator.pop(context);
          },
          child: Text('Done'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _updateProductData() {
    setState(() {
      _productData = 'Name: ${nameController.text}\n'
                     'Description: ${descriptionController.text}\n'
                     'Quantity: ${quantityController.text}\n'
                     'Price: ${priceController.text}';
    });
  }
}
