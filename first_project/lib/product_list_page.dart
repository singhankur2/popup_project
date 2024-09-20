import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 8.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productName = product['Product_name'] ?? 'No name';
              final price = product['Price'] != null ? product['Price'].toString() : 'No price';
              final ProductID = product['product_id'] ?? 'No description';
              final imageUrlList = product['Product_images'] as List?;
              final imageUrls = imageUrlList != null && imageUrlList.isNotEmpty
                  ? imageUrlList.cast<String>()
                  : [];

              // Debug output
              print('Product: $productName');
              print('Image URLs: $imageUrls');

              return Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (imageUrls.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CarouselSlider.builder(
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index, realIndex) {
                            final imageUrl = imageUrls[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(child: Text('Image not available'));
                                },
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 200,
                            viewportFraction: 1.0,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(milliseconds: 800),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 14, 13, 13),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'Price - \$$price',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 14, 13, 13),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'ID - $ProductID',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
