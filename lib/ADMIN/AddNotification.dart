import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../colors.dart';

class AddNotification extends StatefulWidget {
  const AddNotification({super.key});

  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference notifications = FirebaseFirestore.instance.collection('notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notification'
          ,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 30,fontFamily: 'Lato'),
        ),
        backgroundColor: AppColors.c3,
      ),
      backgroundColor: AppColors.c1,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Offer Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Offer Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Add Notification',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String notificationMessage = _messageController.text;
                  String offerTitle = _titleController.text;
                  String offerDescription = _descriptionController.text;
        
                  // Add data to Firestore
                  await notifications.add({
                    'title': offerTitle,
                    'description': offerDescription,
                    'message': notificationMessage,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
        
                  // Clear the text fields after submission
                  _messageController.clear();
                  _titleController.clear();
                  _descriptionController.clear();
        
                  // Optional: Show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notification Added')),
                  );
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
