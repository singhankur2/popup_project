import 'package:flutter/material.dart';
import 'product_dialog.dart';
import 'product_service.dart';

class GenerateInvoicePage extends StatefulWidget {
  @override
  _GenerateInvoicePageState createState() => _GenerateInvoicePageState();
}

class _GenerateInvoicePageState extends State<GenerateInvoicePage> {
  List<Map<String, dynamic>> invoiceItems = [];
  TextEditingController customerNameController = TextEditingController(text: 'Customer A'); // Default value
  TextEditingController phoneNumberController = TextEditingController(text: '123456789'); // Default value

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
                        'Quantity: ${item['Sold_quantity']?.toString() ?? '0'}\n'
                        'Price: \$${item['Total_sale_amount']?.toString() ?? '0.0'}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final productService = ProductService();

                for (var item in invoiceItems) {
                  final productId = item['Sold_product_id'];
                  final quantity = item['Sold_quantity'];

                  // Save or update sales data
                  await productService.saveOrUpdateSalesData(productId, quantity);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invoice submitted successfully!')),
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
                  Icon(Icons.check, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Submit Invoice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
