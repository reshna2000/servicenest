import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../colors.dart';

class CategoryInputPage extends StatefulWidget {
  @override
  _CategoryInputPageState createState() => _CategoryInputPageState();
}

class _CategoryInputPageState extends State<CategoryInputPage> {
  final TextEditingController _categoryController = TextEditingController();

  void _addCategory() async {
    String category = _categoryController.text.trim();
    if (category.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('Categories').add({
          'name': category,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Category added successfully.'),
        ));
        _categoryController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add category: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c3,

        title: Text('Add Category'          ,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 30,fontFamily: 'Lato'),
        ),
      ),
      backgroundColor: AppColors.c1,

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                hintText: 'Enter category name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCategory,
              child: Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
