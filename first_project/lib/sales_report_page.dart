import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SalesReportPage extends StatelessWidget {
  const SalesReportPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchProductsData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchSalesData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('sales').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sales Report Options',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
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
              // My Store Button
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
              const SizedBox(height: 16.0),
              // Sales Report Button
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
              const SizedBox(height: 16.0),
              // End Report Button
              _buildOptionButton(
                context,
                label: 'End Report',
                icon: Icons.report,
                onPressed: () async {
                  // Fetch products and sales data
                  List<Map<String, dynamic>> products = await _fetchProductsData();
                  List<Map<String, dynamic>> sales = await _fetchSalesData();

                  List<Map<String, dynamic>> reportData = [];

                  for (var sale in sales) {
                    for (var product in products) {
                      if (sale['Sold_product_id'] == product['product_id']) {
                        // Calculate necessary values
                        double totalSaleAmount = sale['Total_sale_amount'] ?? 0;
                        double commission = product['Commission'] ?? 0;
                        double supplierPart = totalSaleAmount - ((totalSaleAmount * commission) / 100);
                        double ownerPart = (totalSaleAmount * commission) / 100;

                        // Prepare report entry
                        reportData.add({
                          'Product ID': product['product_id'] ?? '',
                          'Product Name': product['Product_name'] ?? '',
                          'Product Quantity': sale['Sold_quantity'] ?? '',
                          'Commission': '$commission %',
                          'Product Sale': totalSaleAmount,
                          'Supplier Name': product['Supplier_name'] ?? '',
                          'Supplier Part': supplierPart,
                          'Owner Part': ownerPart,
                        });
                      }
                    }
                  }

                  // Convert reportData into CSV format and show in table view
                  List<List<dynamic>> rows = [];
                  rows.add([
                    'Product ID', 'Product Name', 'Product Quantity', 'Commission', 
                    'Product Sale', 'Supplier Name', 'Supplier Part', 'Owner Part',
                  ]);
                  for (var data in reportData) {
                    rows.add([
                      data['Product ID'],
                      data['Product Name'],
                      data['Product Quantity'],
                      data['Commission'],
                      data['Product Sale'],
                      data['Supplier Name'],
                      data['Supplier Part'],
                      data['Owner Part'],
                
                    ]);
                  }

                  // Convert list to CSV and preview in table format
                  String csvData = const ListToCsvConverter().convert(rows);
                  var directory = await getDownloadsDirectory();
                  var file = File('${directory?.path}/end_report.csv');
                  await file.writeAsString(csvData);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CsvPreviewScreen(filePath: file.path, title: 'End Report Data'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context,
      {required String label, required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
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
          padding: const EdgeInsets.all(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepOrangeAccent),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
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

  Future<List<List<dynamic>>> _fetchProducts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    List<List<dynamic>> rows = [];
    rows.add(['Description', 'Price', 'Product Name', 'Quantity', 'Supplier Name', 'Product ID', 'Commission']);
    for (var doc in snapshot.docs) {
      rows.add([
        doc['Description'] ?? '',
        doc['Price']?.toString() ?? '',
        doc['Product_name'] ?? '',
        doc['Quantity']?.toString() ?? '',
        doc['Supplier_name'] ?? '',
        doc['product_id'] ?? '',
        doc['Commission'] ?? '',
      ]);
    }
    return rows;
  }

  Future<String> _exportProductsToCsv() async {
    List<List<dynamic>> rows = await _fetchProducts();
    String csvData = const ListToCsvConverter().convert(rows);
    var directory = await getDownloadsDirectory();
    var file = File('${directory?.path}/products.csv');
    await file.writeAsString(csvData);
    return file.path;
  }

  Future<List<List<dynamic>>> _fetchSales() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('sales').get();
    List<List<dynamic>> rows = [];
    rows.add(['Product Name', 'Sold Product ID', 'Sold Quantity', 'Supplier Name']);
    for (var doc in snapshot.docs) {
      rows.add([
        doc['Product_name'] ?? '',
        doc['Sold_product_id'] ?? '',
        doc['Sold_quantity']?.toString() ?? '',
        doc['Supplier_name'] ?? '',
      ]);
    }
    return rows;
  }

  Future<String> _exportSalesToCsv() async {
    List<List<dynamic>> rows = await _fetchSales();
    String csvData = const ListToCsvConverter().convert(rows);
    var directory = await getDownloadsDirectory();
    var file = File('${directory?.path}/sales.csv');
    await file.writeAsString(csvData);
    return file.path;
  }
}

// CsvPreviewScreen (Same for all screens)
class CsvPreviewScreen extends StatelessWidget {
  final String filePath;
  final String title;

  const CsvPreviewScreen({super.key, required this.filePath, required this.title});

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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
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
        child: FutureBuilder<List<List<dynamic>>>(
          future: _readCsv(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
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
                      rows: csvData
                          .skip(1)
                          .map((row) => DataRow(
                                cells: row
                                    .map((cell) => DataCell(Text(cell.toString())))
                                    .toList(),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

