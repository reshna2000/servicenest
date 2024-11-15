import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Account extends StatefulWidget {
  final String userID;

  const Account({super.key, required this.userID});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(widget.userID);
      final uploadTask = storageRef.putFile(_image!);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('Registered Users')
          .doc(widget.userID)
          .update({
        'profile_image': downloadUrl,
      });

      setState(() {});
    } catch (e) {
      print("Failed to upload image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    }
  }

  Future<void> _deleteImage() async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(widget.userID);

      await storageRef.delete();

      await FirebaseFirestore.instance
          .collection('Registered Users')
          .doc(widget.userID)
          .update({
        'profile_image': FieldValue.delete(),
      });

      setState(() {
        _image = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile image deleted successfully")),
      );
    } catch (e) {
      print("Failed to delete image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete image: $e")),
      );
    }
  }

  Future<void> _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('Registered Users')
            .doc(widget.userID)
            .update({
          'user name': _usernameController.text,
          'email': _emailController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
      } catch (e) {
        print("Failed to update user info: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb7a7de),
      appBar: AppBar(
        backgroundColor: Color(0xFF8d74af),
        title: Text(
          "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 30,fontFamily: 'Lato'),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Registered Users')
              .doc(widget.userID)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text("Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red)));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                  child: Text("User not found",
                      style: TextStyle(color: Colors.red)));
            }

            var userData = snapshot.data!.data();
            if (userData == null) {
              return const Center(
                  child: Text("User data is empty",
                      style: TextStyle(color: Colors.red)));
            }

            _usernameController.text = userData['user name'] ?? 'No username';
            _emailController.text = userData['email'] ?? 'No email';
            String? profileImageUrl = userData['profile_image'];

            return Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(Icons.add_a_photo, color: Colors.black)
                        : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("Change Profile Image"),
                  ),
                  if (profileImageUrl != null)
                    ElevatedButton(
                      onPressed: _deleteImage,
                      child: Text("Delete Profile Image"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _updateUserInfo,
                            child: Text("Update Profile"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
