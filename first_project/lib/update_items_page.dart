// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart'; // For image picking
// import 'dart:io'; // For handling file types

// class UpdateItemsPage extends StatefulWidget {
//   const UpdateItemsPage({super.key});

//   @override
//   _UpdateItemsPageState createState() => _UpdateItemsPageState();
// }

// class _UpdateItemsPageState extends State<UpdateItemsPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _productIdController = TextEditingController(text: '1PcM5Mvz2V5r3zetZsl5');
//   final TextEditingController _productNameController = TextEditingController(text: 'Product B');
//   final TextEditingController _descriptionController = TextEditingController(text: 'abcdevfhij1234');
//   final TextEditingController _priceController = TextEditingController(text: '150');
//   final TextEditingController _quantityController = TextEditingController(text: '5');
//   final TextEditingController _supplierNameController = TextEditingController(text: 'Saler B');
//   final TextEditingController _commissionController = TextEditingController(text: '10'); // New commission field

//   File? _selectedImage; // For storing the selected image

//   // Method to pick image from gallery or camera
//   Future<void> _pickImage() async {
//     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//       });
//     }
//   }

//   // Method to update product information in Firestore based on Product ID
//   void _updateProduct() {
//     if (_formKey.currentState!.validate()) {
//       final productId = _productIdController.text;

//       // Prepare the product data
//       final productData = {
//         'Description': _descriptionController.text,
//         'Price': double.tryParse(_priceController.text) ?? 0.0,
//         'Quantity': int.tryParse(_quantityController.text) ?? 0,
//         'Supplier_name': _supplierNameController.text,
//         'Product_name': _productNameController.text,
//         'Commission': double.tryParse(_commissionController.text) ?? 0.0, // Add commission field
//         'Image': _selectedImage != null ? _selectedImage!.path : null, // Image path if selected
//       };

//       // Update Firestore
//       FirebaseFirestore.instance
//           .collection('products')
//           .doc(productId)
//           .update(productData)
//           .then((_) {
//         _showUpdateDialog();
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update product: $error')));
//       });
//     }
//   }

//   // Method to show a dialog after successful update
//   void _showUpdateDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.deepOrangeAccent[100],
//           title: Row(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.green, size: 30),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   'Update Successful',
//                   style: TextStyle(color: Colors.deepOrangeAccent[800], fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           content: Text(
//             'Product information has been updated successfully!',
//             style: TextStyle(color: Colors.deepOrangeAccent[700]),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context).pop(); // Close the update page
//               },
//               child: Text(
//                 'OK',
//                 style: TextStyle(color: Colors.deepOrangeAccent[800]),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Item'),
//         backgroundColor: Colors.orangeAccent[700],
//         elevation: 8.0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.orangeAccent, Colors.pinkAccent],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Image Picker Section
//               Center(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundColor: Colors.deepOrangeAccent.withOpacity(0.5),
//                         backgroundImage:
//                             _selectedImage != null ? FileImage(_selectedImage!) : null,
//                         child: _selectedImage == null
//                             ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'Tap to select image',
//                       style: TextStyle(color: Colors.deepOrangeAccent),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Product ID Field
//               _buildTextField(
//                 controller: _productIdController,
//                 label: 'Product ID',
//                 icon: Icons.card_membership,
//                 readOnly: true,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Product Name Field
//               _buildTextField(
//                 controller: _productNameController,
//                 label: 'Product Name',
//                 icon: Icons.production_quantity_limits,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Description Field
//               _buildTextField(
//                 controller: _descriptionController,
//                 label: 'Description',
//                 icon: Icons.description,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Price Field
//               _buildTextField(
//                 controller: _priceController,
//                 label: 'Price',
//                 icon: Icons.attach_money,
//                 keyboardType: TextInputType.number,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Quantity Field
//               _buildTextField(
//                 controller: _quantityController,
//                 label: 'Quantity',
//                 icon: Icons.numbers,
//                 keyboardType: TextInputType.number,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),

//              // Commission Field
//               _buildTextField(
//                 controller: _commissionController,
//                 label: 'Commission',
//                 icon: Icons.percent,
//                 keyboardType: TextInputType.number,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),

//               // Supplier Name Field
//               _buildTextField(
//                 controller: _supplierNameController,
//                 label: 'Supplier Name',
//                 icon: Icons.business,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 20),
 
