// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../services/api_service.dart';
// import 'shopping_list_screen.dart';
// import '../util/notification_helper.dart';

// class AddCustomItemScreen extends StatefulWidget {
//   final String userId;
//   const AddCustomItemScreen({required this.userId});

//   @override
//   State<AddCustomItemScreen> createState() => _AddCustomItemScreenState();
// }

// class _AddCustomItemScreenState extends State<AddCustomItemScreen> {
//   final titleController = TextEditingController();
//   String repeatInterval = 'daily';
//   TimeOfDay selectedTime = TimeOfDay.now();

//   Future<void> saveItem() async {
//     final reminderTime = DateFormat('HH:mm').format(
//       DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
//     );

//     final newItem = {
//       "user_id": widget.userId,
//       "title": titleController.text,
//       "repeat_interval": repeatInterval,
//       "reminder_time": reminderTime,
//       "type": "custom",
//       "status": "pending",
//       "reminder_enabled": true,
//     };

//     await ApiService.addShoppingItem(newItem);

//     // 🛎️ Schedule local notification
//     final now = DateTime.now();
//     final scheduledDate = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       selectedTime.hour,
//       selectedTime.minute,
//     );
//     await NotificationHelper.scheduleNotification(
//       titleController.text,
//       scheduledDate,
//     );

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => ShoppingListScreen(userId: widget.userId)),
//     );
//   }

//   Future<void> pickTime() async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//     if (time != null) {
//       setState(() => selectedTime = time);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add Custom Item")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(labelText: "Item Title"),
//             ),
//             DropdownButton<String>(
//               value: repeatInterval,
//               items: ['daily', 'weekly', 'monthly']
//                   .map((val) => DropdownMenuItem(value: val, child: Text(val)))
//                   .toList(),
//               onChanged: (val) => setState(() => repeatInterval = val!),
//             ),
//             ElevatedButton(
//               onPressed: pickTime,
//               child: Text("Pick Reminder Time: ${selectedTime.format(context)}"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: saveItem,
//               child: Text("Save"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'shopping_list_screen.dart';
import '../util/notification_helper.dart';

class AddCustomItemScreen extends StatefulWidget {
  final String userId;
  const AddCustomItemScreen({required this.userId});

  @override
  State<AddCustomItemScreen> createState() => _AddCustomItemScreenState();
}

class _AddCustomItemScreenState extends State<AddCustomItemScreen> {
  final titleController = TextEditingController();
  String repeatInterval = 'daily';
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> saveItem() async {
    final reminderTime = DateFormat('HH:mm').format(
      DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
    );

    final newItem = {
      "user_id": widget.userId,
      "title": titleController.text,
      "repeat_interval": repeatInterval,
      "reminder_time": reminderTime,
      "type": "custom",
      "status": "pending",
      "reminder_enabled": true,
    };

    await ApiService.addShoppingItem(newItem, custom: true);

    final now = DateTime.now();
    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    await NotificationHelper.scheduleRepeatingNotification(
      title: titleController.text,
      scheduledTime: scheduledDate,
      repeatInterval: repeatInterval,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ShoppingListScreen(userId: widget.userId),
      ),
    );
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Custom Item")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Item Title"),
              ),
              DropdownButton<String>(
                value: repeatInterval,
                items: ['daily', 'weekly', 'monthly']
                    .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) => setState(() => repeatInterval = val!),
              ),
              ElevatedButton(
                onPressed: pickTime,
                child: Text("Pick Reminder Time: ${selectedTime.format(context)}"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveItem,
                child: Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
