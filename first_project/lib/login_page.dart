import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_page.dart';  // Import the new dashboard page

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController(text: 'abc@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: '123456');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _errorMessage;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.orangeAccent[700],  // Bold and vibrant app bar color
        leading: Icon(Icons.login, size: 30),
        elevation: 8.0,  // Adding shadow to the app bar for depth
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.pinkAccent],  // Attractive background gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Prominent icon at the top with a circular container
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 100,
                    color: Colors.deepOrangeAccent,  // Icon color that pops
                  ),
                ),
                SizedBox(height: 30.0),
                // Email TextField with stylish decoration
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    // labelText: 'Email',
                    // labelStyle: TextStyle(color: Colors.deepOrange[900], fontSize: 18),  // Stylish label
                    prefixIcon: Icon(Icons.email, color: Colors.deepOrangeAccent),  // Email icon
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),  // Light background for input
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),  // Rounded edges
                      borderSide: BorderSide(color: Colors.orangeAccent, width: 2),  // Border styling
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.pinkAccent, width: 2),  // Focus border
                    ),
                  ),
                  style: TextStyle(color: Colors.deepOrange[900], fontSize: 18),
                ),
                SizedBox(height: 20.0),
                // Password TextField with stylish decoration
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    // labelText: 'Password',
                    // labelStyle: TextStyle(color: Colors.deepOrange[900], fontSize: 18),  // Stylish label
                    prefixIcon: Icon(Icons.lock, color: Colors.deepOrangeAccent),  // Password icon
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),  // Light background for input
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),  // Rounded edges
                      borderSide: BorderSide(color: Colors.orangeAccent, width: 2),  // Border styling
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.pinkAccent, width: 2),  // Focus border
                    ),
                  ),
                  style: TextStyle(color: Colors.deepOrange[900], fontSize: 18),
                  obscureText: true,
                ),
                SizedBox(height: 40.0),
                // Login button with elevated design
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 4),  // Add a slight lift to the button
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,  // Button color
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),  // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                if (_errorMessage != null) ...[
                  SizedBox(height: 16.0),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
