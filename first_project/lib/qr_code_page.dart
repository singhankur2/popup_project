import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class QRCodeScreen extends StatelessWidget {
  final String itemId;
  final double price;

  const QRCodeScreen({super.key, required this.itemId, required this.price});

  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotController = ScreenshotController();

    return Scaffold(
      appBar: AppBar(title: const Text('Item QR Code')),
      body: Center(
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
                  // Capture screenshot
                  final Uint8List? image = await screenshotController.capture();

                  if (image != null) {
                    // Get temporary directory
                    final directory = await getTemporaryDirectory();
                    final path = '${directory.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';

                    // Save the image to the temporary directory
                    final file = File(path);
                    await file.writeAsBytes(image);

                    // Notify the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('QR code captured but not saved to gallery')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to capture QR code')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error capturing QR code: $e')),
                  );
                }
              },
              child: const Text('Capture QR Code'),
            ),
            const SizedBox(height: 20),
            Text('Price: \$${price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
