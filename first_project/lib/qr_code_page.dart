import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

class QRCodeScreen extends StatelessWidget {
  final String itemId;
  final double price;
  final String productName;

  const QRCodeScreen({super.key, required this.itemId, required this.price, required this.productName});

  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotController = ScreenshotController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item QR Code'),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Screenshot(
                controller: screenshotController,
                child: Column(
                  children: [
                    QrImageView(
                      data: itemId,
                      version: QrVersions.auto,
                      size: 200.0,
                      gapless: false,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Product ID: $itemId',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      'Product Name: $productName',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      'Price: \$${price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final Uint8List? image = await screenshotController.capture();

                    if (image != null) {
                      final pdf = pw.Document();
                      final pdfImage = pw.MemoryImage(image);

                      pdf.addPage(
                        pw.Page(
                          build: (pw.Context context) {
                            return pw.Column(
                              children: [
                                pw.Center(
                                  child: pw.Image(pdfImage, height: 200, width: 200),
                                ),
                                pw.SizedBox(height: 20),
                                pw.Text('Product ID: $itemId', style: pw.TextStyle(fontSize: 18)),
                                pw.Text('Product Name: $productName', style: pw.TextStyle(fontSize: 18)),
                                pw.Text('Price: \$${price.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                              ],
                            );
                          },
                        ),
                      );

                      await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async => pdf.save(),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to capture QR code')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error printing QR code: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepOrangeAccent,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.print, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Print QR',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

