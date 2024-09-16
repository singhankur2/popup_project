import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SalesReportPage extends StatelessWidget {
  Future<List<List<dynamic>>> _fetchProducts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();

    List<List<dynamic>> rows = [];
    rows.add([
      'Description',
      'Price',
      'Product Name',
      'Quantity',
      'Supplier Name',
      'Product ID'
    ]);

    for (var doc in snapshot.docs) {
      rows.add([
        doc['Description'] ?? '',
        doc['Price']?.toString() ?? '',
        doc['Product_name'] ?? '',
        doc['Quantity']?.toString() ?? '',
        doc['Supplier_name'] ?? '',
        doc['product_id'] ?? ''
      ]);
    }
    return rows;
  }

  Future<String> _exportProductsToCsv() async {
    List<List<dynamic>> rows = await _fetchProducts();

    // Convert rows to CSV
    String csvData = const ListToCsvConverter().convert(rows);

    // Save the CSV file to the device
    var directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/products.csv');
    await file.writeAsString(csvData);

    return file.path;
  }

  // New method for fetching sales data
  Future<List<List<dynamic>>> _fetchSales() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('sales').get();

    List<List<dynamic>> rows = [];
    rows.add([
      'Product Name',
      'Sold Product ID',
      'Sold Quantity',
      'Supplier Name',
      // 'Total Sale Amount'
    ]);

    for (var doc in snapshot.docs) {
      rows.add([
        doc['Product_name'] ?? '',
        doc['Sold_product_id'] ?? '',
        doc['Sold_quantity']?.toString() ?? '',
        doc['Supplier_name'] ?? '',
        // doc['Total_sale_ammount']?.toString() ?? ''
      ]);
    }
    return rows;
  }

  Future<String> _exportSalesToCsv() async {
    List<List<dynamic>> rows = await _fetchSales();

    // Convert rows to CSV
    String csvData = const ListToCsvConverter().convert(rows);

    // Save the CSV file to the device
    var directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/sales.csv');
    await file.writeAsString(csvData);

    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Report Options',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
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
              // My Store Button (unchanged)
              _buildOptionButton(
                context,
                label: 'My Store',
                icon: Icons.store,
                onPressed: () async {
                  String filePath = await _exportProductsToCsv();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CsvPreviewScreen(filePath: filePath, title: 'My Store Data'),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
              // Sales Report Button (new functionality)
              _buildOptionButton(
                context,
                label: 'Sales Report',
                icon: Icons.bar_chart,
                onPressed: () async {
                  String filePath = await _exportSalesToCsv();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CsvPreviewScreen(filePath: filePath, title: 'Sales Report Data'),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
              _buildOptionButton(
                context,
                label: 'End Report',
                icon: Icons.report,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context,
      {required String label, required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepOrangeAccent,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepOrangeAccent),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// CsvPreviewScreen (unchanged, reuse for both My Store and Sales Report)
class CsvPreviewScreen extends StatelessWidget {
  final String filePath;
  final String title;

  CsvPreviewScreen({required this.filePath, required this.title});

  Future<List<List<dynamic>>> _readCsv() async {
    File file = File(filePath);
    String csvData = await file.readAsString();
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
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
        child: FutureBuilder<List<List<dynamic>>>(
          future: _readCsv(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<List<dynamic>> csvData = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: csvData.first
                          .map((header) => DataColumn(label: Text(header.toString())))
                          .toList(),
                      rows: csvData.skip(1).map((row) {
                        return DataRow(
                          cells: row.map((cell) => DataCell(Text(cell.toString()))).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text('Download CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('CSV file saved at: $filePath')),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
