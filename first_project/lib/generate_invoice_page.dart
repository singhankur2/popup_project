import 'package:flutter/material.dart';
import 'product_dialog.dart';
import 'invoice_summary_page.dart'; // Import the new page

class GenerateInvoicePage extends StatefulWidget {
  @override
  _GenerateInvoicePageState createState() => _GenerateInvoicePageState();
}

class _GenerateInvoicePageState extends State<GenerateInvoicePage> {
  List<Map<String, dynamic>> invoiceItems = [];
  TextEditingController customerNameController = TextEditingController(text: 'Customer A');
  TextEditingController phoneNumberController = TextEditingController(text: '123456789');

  void _submitInvoice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceSummaryPage(
          customerName: customerNameController.text,
          phoneNumber: phoneNumberController.text,
          items: invoiceItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Invoice'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: customerNameController,
              decoration: InputDecoration(
                labelText: 'Customer Name',
                labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.person, color: Colors.deepOrangeAccent),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.phone, color: Colors.deepOrangeAccent),
              ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Add Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: invoiceItems.length,
                itemBuilder: (context, index) {
                  final item = invoiceItems[index];
                  final price = item['Price'] ?? 0.0;
                  final quantity = item['Sold_quantity'] ?? 1;
                  final total = price * quantity;
                  
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(item['Product_name'] ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Quantity: ${quantity.toString()}\n'
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: _submitInvoice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Submit Invoice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
