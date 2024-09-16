import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class SalesReportPage extends StatefulWidget {
  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  List<Map<String, dynamic>> salesData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSalesDataFromFirestore();
  }

  // Fetch sales data from Firestore
  Future<void> fetchSalesDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();

      List<Map<String, dynamic>> tempData = querySnapshot.docs.map((doc) {
        return {
          'Product_name': doc['Product_name'],  // Field for product name
          'Quantity': doc['Quantity'],          // Field for quantity
          'Price': doc['Price'],                // Field for price
          'Supplier': doc['Supplier_name'],          // Field for supplier
          'Description': doc['Description'],    // Field for description
        };
      }).toList();

      setState(() {
        salesData = tempData;
        isLoading = false; // Stop the loading indicator
      });
    } catch (e) {
      print('Error fetching sales data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> generateCsvFile() async {
    List<List<dynamic>> rows = [];

    // Define headers
    rows.add([
      'Product Name',
      'Quantity',
      'Price',
      'Supplier',
      'Description',
    ]);

    // Add data rows
    for (var data in salesData) {
      rows.add([
        data['Product_name'] ?? '',
        data['Quantity'] ?? '',
        data['Price'] ?? '',
        data['Supplier'] ?? '',
        data['Description'] ?? '',
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Save the CSV file
      var directory = await getExternalStorageDirectory();
      String filePath = '${directory!.path}/sales_report.csv';
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsStringSync(csvData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('CSV file saved at: $filePath'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission denied!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Report',
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
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show a loading indicator while fetching data
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Download CSV Button
                  ElevatedButton(
                    onPressed: generateCsvFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,  // Background color
                      foregroundColor: Colors.deepOrangeAccent,  // Text and icon color
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),  // Rounded corners
                      ),
                      padding: EdgeInsets.all(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.file_download, size: 30),  // Download icon
                        SizedBox(width: 10),
                        Text(
                          'Download Sales Report as CSV',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: salesData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 4.0,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            leading: Icon(Icons.inventory, size: 40, color: Colors.deepOrangeAccent),  // Inventory icon
                            title: Text(salesData[index]['Product_name']),
                            subtitle: Text('Quantity: ${salesData[index]['Quantity']} | Price: ${salesData[index]['Price']}'),
                            trailing: Text('Supplier: ${salesData[index]['Supplier']}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
