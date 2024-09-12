import 'package:flutter/material.dart';
import 'generate_invoice_page.dart';
import 'register_items_page.dart';
import 'sales_report_page.dart';
// import 'update_items_page.dart'; // Make sure this file exists

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenerateInvoicePage()),
                );
              },
              child: Text('Generate Invoice'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => UpdateItemsPage()),
                // );
              // },
              child: Text('Update Items'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterItemsPage()),
                );
              },
              child: Text('Register Items'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => SalesReportPage()),
              //   );
              // },
              child: Text('Sales Report'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
