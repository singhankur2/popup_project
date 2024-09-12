import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String productName;
  final String description;
  final String price;
  final String quantity;
  final String supplier;

  QRCodeScreen({
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
    required this.supplier,
  });

  @override
  Widget build(BuildContext context) {
    final productDetails = '''
Name: $productName
Description: $description
Price: $price
Quantity: $quantity
Supplier: $supplier
    ''';

    return Scaffold(
      appBar: AppBar(
        title: Text('Product QR Code'),
      ),
      body: Center(
        child: QrImageView(
          data: productDetails,
          version: QrVersions.auto,
          size: 200.0,
          gapless: false,
        ),
      ),
    );
  }
}
