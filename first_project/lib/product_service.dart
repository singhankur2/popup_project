import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch product data from Firestore
  Future<Map<String, dynamic>?> fetchProductDataFromFirestore(String productId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> productDoc =
          await _firestore.collection('products').doc(productId).get();
      if (productDoc.exists) {
        print(productDoc.data());

        return productDoc.data();
       
      } else {
        print("Product not found");
        return null;
      }
    } catch (e) {
      print("Error fetching product data: $e");
      return null;
    }
  }

  // Save or update sales data in Firestore
  Future<void> saveOrUpdateSalesData(String productId, int quantity) async {
    try {
      final productRef = _firestore.collection('products').doc(productId);
      final productSnapshot = await productRef.get();

      if (productSnapshot.exists) {
        final productData = productSnapshot.data();
        final productName = productData?['Product_name'] ?? 'Unknown';
        final price = productData?['Price'] ?? 0.0;
        final supplierName = productData?['Supplier_name'] ?? 'Unknown';

        final salesRef = _firestore.collection('sales').doc(productId);
        final existingSalesDoc = await salesRef.get();

        if (existingSalesDoc.exists) {
          // Update existing sales record
          final existingSalesData = existingSalesDoc.data()!;
          final existingQuantity = existingSalesData['Sold_quantity'] ?? 0;
          final newQuantity = existingQuantity + quantity;
          final totalSaleAmount = newQuantity * price;

          await salesRef.update({
            'Sold_quantity': newQuantity,
            'Total_sale_amount': totalSaleAmount,
          });
        } else {
          // Create new sales record
          final totalSaleAmount = quantity * price;

          await salesRef.set({
            'Sold_product_id': productId,
            'Product_name': productName,
            'Supplier_name': supplierName,
            'Sold_quantity': quantity,
            'Total_sale_amount': totalSaleAmount,
          });
        }
      } else {
        print("Product not found in Firestore");
      }
    } catch (e) {
      print("Error saving or updating sales data: $e");
    }
  }
}
