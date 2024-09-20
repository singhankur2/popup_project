// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// class InvoiceSummaryPage extends StatelessWidget {
//   final String customerName;
//   final String phoneNumber;
//   final List<Map<String, dynamic>> items;

//   const InvoiceSummaryPage({
//     super.key,
//     required this.customerName,
//     required this.phoneNumber,
//     required this.items, required String address, required String paymentMode,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Invoice Summary',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         backgroundColor: Colors.orangeAccent[700],
//         elevation: 8.0,
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.orangeAccent, Colors.pinkAccent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Customer Details',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Text('Name: $customerName'),
//                 Text('Phone Number: $phoneNumber'),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Products',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columns: const [
//                         DataColumn(label: Text('Product Name')),
//                         DataColumn(label: Text('Quantity')),
//                         DataColumn(label: Text('Price')),
//                         DataColumn(label: Text('Total')),
//                       ],
//                       rows: items.map((item) {
//                         final price = item['Price'] ?? 0.0;
//                         final quantity = item['Sold_quantity'] ?? 1;
//                         final total = price * quantity;

//                         return DataRow(
//                           cells: [
//                             DataCell(Text(item['Product_name'] ?? 'No Name')),
//                             DataCell(Text(quantity.toString())),
//                             DataCell(Text('\$${price.toStringAsFixed(2)}')),
//                             DataCell(Text('\$${total.toStringAsFixed(2)}')),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.share, color: Colors.white),
//                   label: const Text('Share Invoice as PDF'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrangeAccent,
//                   ),
//                   onPressed: () async {
//                     // Call the method to create and share the PDF
//                     await _createAndSharePDF();
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 16.0,
//             right: 16.0,
//             child: FloatingActionButton(
//               onPressed: () {
//                 // Implement print functionality here
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Print button pressed')),
//                 );
//               },
//               backgroundColor: Colors.deepOrangeAccent,
//               child: const Icon(Icons.print),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Method to create and share the PDF
//   Future<void> _createAndSharePDF() async {
//     final pdf = pw.Document();

