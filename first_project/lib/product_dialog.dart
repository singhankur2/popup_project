import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Import QR Code Scanner
import 'product_service.dart';

class ProductDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductAdded;

  const ProductDialog({super.key, required this.onProductAdded});

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final TextEditingController _productIdController =
      TextEditingController(text: ''); // Product ID will come from QR code
  final TextEditingController _quantityController =
      TextEditingController(text: '1'); // Default quantity is 1
  final ProductService _productService = ProductService();
  int _quantity = 1;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // QR scanner key
  QRViewController? _qrController;
  String? scannedCode;

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }

  // Function to handle QR code scanning
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedCode = scanData.code; // Capture the scanned QR code
        _productIdController.text = scannedCode!; // Populate Product ID field
      });
      controller.pauseCamera(); // Pause the camera after scanning
      Navigator.pop(context); // Close the scanner
    });
  }

  // Function to show the QR code scanner in a full-screen modal
  void _scanQRCode() {
    showDialog(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Scan QR Code')),
        body: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Text(
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
              labelStyle: const TextStyle(color: Colors.deepOrangeAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.qr_code, color: Colors.deepOrangeAccent),
                onPressed: _scanQRCode, // Open QR code scanner on button press
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: const TextStyle(color: Colors.deepOrangeAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: const Icon(Icons.confirmation_number, color: Colors.deepOrangeAccent),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.pink),
                onPressed: () {
                  setState(() {
                    if (_quantity > 1) _quantity--;
                    _quantityController.text = _quantity.toString();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.pink),
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
          child: const Text(
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
                const SnackBar(
                  content: Text('Product not found!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text(
            'Done',
            style: TextStyle(color: Colors.pink),
          ),
        ),
      ],
    );
  }
}


// 333




