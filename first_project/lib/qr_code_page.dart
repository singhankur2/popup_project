import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class QRCodeScreen extends StatelessWidget {
  final String itemId;
  final double price;

  const QRCodeScreen({super.key, required this.itemId, required this.price});

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
        decoration: BoxDecoration(
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
                child: QrImageView(
                  data: itemId,
                  version: QrVersions.auto,
                  size: 200.0,
                  gapless: false,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Capture screenshot of the QR code
                    final Uint8List? image = await screenshotController.capture();

                    if (image != null) {
                      // Generate PDF
                      final pdf = pw.Document();
                      final pdfImage = pw.MemoryImage(image);

                      pdf.addPage(
                        pw.Page(
                          build: (pw.Context context) {
                            return pw.Center(
                              child: pw.Image(pdfImage),
                            );
                          },
                        ),
                      );

                      // Save the PDF to the device
                      final Directory directory = await getTemporaryDirectory();
                      final String pdfPath = '${directory.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.pdf';
                      final File pdfFile = File(pdfPath);
                      await pdfFile.writeAsBytes(await pdf.save());

                      // Show a confirmation message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('QR code saved as PDF. Path: $pdfPath')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to capture QR code')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving QR code: $e')),
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
                  padding: EdgeInsets.all(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Save QR as PDF',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Price: \$${price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
