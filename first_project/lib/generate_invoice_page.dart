import 'package:flutter/material.dart';
import 'product_dialog.dart';

class GenerateInvoicePage extends StatefulWidget {
  @override
  _GenerateInvoicePageState createState() => _GenerateInvoicePageState();
}

class _GenerateInvoicePageState extends State<GenerateInvoicePage> {
  List<Map<String, dynamic>> invoiceItems = [];
  TextEditingController customerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: customerNameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ProductDialog(
                    onProductAdded: (product) {
                      setState(() {
                        invoiceItems.add(product);
                      });
                    },
                  ),
                );
              },
              child: Text('Add Product'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: invoiceItems.length,
                itemBuilder: (context, index) {
                  final item = invoiceItems[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text(
                        'Description: ${item['description']}\nQuantity: ${item['quantity']}\nPrice: ${item['price']}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle invoice submission
              },
              child: Text('Submit Invoice'),
            ),
          ],
        ),
      ),
    );
  }
}
