// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dashboard_page.dart'; // Import the new dashboard page

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController(text: 'abc@gmail.com');
//   final TextEditingController _passwordController = TextEditingController(text: '123456');
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _login() async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       if (userCredential.user != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const DashboardPage()),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       // Handle specific error codes and display a Snackbar with user-friendly messages
//       String errorMessage = '';
//       if (e.code == 'user-not-found') {
//         errorMessage = 'Email is incorrect';
//       } else if (e.code == 'wrong-password') {
//         errorMessage = 'Password is incorrect';
//       } else if (e.code == 'invalid-email') {
//         errorMessage = 'Invalid email format';
//       } else {
//         errorMessage = 'Invalid Email or Password. Please try again.';
//       }

//       // Display the error in a Snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text(
//           'Login',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         backgroundColor: Colors.orangeAccent[700],
//         leading: const Icon(Icons.login, size: 30),
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
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Icon
//                 Container(
//                   padding: const EdgeInsets.all(20.0),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 10.0,
//                         spreadRadius: 2.0,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.lock_outline,
//                     size: 100,
//                     color: Colors.deepOrangeAccent,
//                   ),
//                 ),
//                 const SizedBox(height: 30.0),
//                 // Email TextField
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.email, color: Colors.deepOrangeAccent),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.8),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
//                     ),
//                   ),
//                   style: TextStyle(color: Colors.deepOrange[900], fontSize: 18),
//                 ),
//                 const SizedBox(height: 20.0),
//                 // Password TextField
//                 TextField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.lock, color: Colors.deepOrangeAccent),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.8),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
//                     ),
//                   ),
//                   style: TextStyle(color: Colors.deepOrange[900], fontSize: 18),
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 40.0),
//                 // Login button
//                 Container(
//                   decoration: const BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 10.0,
//                         spreadRadius: 2.0,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ElevatedButton(
//                     onPressed: _login,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepOrangeAccent,
//                       padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
//                       textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                     child: const Text(
//                       'Login',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';  // Import GoogleSignIn
import 'dashboard_page.dart'; // Import the new dashboard page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();  // Initialize GoogleSignIn

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
      }
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google sign-in failed. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.orangeAccent[700],
        leading: const Icon(Icons.login, size: 30),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular Logo
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo.jpg'), // Replace with your logo asset path
                  ),
                ),
                const SizedBox(height: 20.0),
                // Bebas Neue Font for Text
                const Text(
                  'Nihaar',
                  style: TextStyle(
                    fontFamily: 'BebasNeue', // Use the font family you declared
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50.0),
                // Google Sign-In button
                ElevatedButton.icon(
                  onPressed: _loginWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent, // Updated background color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
