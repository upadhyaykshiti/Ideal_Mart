import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../util/notification_helper.dart';
import 'shopping_list_screen.dart';

class EditCustomItemScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> item;

  const EditCustomItemScreen({required this.userId, required this.item});

  @override
  State<EditCustomItemScreen> createState() => _EditCustomItemScreenState();
}

class _EditCustomItemScreenState extends State<EditCustomItemScreen> {
  late TextEditingController titleController;
  late String repeatInterval;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item['title']);
    repeatInterval = widget.item['repeat_interval'];
    final timeParts = widget.item['reminder_time'].split(':');
    selectedTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
  }

  Future<void> saveChanges() async {
    final reminderTime = DateFormat('HH:mm').format(
      DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
    );

    final updatedItem = {
      "user_id": widget.userId,
      "title": titleController.text,
      "repeat_interval": repeatInterval,
      "reminder_time": reminderTime,
      "type": "custom",
      "status": "pending",
      "reminder_enabled": true,
    };

    await ApiService.updateShoppingItem(widget.item['_id'], updatedItem);

    // Reschedule notification
    final now = DateTime.now();
    DateTime scheduledDate = DateTime(
      now.year, now.month, now.day,
      selectedTime.hour, selectedTime.minute,
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
    final time = await showTimePicker(context: context, initialTime: selectedTime);
    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Custom Item")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Item Title"),
            ),
            DropdownButton<String>(
              value: repeatInterval,
              items: ['daily', 'weekly', 'monthly'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: (val) => setState(() => repeatInterval = val!),
            ),
            ElevatedButton(
              onPressed: pickTime,
              child: Text("Pick Reminder Time: ${selectedTime.format(context)}"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
