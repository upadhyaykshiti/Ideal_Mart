
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_custom_item_screen.dart';
import 'edit_custom_item_screen.dart';
import '../util/notification_helper.dart';

class ShoppingListScreen extends StatefulWidget {
  final String userId;
  const ShoppingListScreen({required this.userId});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<dynamic> items = [];
  List<dynamic> predefined = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final userItems = await ApiService.fetchShoppingItems(widget.userId);
    final defaults = await ApiService.fetchPredefinedItems();
    setState(() {
      items = userItems;
      predefined = defaults;
      loading = false;
    });
  }

  Future<void> addPredefinedItem(dynamic item) async {
    final newItem = {
      ...item,
      "user_id": widget.userId,
      "status": "pending",
      "reminder_enabled": true,
    };
    await ApiService.addShoppingItem(newItem.cast<String, dynamic>());
    fetchData();
  }

  Future<void> removeItem(String itemId) async {
    final item = items.firstWhere((i) => i['_id'] == itemId);
    await ApiService.deleteShoppingItem(itemId);
    await NotificationHelper.cancelNotificationByTitle(item['title']);
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping List")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                Text("Your Shopping List", style: TextStyle(fontSize: 18)),
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item['title']),
                        subtitle: Text(
                          "Remind at ${item['reminder_time']} (${item['repeat_interval']})",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCustomItemScreen(
                                      userId: widget.userId,
                                      item: item,
                                    ),
                                  ),
                                ).then((_) => fetchData());
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => removeItem(item['_id']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const Divider(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCustomItemScreen(userId: widget.userId),
                      ),
                    ).then((_) => fetchData()), 
                    child: Text("➕ Add Custom Item"),
                  ),
                ),

                Text("Predefined Items", style: TextStyle(fontSize: 18)),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: predefined.length,
                    itemBuilder: (context, index) {
                      final item = predefined[index];
                      return ListTile(
                        title: Text(item['title']),
                        trailing: ElevatedButton(
                          onPressed: () => addPredefinedItem(item),
                          child: Text("Add"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