//               // Update Button
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _updateProduct,
//                   icon: const Icon(Icons.update, size: 24),
//                   label: const Text('Update Product', style: TextStyle(fontSize: 18)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrangeAccent,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 8.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool readOnly = false,
//     TextInputType keyboardType = TextInputType.text,
//     required Color fillColor,
//   }) {
//     return TextFormField(
//       controller: controller,
//       readOnly: readOnly,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.deepOrangeAccent),
//         border: const OutlineInputBorder(),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
//         ),
//         fillColor: fillColor,
//         filled: true,
//       ),
//       keyboardType: keyboardType,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter $label';
//         }
//         return null;
//       },
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart'; // For image picking
// import 'dart:io'; // For handling file types

// class UpdateItemsPage extends StatefulWidget {
//   const UpdateItemsPage({super.key});

//   @override
//   _UpdateItemsPageState createState() => _UpdateItemsPageState();
// }

// class _UpdateItemsPageState extends State<UpdateItemsPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _productIdController = TextEditingController(text: '17ekCqsmDCvqOcZ2HmlK');
//   final TextEditingController _productNameController = TextEditingController(text: 'Product c');
//   final TextEditingController _descriptionController = TextEditingController(text: 'abcdevfhij1234');
//   final TextEditingController _priceController = TextEditingController(text: '156');
//   final TextEditingController _quantityController = TextEditingController(text: '5');
//   final TextEditingController _supplierNameController = TextEditingController(text: 'Saler B');
//   final TextEditingController _commissionController = TextEditingController(text: '10'); // New commission field

//   File? _selectedImage; // For storing the selected image

//   // Method to show options for image picking
//   void _showImageSourceSelection() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.camera_alt),
//               title: Text('Take a photo'),
//               onTap: () async {
//                 Navigator.of(context).pop(); // Close the bottom sheet
//                 final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
//                 if (pickedImage != null) {
//                   setState(() {
//                     _selectedImage = File(pickedImage.path);
//                   });
//                 }
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.image),
//               title: Text('Pick from gallery'),
//               onTap: () async {
//                 Navigator.of(context).pop(); // Close the bottom sheet
//                 final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//                 if (pickedImage != null) {
//                   setState(() {
//                     _selectedImage = File(pickedImage.path);
//                   });
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Method to update product information in Firestore based on Product ID
//   void _updateProduct() {
//     if (_formKey.currentState!.validate()) {
//       final productId = _productIdController.text;

//       // Prepare the product data
//       final productData = {
//         'Description': _descriptionController.text,
//         'Price': double.tryParse(_priceController.text) ?? 0.0,
//         'Quantity': int.tryParse(_quantityController.text) ?? 0,
//         'Supplier_name': _supplierNameController.text,
//         'Product_name': _productNameController.text,
//         'Commission': double.tryParse(_commissionController.text) ?? 0.0, // Add commission field
//         'Image': _selectedImage != null ? _selectedImage!.path : null, // Image path if selected
//       };

//       // Update Firestore
//       FirebaseFirestore.instance
//           .collection('products')
//           .doc(productId)
//           .update(productData)
//           .then((_) {
//         _showUpdateDialog();
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update product: $error')));
//       });
//     }
//   }

//   // Method to show a dialog after successful update
//   void _showUpdateDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.deepOrangeAccent[100],
//           title: Row(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.green, size: 30),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   'Update Successful',
//                   style: TextStyle(color: Colors.deepOrangeAccent[800], fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           content: Text(
//             'Product information has been updated successfully!',
//             style: TextStyle(color: Colors.deepOrangeAccent[700]),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context).pop(); // Close the update page
//               },
//               child: Text(
//                 'OK',
//                 style: TextStyle(color: Colors.deepOrangeAccent[800]),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Item'),
//         backgroundColor: Colors.orangeAccent[700],
//         elevation: 8.0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.orangeAccent, Colors.pinkAccent],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Image Picker Section
//               Center(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: _showImageSourceSelection,
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundColor: Colors.deepOrangeAccent.withOpacity(0.5),
//                         backgroundImage:
//                             _selectedImage != null ? FileImage(_selectedImage!) : null,
//                         child: _selectedImage == null
//                             ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'Tap to select image',
//                       style: TextStyle(color: Colors.deepOrangeAccent),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Product ID Field
//               _buildTextField(
//                 controller: _productIdController,
//                 label: 'Product ID',
//                 icon: Icons.card_membership,
//                 readOnly: true,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Product Name Field
//               _buildTextField(
//                 controller: _productNameController,
//                 label: 'Product Name',
//                 icon: Icons.production_quantity_limits,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Description Field
//               _buildTextField(
//                 controller: _descriptionController,
//                 label: 'Description',
//                 icon: Icons.description,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Price Field
//               _buildTextField(
//                 controller: _priceController,
//                 label: 'Price',
//                 icon: Icons.attach_money,
//                 keyboardType: TextInputType.number,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Quantity Field
//               _buildTextField(
//                 controller: _quantityController,
//                 label: 'Quantity',
//                 icon: Icons.numbers,
//                 keyboardType: TextInputType.number,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),

