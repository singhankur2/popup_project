import 'package:flutter/material.dart';
import 'generate_invoice_page.dart';
import 'register_items_page.dart';
import 'sales_report_page.dart';

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
            crossAxisCount: 2,  // Display buttons in a 2x2 grid
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            padding: EdgeInsets.all(16.0),
            children: [
              // Generate Invoice Button
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
              // Update Items Button
              _buildDashboardButton(
                context,
                label: 'Update Items',
                icon: Icons.update,
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => UpdateItemsPage()),
                  // );
                },
              ),
              // Register Items Button
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
              // Sales Report Button
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

  // A helper method to create each dashboard button
  Widget _buildDashboardButton(BuildContext context,
      {required String label, required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,  // White background
        foregroundColor: Colors.deepOrangeAccent,  // Text and icon color
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),  // Squared corners
        ),
        padding: EdgeInsets.all(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.deepOrangeAccent),  // Button icon
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
