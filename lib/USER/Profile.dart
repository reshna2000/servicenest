import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_nest/USER/About.dart';
import 'package:service_nest/USER/contactus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors.dart';
import 'Account.dart';
import '../REGISTRATION/Signin.dart';
import 'cart.dart';

class Profile extends StatefulWidget {
  final String userID;

  const Profile({super.key, required this.userID});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('email');
    await prefs.remove('password');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Signin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.c2,
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Log Out"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _signOut(context);
                        },
                        child: Text(
                          "Log Out",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          )
        ],
      ),
      body:Builder(
        builder: (context) {
          print('Profile Page userID: ${widget.userID}');

          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Registered Users')
                .doc(widget.userID)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print('Firestore error: ${snapshot.error}');
                return Center(
                    child: Text("Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red)));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                print('No user data found');
                return const Center(
                    child: Text("User not found",
                        style: TextStyle(color: Colors.red)));
              }

              var userData = snapshot.data!.data();
              if (userData == null) {
                print('User data is null');
                return const Center(
                    child: Text("User data is empty",
                        style: TextStyle(color: Colors.red)));
              }

              String username = userData['user name'] ?? 'No username';
              String email = userData['email'] ?? 'No email';
              String? profileImageUrl = userData['profile_image'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.30,
                        width: screenWidth,
                        decoration: const BoxDecoration(
                          color: AppColors.c2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0, top: 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: profileImageUrl != null
                                    ? NetworkImage(profileImageUrl)
                                    : null,
                                child: profileImageUrl == null
                                    ? const Icon(Icons.add_a_photo,
                                    color: Colors.black)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hello, $username",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 24)),
                                Text(email,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.18),
                        child: Container(
                          height: screenHeight * 0.60,
                          width: screenWidth,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              topLeft: Radius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text("Account"),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios, size: 15),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Account(userID: widget.userID)),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.event_note_sharp),
                                  title: Text("Bookings"),
                                  trailing:
                                  Icon(Icons.arrow_forward_ios, size: 15),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserBookingsPage())
                                    );
                                  },
                                ),
                                // ListTile(
                                //   leading: Icon(Icons.headset_mic_outlined),
                                //   title: Text("Help Center"),
                                //   trailing:
                                //   Icon(Icons.arrow_forward_ios, size: 15),
                                //   // onTap: () {
                                //   //   Navigator.push(
                                //   //       context,
                                //   //       MaterialPageRoute(
                                //   //           builder: (context) =>
                                //   //               UserBookingsPage()));
                                //   // },
                                // ),
                                ListTile(
                                  leading: Icon(Icons.phone),
                                  title: Text("Contact"),
                                  trailing:
                                  Icon(Icons.arrow_forward_ios, size: 15),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                               ContactUsPage()));
                                  },
                                ),
                            ListTile(
                                  leading: Icon(Icons.info),
                                  title: Text("About"),
                                  trailing:
                                  Icon(Icons.arrow_forward_ios, size: 15),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AboutUsPage()));
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.logout),
                                  title: Text("Log Out"),
                                  trailing:
                                  Icon(Icons.arrow_forward_ios, size: 15),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Log Out"),
                                          content: Text(
                                              "Are you sure you want to log out?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                _signOut(context);// Call sign out function
                                              },
                                              child: Text(
                                                "Log Out",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
