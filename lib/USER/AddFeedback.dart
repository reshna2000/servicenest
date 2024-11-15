import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ADMIN/viewFeedback.dart';
import '../colors.dart';

class AddFeedback extends StatefulWidget {
  const AddFeedback({super.key});

  @override
  State<AddFeedback> createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final CollectionReference feedbacks = FirebaseFirestore.instance.collection('feedbacks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c1,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Your Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Your Feedback',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String feedbackMessage = _feedbackController.text;
                String name = _nameController.text;
                String email = _emailController.text;

                // Add data to Firestore
                await feedbacks.add({
                  'name': name,
                  'email': email,
                  'feedback': feedbackMessage,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                // Clear the text fields after submission
                _feedbackController.clear();
                _nameController.clear();
                _emailController.clear();

                // Optional: Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Feedback Submitted')),
                );
              },
              child: Text("Submit"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewFeedback()),
                );
              },
              child: Text("View Feedback"),
            ),
          ],
        ),
      ),
    );
  }
}
