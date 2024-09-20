import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product_dialog.dart';
import 'invoice_summary_page.dart';

class GenerateInvoicePage extends StatefulWidget {
  const GenerateInvoicePage({super.key});

  @override
  _GenerateInvoicePageState createState() => _GenerateInvoicePageState();
}

class _GenerateInvoicePageState extends State<GenerateInvoicePage> {
  List<Map<String, dynamic>> invoiceItems = [];
  TextEditingController customerNameController = TextEditingController(text: 'Customer A');
  TextEditingController phoneNumberController = TextEditingController(text: '0123456789');
  TextEditingController addressController = TextEditingController(text: 'Noida One Sector-62 Uttar Pradesh');
  String paymentMode = 'Cash';
  String invoiceNumber = '${DateTime.now().millisecondsSinceEpoch}';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveInvoiceToSalesCollection() async {
    for (var item in invoiceItems) {
      try {
        DocumentSnapshot productDoc = await _firestore
            .collection('products')
            .doc(item['Sold_product_id'])
            .get();

        String supplierName = (productDoc.data() as Map<String, dynamic>)['Supplier_name'] ?? 'Unknown Supplier';

        QuerySnapshot existingSales = await _firestore
            .collection('sales')
            .where('Sold_product_id', isEqualTo: item['Sold_product_id'])
            .limit(1)
            .get();

        if (existingSales.docs.isNotEmpty) {
          var existingDoc = existingSales.docs.first;
          var existingData = existingDoc.data() as Map<String, dynamic>;

          int updatedQuantity = existingData['Sold_quantity'] + item['Sold_quantity'];
          double updatedTotalSaleAmount = existingData['Total_sale_amount'] + (item['Price'] * item['Sold_quantity']);

          await _firestore.collection('sales').doc(existingDoc.id).update({
            'Sold_quantity': updatedQuantity,
            'Total_sale_amount': updatedTotalSaleAmount,
            'Supplier_name': supplierName,
          });
        } else {
          Map<String, dynamic> salesData = {
            'Product_name': item['Product_name'],
            'Sold_product_id': item['Sold_product_id'],
            'Sold_quantity': item['Sold_quantity'],
            'Supplier_name': supplierName,
            'Total_sale_amount': item['Price'] * item['Sold_quantity'],
          };

          await _firestore.collection('sales').add(salesData);
        }
      } catch (e) {
        print('Error saving to Firestore: $e');
      }
    }
  }

  void _submitInvoice() async {
    await _saveInvoiceToSalesCollection();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceSummaryPage(
          customerName: customerNameController.text,
          phoneNumber: phoneNumberController.text,
          address: addressController.text,
          paymentMode: paymentMode,
          items: invoiceItems,
          invoiceNumber: invoiceNumber,
        ),
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      invoiceItems.removeAt(index);
    });
  }

  void _selectPaymentMode(String mode) {
    setState(() {
      paymentMode = mode;
    });
  }

  void _addProductToInvoice(Map<String, dynamic> product) {
    setState(() {
      // Check if the product already exists in the invoiceItems
      int existingIndex = invoiceItems.indexWhere((item) => item['Sold_product_id'] == product['Sold_product_id']);
      if (existingIndex != -1) {
        // If it exists, update the quantity and total price
        invoiceItems[existingIndex]['Sold_quantity'] += product['Sold_quantity'];
        invoiceItems[existingIndex]['Total_price'] = invoiceItems[existingIndex]['Price'] * invoiceItems[existingIndex]['Sold_quantity'];
      } else {
        // If it does not exist, add the new product
        invoiceItems.add({
          'Product_name': product['Product_name'],
          'Sold_product_id': product['Sold_product_id'],
          'Sold_quantity': product['Sold_quantity'],
          'Price': product['Price'],
          'Total_price': product['Price'] * product['Sold_quantity'], // Calculate total price for the new product
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Invoice'),
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
                labelStyle: const TextStyle(color: Colors.deepOrangeAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.deepOrangeAccent),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: const TextStyle(color: Colors.deepOrangeAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.phone, color: Colors.deepOrangeAccent),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: const TextStyle(color: Colors.deepOrangeAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.location_on, color: Colors.deepOrangeAccent),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ProductDialog(
                          onProductAdded: _addProductToInvoice, // Use the updated function here
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Add Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepOrangeAccent),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: paymentMode,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _selectPaymentMode(newValue);
                        }
                      },
                      underline: SizedBox(),
                      icon: Icon(Icons.payment, color: Colors.deepOrangeAccent),
                      items: <String>['Cash', 'UPI', 'Card'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.deepOrangeAccent)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: invoiceItems.length,
                itemBuilder: (context, index) {
                  final item = invoiceItems[index];
                  final total = item['Total_price'] ?? 0.0;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(item['Product_name'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Quantity: ${item['Sold_quantity'].toString()}\n'
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _removeItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save, color: Colors.white),
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
