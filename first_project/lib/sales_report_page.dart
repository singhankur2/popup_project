import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
          'Price': doc['price'],                // Field for price
          'Supplier': doc['supplier'],          // Field for supplier
          'Description': doc['description'],    // Field for description
        };
      }).toList();

      setState(() {
        salesData = tempData;
        print(salesData);
        isLoading = false; // Stop the loading indicator
      });
    } catch (e) {
      print('Error fetching sales data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> generateExcelFile() async {
    var excel = Excel.createExcel(); 
    Sheet sheetObject = excel['Sales Report'];

    // Add table headers
    // sheetObject.appendRow([
    //   Cell.fromString('Product_name'),
    //   Cell.fromString('Quantity'),
    //   Cell.fromString('Price'),
    //   Cell.fromString('Supplier'),
    //   Cell.fromString('Description'),
    // ]);

    // Add data
    // for (var data in salesData) {
    //   sheetObject.appendRow([
    //     Cell.fromString(data['Product_name'] ?? ''), 
    //     Cell.fromString(data['Quantity']?.toString() ?? ''), 
    //     Cell.fromString(data['Price']?.toString() ?? ''), 
    //     Cell.fromString(data['Supplier'] ?? ''), 
    //     Cell.fromString(data['Description'] ?? '')
    //   ]);
    // }

    // Save the Excel file
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var bytes = excel.save();
      var directory = await getExternalStorageDirectory();
      String filePath = '${directory!.path}/sales_report.xlsx';
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes!);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Excel file saved at: $filePath'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Report'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator while fetching data
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: generateExcelFile,
                  child: Text('Download Sales Report as Excel'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: salesData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(salesData[index]['Product_name']),
                        subtitle: Text('Quantity: ${salesData[index]['Quantity']} | Price: ${salesData[index]['Price']}'),
                        trailing: Text('Supplier: ${salesData[index]['Supplier']}'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
