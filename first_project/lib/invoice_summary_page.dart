import 'package:flutter/material.dart';

class InvoiceSummaryPage extends StatelessWidget {
  final String customerName;
  final String phoneNumber;
  final List<Map<String, dynamic>> items;

  InvoiceSummaryPage({
    required this.customerName,
    required this.phoneNumber,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invoice Summary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.orangeAccent[700],
        elevation: 8.0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.pinkAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Name: $customerName'),
                Text('Phone Number: $phoneNumber'),
                SizedBox(height: 20),
                Text(
                  'Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Product Name')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Total')),
                      ],
                      rows: items.map((item) {
                        final price = item['Price'] ?? 0.0;
                        final quantity = item['Sold_quantity'] ?? 1;
                        final total = price * quantity;

                        return DataRow(
                          cells: [
                            DataCell(Text(item['Product_name'] ?? 'No Name')),
                            DataCell(Text(quantity.toString())),
                            DataCell(Text('\$${price.toStringAsFixed(2)}')),
                            DataCell(Text('\$${total.toStringAsFixed(2)}')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text('Download CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  onPressed: () {
                    // Implement CSV export functionality here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('CSV file saved')),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                // Implement print functionality here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Print button pressed')),
                );
              },
              child: Icon(Icons.print),
              backgroundColor: Colors.deepOrangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