//               // Commission Field
//               _buildTextField(
//                 controller: _commissionController,
//                 label: 'Commission',
//                 icon: Icons.percent,
//                 keyboardType: TextInputType.number,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),

//               // Supplier Name Field
//               _buildTextField(
//                 controller: _supplierNameController,
//                 label: 'Supplier Name',
//                 icon: Icons.business,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 20),

//               // Update Button
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _updateProduct,
//                   icon: const Icon(Icons.update, size: 24),
//                   label: const Text('Update Product', style: TextStyle(fontSize: 18)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrangeAccent,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 8.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool readOnly = false,
//     TextInputType keyboardType = TextInputType.text,
//     Color fillColor = Colors.transparent,
//   }) {
//     return TextFormField(
//       controller: controller,
//       readOnly: readOnly,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: label,
//         icon: Icon(icon, color: Colors.deepOrangeAccent),
//         filled: true,
//         fillColor: fillColor,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter $label';
//         }
//         return null;
//       },
//     );
//   }
// }


//correct code but not slect from camera


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart'; // For image picking
// import 'dart:io'; // For handling file types

// class UpdateItemsPage extends StatefulWidget {
//   const UpdateItemsPage({super.key});

//   @override
//   _UpdateItemsPageState createState() => _UpdateItemsPageState();
// }

// class _UpdateItemsPageState extends State<UpdateItemsPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _productIdController = TextEditingController(text: '17ekCqsmDCvqOcZ2HmlK');
//   final TextEditingController _productNameController = TextEditingController(text: 'Product c');
//   final TextEditingController _descriptionController = TextEditingController(text: 'abcdevfhij1234');
//   final TextEditingController _priceController = TextEditingController(text: '156');
//   final TextEditingController _quantityController = TextEditingController(text: '5');
//   final TextEditingController _supplierNameController = TextEditingController(text: 'Saler B');
//   final TextEditingController _commissionController = TextEditingController(text: '10'); // New commission field

//   List<File> _selectedImages = []; // For storing the selected images

//   // Method to show options for image picking
//   void _showImageSourceSelection() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.camera_alt),
//               title: Text('Take a photo'),
//               onTap: () async {
//                 Navigator.of(context).pop(); // Close the bottom sheet
//                 final pickedImages = await ImagePicker().pickMultiImage();
//                 if (pickedImages != null) {
//                   setState(() {
//                     _selectedImages = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
//                   });
//                 }
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.image),
//               title: Text('Pick from gallery'),
//               onTap: () async {
//                 Navigator.of(context).pop(); // Close the bottom sheet
//                 final pickedImages = await ImagePicker().pickMultiImage();
//                 if (pickedImages != null) {
//                   setState(() {
//                     _selectedImages = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
//                   });
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Method to update product information in Firestore based on Product ID
//   void _updateProduct() async {
//     if (_formKey.currentState!.validate()) {
//       final productId = _productIdController.text;

//       // Prepare the product data
//       final productData = {
//         'Description': _descriptionController.text,
//         'Price': double.tryParse(_priceController.text) ?? 0.0,
//         'Quantity': int.tryParse(_quantityController.text) ?? 0,
//         'Supplier_name': _supplierNameController.text,
//         'Product_name': _productNameController.text,
//         'Commission': double.tryParse(_commissionController.text) ?? 0.0, // Add commission field
//         'Product_images': _selectedImages.map((file) => file.path).toList(), // List of image paths
//       };

