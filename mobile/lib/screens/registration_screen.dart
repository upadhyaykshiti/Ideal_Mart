

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'shopping_list_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  // void register() async {
  //   try {
  //     await ApiService.registerUser(nameController.text, emailController.text);

  //     // ✅ Store user ID in SharedPreferences
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString('userId', emailController.text); // Assuming email is unique ID

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("User registered")),
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ShoppingListScreen(userId: emailController.text),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Registration failed")),
  //     );
  //   }
  // }

void register() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim();

  if (name.isEmpty || email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter both name and email")),
    );
    return;
  }

  try {
    final userId = await ApiService.registerUser(name, email); // ✅ returns _id
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId); // ✅ storing ObjectId

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ShoppingListScreen(userId: userId),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registration failed")),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
