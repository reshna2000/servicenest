import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:service_nest/ADMIN/Admin_home.dart';
import 'package:service_nest/USER/User_home.dart';
import 'package:service_nest/REGISTRATION/Signin.dart';

import '../colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isLoggedIn = prefs.getBool('isLoggedIn');
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');
      final user = FirebaseAuth.instance.currentUser;

      if (isLoggedIn == true && email != null && password != null && user != null) {
        if (email == 'admin@gmail.com' && password == 'admin@123') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Home_page(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserHome(userID: user.uid),
            ),
          );
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Signin(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c1,
      body: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: Image.asset(
            "assets/images/sn.png",
            height: 500,
            width: 500,
          ),
        ),
      ),
    );
  }
}