//       // Update Firestore
//       FirebaseFirestore.instance
//           .collection('products')
//           .doc(productId)
//           .update(productData)
//           .then((_) {
//         _showUpdateDialog();
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update product: $error')));
//       });
//     }
//   }

//   // Method to show a dialog after successful update
//   void _showUpdateDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.deepOrangeAccent[100],
//           title: Row(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.green, size: 30),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   'Update Successful',
//                   style: TextStyle(color: Colors.deepOrangeAccent[800], fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           content: Text(
//             'Product information has been updated successfully!',
//             style: TextStyle(color: Colors.deepOrangeAccent[700]),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context).pop(); // Close the update page
//               },
//               child: Text(
//                 'OK',
//                 style: TextStyle(color: Colors.deepOrangeAccent[800]),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Item'),
//         backgroundColor: Colors.orangeAccent[700],
//         elevation: 8.0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.orangeAccent, Colors.pinkAccent],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Image Picker Section
//               Center(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: _showImageSourceSelection,
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundColor: Colors.deepOrangeAccent.withOpacity(0.5),
//                         backgroundImage:
//                             _selectedImages.isNotEmpty ? FileImage(_selectedImages[0]) : null,
//                         child: _selectedImages.isEmpty
//                             ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'Tap to select images',
//                       style: TextStyle(color: Colors.deepOrangeAccent),
//                     ),
//                     const SizedBox(height: 10),
//                     if (_selectedImages.isNotEmpty)
//                       SizedBox(
//                         height: 100,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: _selectedImages.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                               child: Image.file(
//                                 _selectedImages[index],
//                                 width: 100,
//                                 height: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Product ID Field
//               _buildTextField(
//                 controller: _productIdController,
//                 label: 'Product ID',
//                 icon: Icons.card_membership,
//                 readOnly: true,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Product Name Field
//               _buildTextField(
//                 controller: _productNameController,
//                 label: 'Product Name',
//                 icon: Icons.production_quantity_limits,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Description Field
//               _buildTextField(
//                 controller: _descriptionController,
//                 label: 'Description',
//                 icon: Icons.description,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Price Field
//               _buildTextField(
//                 controller: _priceController,
//                 label: 'Price',
//                 icon: Icons.attach_money,
//                 keyboardType: TextInputType.number,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),
//               // Quantity Field
//               _buildTextField(
//                 controller: _quantityController,
//                 label: 'Quantity',
//                 icon: Icons.numbers,
//                 keyboardType: TextInputType.number,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),

//               // Commission Field
//               _buildTextField(
//                 controller: _commissionController,
//                 label: 'Commission',
//                 icon: Icons.percent,
//                 keyboardType: TextInputType.number,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 10),

//               // Supplier Name Field
//               _buildTextField(
//                 controller: _supplierNameController,
//                 label: 'Supplier Name',
//                 icon: Icons.business,
//                 fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
//               ),
//               const SizedBox(height: 20),

//               // Update Button
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _updateProduct,
//                   icon: const Icon(Icons.update, size: 24),
//                   label: const Text('Update Product', style: TextStyle(fontSize: 18)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrangeAccent,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to build text fields
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool readOnly = false,
//     TextInputType keyboardType = TextInputType.text,
//     Color? fillColor,
//   }) {
//     return TextFormField(
//       controller: controller,
//       readOnly: readOnly,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.deepOrangeAccent),
//         labelText: label,
//         fillColor: fillColor,
//         filled: true,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter $label';
//         }
//         return null;
//       },
//     );
//   }
// }





// above code error solve

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For handling file types

class UpdateItemsPage extends StatefulWidget {
  const UpdateItemsPage({super.key});

  @override
  _UpdateItemsPageState createState() => _UpdateItemsPageState();
}

