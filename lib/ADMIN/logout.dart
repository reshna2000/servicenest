import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_nest/REGISTRATION/Signin.dart';
import 'package:firebase_auth/firebase_auth.dart';

void logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear all stored data

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Signin()),
  );
}
