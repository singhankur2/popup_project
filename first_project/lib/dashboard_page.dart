import 'package:flutter/material.dart';
import 'generate_invoice_page.dart';
import 'register_items_page.dart';
import 'sales_report_page.dart';
import 'update_items_page.dart';  // Import the new page

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
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
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            padding: EdgeInsets.all(16.0),
            children: [
              _buildDashboardButton(
                context,
                label: 'Generate Invoice',
                icon: Icons.receipt_long,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateInvoicePage()),
                  );
                },
              ),
              _buildDashboardButton(
                context,
                label: 'Update Items',
                icon: Icons.update,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateItemsPage()),  // Navigate to the new page
                  );
                },
              ),
              _buildDashboardButton(
                context,
                label: 'Register Items',
                icon: Icons.add_box,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterItemsPage()),
                  );
                },
              ),
              _buildDashboardButton(
                context,
                label: 'Sales Report',
                icon: Icons.bar_chart,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesReportPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required String label, required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepOrangeAccent,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.deepOrangeAccent),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrangeAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