class _UpdateItemsPageState extends State<UpdateItemsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productIdController = TextEditingController(text: '17ekCqsmDCvqOcZ2HmlK');
  final TextEditingController _productNameController = TextEditingController(text: 'Product c');
  final TextEditingController _descriptionController = TextEditingController(text: 'abcdevfhij1234');
  final TextEditingController _priceController = TextEditingController(text: '156');
  final TextEditingController _quantityController = TextEditingController(text: '5');
  final TextEditingController _supplierNameController = TextEditingController(text: 'Saler B');
  final TextEditingController _commissionController = TextEditingController(text: '10'); // New commission field

  List<File> _selectedImages = []; // For storing the selected images

  // Method to show options for image picking
  void _showImageSourceSelection() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () async {
                Navigator.of(context).pop(); // Close the bottom sheet
                final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  setState(() {
                    _selectedImages = [File(pickedImage.path)];
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Pick from gallery'),
              onTap: () async {
                Navigator.of(context).pop(); // Close the bottom sheet
                final pickedImages = await ImagePicker().pickMultiImage();
                if (pickedImages != null) {
                  setState(() {
                    _selectedImages = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Method to show a validation dialog if any field is empty
  void _showValidationDialog(String fieldName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: Text('Please fill this value: $fieldName'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to update product information in Firestore based on Product ID
  void _updateProduct() async {
    // Check for empty fields
    if (_productNameController.text.isEmpty) {
      _showValidationDialog('Product Name');
      return;
    }
    if (_descriptionController.text.isEmpty) {
      _showValidationDialog('Description');
      return;
    }
    if (_priceController.text.isEmpty) {
      _showValidationDialog('Price');
      return;
    }
    if (_quantityController.text.isEmpty) {
      _showValidationDialog('Quantity');
      return;
    }
    if (_supplierNameController.text.isEmpty) {
      _showValidationDialog('Supplier Name');
      return;
    }
    if (_commissionController.text.isEmpty) {
      _showValidationDialog('Commission');
      return;
    }

    // If all fields are filled, proceed with updating the product
    final productId = _productIdController.text;

    // Prepare the product data
    final productData = {
      'Description': _descriptionController.text,
      'Price': double.tryParse(_priceController.text) ?? 0.0,
      'Quantity': int.tryParse(_quantityController.text) ?? 0,
      'Supplier_name': _supplierNameController.text,
      'Product_name': _productNameController.text,
      'Commission': double.tryParse(_commissionController.text) ?? 0.0, // Add commission field
      'Product_images': _selectedImages.map((file) => file.path).toList(), // List of image paths
    };

    // Update Firestore
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update(productData)
        .then((_) {
      _showUpdateDialog();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update product: $error')));
    });
  }

  // Method to show a dialog after successful update
  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepOrangeAccent[100],
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Update Successful',
                  style: TextStyle(color: Colors.deepOrangeAccent[800], fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            'Product information has been updated successfully!',
            style: TextStyle(color: Colors.deepOrangeAccent[700]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the update page
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.deepOrangeAccent[800]),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Item'),
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Picker Section
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showImageSourceSelection,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.deepOrangeAccent.withOpacity(0.5),
                        backgroundImage:
                            _selectedImages.isNotEmpty ? FileImage(_selectedImages[0]) : null,
                        child: _selectedImages.isEmpty
                            ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tap to select images',
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ),
                    const SizedBox(height: 10),
                    if (_selectedImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Image.file(
                                _selectedImages[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Product ID Field
              _buildTextField(
                controller: _productIdController,
                label: 'Product ID',
                icon: Icons.card_membership,
                readOnly: true,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
              ),
              const SizedBox(height: 10),
              // Product Name Field
              _buildTextField(
                controller: _productNameController,
                label: 'Product Name',
                icon: Icons.production_quantity_limits,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
              ),
              const SizedBox(height: 10),
              // Description Field
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
              ),
              const SizedBox(height: 10),
              // Price Field
              _buildTextField(
                controller: _priceController,
                label: 'Price',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
              ),
              const SizedBox(height: 10),
              // Quantity Field
              _buildTextField(
                controller: _quantityController,
                label: 'Quantity',
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
              ),
              const SizedBox(height: 10),
              // Commission Field
              _buildTextField(
                controller: _commissionController,
                label: 'Commission',
                icon: Icons.percent,
                keyboardType: TextInputType.number,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
              ),
            const SizedBox(height: 10),
              // Supplier Name Field
              _buildTextField(
                controller: _supplierNameController,
                label: 'Supplier Name',
                icon: Icons.local_shipping,
                fillColor: Colors.deepOrangeAccent.withOpacity(0.2),
              ),
              const SizedBox(height: 30),
              // Update Button
              ElevatedButton(
                onPressed: _updateProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 240, 125, 86),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Update Product',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields with icons
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    Color? fillColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        filled: true,
        fillColor: fillColor ?? Colors.orangeAccent.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}







//colour