//     // Add invoice summary content to PDF
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text('Invoice Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 20),
//               pw.Text('Customer Name: $customerName'),
//               pw.Text('Phone Number: $phoneNumber'),
//               pw.SizedBox(height: 20),
//               pw.Text('Products', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
//               pw.Table.fromTextArray(
//                 headers: ['Product Name', 'Quantity', 'Price', 'Total'],
//                 data: items.map((item) {
//                   final price = item['Price'] ?? 0.0;
//                   final quantity = item['Sold_quantity'] ?? 1;
//                   final total = price * quantity;
//                   return [
//                     item['Product_name'] ?? 'No Name',
//                     quantity.toString(),
//                     '\$${price.toStringAsFixed(2)}',
//                     '\$${total.toStringAsFixed(2)}',
//                   ];
//                 }).toList(),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     try {
//       // Save PDF to a file
//       final directory = await getTemporaryDirectory();  // Temporary directory for sharing
//       final file = File('${directory.path}/invoice_summary.pdf');
//       await file.writeAsBytes(await pdf.save());

//       // Share the PDF file using `XFile` from `share_plus`
//       final xFile = XFile(file.path);
//       await Share.shareXFiles([xFile], text: 'Invoice Summary');
//     } catch (e) {
//       print('Error sharing PDF: $e');
//     }
//   }
// }






// sales data update and 2 new information and invoice number  show on screen

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// class InvoiceSummaryPage extends StatelessWidget {
//   final String customerName;
//   final String phoneNumber;
//   final List<Map<String, dynamic>> items;
//   final String address;
//   final String paymentMode;
//   final String invoiceNumber; // New field for invoice number

//   const InvoiceSummaryPage({
//     super.key,
//     required this.customerName,
//     required this.phoneNumber,
//     required this.items,
//     required this.address,
//     required this.paymentMode,
//     required this.invoiceNumber, // Initialize the invoice number
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Invoice Summary',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         backgroundColor: Colors.orangeAccent[700],
//         elevation: 8.0,
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.orangeAccent, Colors.pinkAccent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Customer Details',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         const Text(
//                           'Invoice No:',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           invoiceNumber,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Text('Name: $customerName'),
//                 Text('Phone Number: $phoneNumber'),
//                 Text('Address: $address'),
//                 Text('Payment Mode: $paymentMode'),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Products',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columns: const [
//                         DataColumn(label: Text('Product Name')),
//                         DataColumn(label: Text('Quantity')),
//                         DataColumn(label: Text('Price')),
//                         DataColumn(label: Text('Total')),
//                       ],
//                       rows: items.map((item) {
//                         final price = item['Price'] ?? 0.0;
//                         final quantity = item['Sold_quantity'] ?? 1;
//                         final total = price * quantity;

//                         return DataRow(
//                           cells: [
//                             DataCell(Text(item['Product_name'] ?? 'No Name')),
//                             DataCell(Text(quantity.toString())),
//                             DataCell(Text('\$${price.toStringAsFixed(2)}')),
//                             DataCell(Text('\$${total.toStringAsFixed(2)}')),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.share, color: Colors.white),
//                   label: const Text('Share Invoice as PDF'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrangeAccent,
//                   ),
//                   onPressed: () async {
//                     // Call the method to create and share the PDF
//                     await _createAndSharePDF();
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 16.0,
//             right: 16.0,
//             child: FloatingActionButton(
//               onPressed: () {
//                 // Implement print functionality here
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Print button pressed')),
//                 );
//               },
//               backgroundColor: Colors.deepOrangeAccent,
//               child: const Icon(Icons.print),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Method to create and share the PDF
//   Future<void> _createAndSharePDF() async {
//     final pdf = pw.Document();

//     // Add invoice summary content to PDF
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text('Invoice Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.end,
//                     children: [
//                       pw.Text('Invoice No:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
//                       pw.Text(invoiceNumber, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
//                     ],
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text('Customer Name: $customerName'),
//               pw.Text('Phone Number: $phoneNumber'),
//               pw.SizedBox(height: 20),
//               pw.Text('Products', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
//               pw.Table.fromTextArray(
//                 headers: ['Product Name', 'Quantity', 'Price', 'Total'],
//                 data: items.map((item) {
//                   final price = item['Price'] ?? 0.0;
//                   final quantity = item['Sold_quantity'] ?? 1;
//                   final total = price * quantity;
//                   return [
//                     item['Product_name'] ?? 'No Name',
//                     quantity.toString(),
//                     '\$${price.toStringAsFixed(2)}',
//                     '\$${total.toStringAsFixed(2)}',
//                   ];
//                 }).toList(),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     try {
//       // Save PDF to a file
//       final directory = await getTemporaryDirectory();  // Temporary directory for sharing
//       final file = File('${directory.path}/invoice_summary.pdf');
//       await file.writeAsBytes(await pdf.save());

//       // Share the PDF file using `XFile` from `share_plus`
//       final xFile = XFile(file.path);
//       await Share.shareXFiles([xFile], text: 'Invoice Summary');
//     } catch (e) {
//       print('Error sharing PDF: $e');
//     }
//   }
// }





// date added


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:intl/intl.dart'; // Import for date formatting

// class InvoiceSummaryPage extends StatefulWidget {
//   final String customerName;
//   final String phoneNumber;
//   final List<Map<String, dynamic>> items;
//   final String address;
//   final String paymentMode;
//   final String invoiceNumber;

//   const InvoiceSummaryPage({
//     super.key,
//     required this.customerName,
//     required this.phoneNumber,
//     required this.items,
//     required this.address,
//     required this.paymentMode,
//     required this.invoiceNumber,
//   });

//   @override
//   _InvoiceSummaryPageState createState() => _InvoiceSummaryPageState();
// }

// class _InvoiceSummaryPageState extends State<InvoiceSummaryPage> {
//   late String currentDate;

//   @override
//   void initState() {
//     super.initState();
//     // Set the current date when the widget is initialized
//     currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Invoice Summary',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         backgroundColor: Colors.orangeAccent[700],
//         elevation: 8.0,
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.orangeAccent, Colors.pinkAccent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Customer Details',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         const Text(
//                           'Invoice No:',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           widget.invoiceNumber,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         const Text(
//                           'Date:',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           currentDate,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Text('Name: ${widget.customerName}'),
//                 Text('Phone Number: ${widget.phoneNumber}'),
//                 Text('Address: ${widget.address}'),
//                 Text('Payment Mode: ${widget.paymentMode}'),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Products',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columns: const [
//                         DataColumn(label: Text('Product Name')),
//                         DataColumn(label: Text('Quantity')),
//                         DataColumn(label: Text('Price')),
//                         DataColumn(label: Text('Total')),
//                       ],
//                       rows: widget.items.map((item) {
//                         final price = item['Price'] ?? 0.0;
//                         final quantity = item['Sold_quantity'] ?? 1;
//                         final total = price * quantity;

//                         return DataRow(
//                           cells: [
//                             DataCell(Text(item['Product_name'] ?? 'No Name')),
//                             DataCell(Text(quantity.toString())),
//                             DataCell(Text('\$${price.toStringAsFixed(2)}')),
//                             DataCell(Text('\$${total.toStringAsFixed(2)}')),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.share, color: Colors.white),
//                   label: const Text('Share Invoice as PDF'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrangeAccent,
//                   ),
//                   onPressed: () async {
//                     // Call the method to create and share the PDF
//                     await _createAndSharePDF();
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 16.0,
//             right: 16.0,
//             child: FloatingActionButton(
//               onPressed: () {
//                 // Implement print functionality here
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Print button pressed')),
//                 );
//               },
//               backgroundColor: Colors.deepOrangeAccent,
//               child: const Icon(Icons.print),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Method to create and share the PDF
//   Future<void> _createAndSharePDF() async {
//     final pdf = pw.Document();

//     // Add invoice summary content to PDF
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text('Invoice Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.end,
//                     children: [
//                       pw.Text('Invoice No:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
//                       pw.Text(widget.invoiceNumber, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
//                       pw.SizedBox(height: 5),
//                       pw.Text('Date:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
//                       pw.Text(currentDate, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
//                     ],
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text('Customer Name: ${widget.customerName}'),
//               pw.Text('Phone Number: ${widget.phoneNumber}'),
//               pw.SizedBox(height: 20),
//               pw.Text('Products', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
//               pw.Table.fromTextArray(
//                 headers: ['Product Name', 'Quantity', 'Price', 'Total'],
//                 data: widget.items.map((item) {
//                   final price = item['Price'] ?? 0.0;
//                   final quantity = item['Sold_quantity'] ?? 1;
//                   final total = price * quantity;
//                   return [
//                     item['Product_name'] ?? 'No Name',
//                     quantity.toString(),
//                     '\$${price.toStringAsFixed(2)}',
//                     '\$${total.toStringAsFixed(2)}',
//                   ];
//                 }).toList(),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     try {
//       // Save PDF to a file
//       final directory = await getTemporaryDirectory();  // Temporary directory for sharing
//       final file = File('${directory.path}/invoice_summary.pdf');
//       await file.writeAsBytes(await pdf.save());

//       // Share the PDF file using `XFile` from `share_plus`
//       final xFile = XFile(file.path);
//       await Share.shareXFiles([xFile], text: 'Invoice Summary');
//     } catch (e) {
//       print('Error sharing PDF: $e');
//     }
//   }
// }

// // Example of how to use InvoiceSummaryPage and pass the current date
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       body: InvoiceSummaryPage(
//         customerName: 'John Doe',
//         phoneNumber: '123-456-7890',
//         items: [
//           {'Product_name': 'Widget', 'Price': 19.99, 'Sold_quantity': 2},
//           {'Product_name': 'Gadget', 'Price': 29.99, 'Sold_quantity': 1},
//         ],
//         address: '123 Main St',
//         paymentMode: 'Credit Card',
//         invoiceNumber: 'INV-12345',
//       ),
//     ),
//   ));
// }



// printing



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart'; // Import for printing functionality
import 'package:intl/intl.dart'; // Import for date formatting

class InvoiceSummaryPage extends StatefulWidget {
  final String customerName;
  final String phoneNumber;
  final List<Map<String, dynamic>> items;
  final String address;
  final String paymentMode;
  final String invoiceNumber;

  const InvoiceSummaryPage({
    super.key,
    required this.customerName,
    required this.phoneNumber,
    required this.items,
    required this.address,
    required this.paymentMode,
    required this.invoiceNumber,
  });

  @override
  _InvoiceSummaryPageState createState() => _InvoiceSummaryPageState();
}

class _InvoiceSummaryPageState extends State<InvoiceSummaryPage> {
  late String currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invoice Summary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.orangeAccent[700],
        elevation: 8.0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Customer Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Invoice No:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.invoiceNumber,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Date:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          currentDate,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Name: ${widget.customerName}'),
                Text('Phone Number: ${widget.phoneNumber}'),
                Text('Address: ${widget.address}'),
                Text('Payment Mode: ${widget.paymentMode}'),
                const SizedBox(height: 20),
                const Text(
                  'Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
                      rows: widget.items.map((item) {
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
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: const Text('Share Invoice as PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  onPressed: () async {
                    await _createAndSharePDF();
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
                _createAndPrintPDF();
              },
              backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.print),
            ),
          ),
        ],
      ),
    );
  }

  // Method to create and share the PDF
  Future<void> _createAndSharePDF() async {
    final pdf = pw.Document();

    // Add invoice summary content to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('Nihaar', style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Invoice No:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      pw.Text(widget.invoiceNumber, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      pw.SizedBox(height: 5),
                      pw.Text('Date:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      pw.Text(currentDate, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Customer Name: ${widget.customerName}'),
              pw.Text('Phone Number: ${widget.phoneNumber}'),
              pw.Text('Address: ${widget.address}'),
              pw.Text('Payment Mode: ${widget.paymentMode}'),
              pw.SizedBox(height: 20),
              pw.Text('Products', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Table.fromTextArray(
                headers: ['Product Name', 'Quantity', 'Price', 'Total'],
                data: widget.items.map((item) {
                  final price = item['Price'] ?? 0.0;
                  final quantity = item['Sold_quantity'] ?? 1;
                  final total = price * quantity;
                  return [
                    item['Product_name'] ?? 'No Name',
                    quantity.toString(),
                    '\$${price.toStringAsFixed(2)}',
                    '\$${total.toStringAsFixed(2)}',
                  ];
                }).toList(),
                cellAlignment: pw.Alignment.centerRight,
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Grand Total:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 10),
                  pw.Text(
                    '\$${widget.items.fold<double>(0, (sum, item) => sum + (item['Price'] ?? 0.0) * (item['Sold_quantity'] ?? 1)).toStringAsFixed(2)}',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    try {
      // Save PDF to a file
      final directory = await getTemporaryDirectory();  // Temporary directory for sharing
      final file = File('${directory.path}/invoice_summary.pdf');
      await file.writeAsBytes(await pdf.save());

      // Share the PDF file using `XFile` from `share_plus`
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'Invoice Summary');
    } catch (e) {
      print('Error sharing PDF: $e');
    }
  }

  // Method to create and print the PDF
  Future<void> _createAndPrintPDF() async {
    final pdf = pw.Document();

    // Add invoice summary content to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('Nihaar', style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Invoice No:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      pw.Text(widget.invoiceNumber, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      pw.SizedBox(height: 5),
                      pw.Text('Date:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                      pw.Text(currentDate, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Customer Name: ${widget.customerName}'),
              pw.Text('Phone Number: ${widget.phoneNumber}'),
              pw.Text('Address: ${widget.address}'),
              pw.Text('Payment Mode: ${widget.paymentMode}'),
              pw.SizedBox(height: 20),
              pw.Text('Products', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Table.fromTextArray(
                headers: ['Product Name', 'Quantity', 'Price', 'Total'],
                data: widget.items.map((item) {
                  final price = item['Price'] ?? 0.0;
                  final quantity = item['Sold_quantity'] ?? 1;
                  final total = price * quantity;
                  return [
                    item['Product_name'] ?? 'No Name',
                    quantity.toString(),
                    '\$${price.toStringAsFixed(2)}',
                    '\$${total.toStringAsFixed(2)}',
                  ];
                }).toList(),
                cellAlignment: pw.Alignment.centerRight,
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Grand Total:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 10),
                  pw.Text(
                    '\$${widget.items.fold<double>(0, (sum, item) => sum + (item['Price'] ?? 0.0) * (item['Sold_quantity'] ?? 1)).toStringAsFixed(2)}',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print('Error printing PDF: $e');
    }
  }
}
