

// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ApiService {
//   static const baseUrl = "http://127.0.0.1:8000";

//   static Future<void> registerUser(String name, String email) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/register"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"name": name, "email": email}),
//     );
//     if (response.statusCode != 200) {
//       throw Exception("Failed to register");
//     }
//   }

//   static Future<List<dynamic>> fetchShoppingItems(String userId) async {
//     final response = await http.get(Uri.parse("$baseUrl/shopping-items/$userId"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to load shopping items");
//     }
//   }

//   static Future<void> addShoppingItem(Map<String, dynamic> item) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/shopping-items"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(item),
//     );
//     if (response.statusCode != 200) {
//       throw Exception("Failed to add item");
//     }
//   }

//   static Future<void> deleteShoppingItem(String itemId) async {
//     final response = await http.delete(Uri.parse("$baseUrl/shopping-items/$itemId"));
//     if (response.statusCode != 200) {
//       throw Exception("Failed to delete item");
//     }
//   }

//   static Future<List<dynamic>> fetchPredefinedItems() async {
//     final response = await http.get(Uri.parse("$baseUrl/predefined-items"));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to load predefined items");
//     }
//   }
// }

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const baseUrl = "http://127.0.0.1:8000";

  static Future<String> registerUser(String name, String email) async {
  final response = await http.post(
    Uri.parse("$baseUrl/register"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"name": name, "email": email}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['user_id']; // ✅ Now use real user_id
  } else {
    throw Exception("Failed to register");
  }
}


  // // Register a new user
  // static Future<void> registerUser(String name, String email) async {
  //   final response = await http.post(
  //     Uri.parse("$baseUrl/register"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"name": name, "email": email}),
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception("Failed to register");
  //   }
  // }

  // Fetch shopping items for a specific user
  static Future<List<dynamic>> fetchShoppingItems(String userId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/shopping-items/$userId"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load shopping items");
    }
  }

  // Add a new shopping item (predefined or custom)
  static Future<void> addShoppingItem(
    Map<String, dynamic> item, {
    bool custom = false,
  }) async {
    final endpoint = custom ? "/shopping-items/custom" : "/shopping-items";
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(item),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to add item");
    }
  }

  // Update an existing shopping item
  static Future<void> updateShoppingItem(
    String itemId,
    Map<String, dynamic> updatedData,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/shopping-items/$itemId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedData),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update item");
    }
  }

  // Delete a shopping item by ID
  static Future<void> deleteShoppingItem(String itemId) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/shopping-items/$itemId"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete item");
    }
  }

  // Fetch predefined shopping items (from local DB or config)
  static Future<List<dynamic>> fetchPredefinedItems() async {
    final response = await http.get(Uri.parse("$baseUrl/predefined-items"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load predefined items");
    }
  }
}

