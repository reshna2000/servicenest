import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ADMIN/Admin_home.dart';
import '../USER/User_home.dart';

class SigninProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isobscuretext = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signin(BuildContext context) async {
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      isLoading = true;
      notifyListeners();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', email);
      await prefs.setString('password', password);

      // Clear the fields after successful sign-in
      clearFields();

      // Navigate based on user role
      if (email == 'admin@gmail.com' && password == 'admin@123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home_page(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UserHome(userID: userCredential.user!.uid),
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signin completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to signin: $e')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    isobscuretext = !isobscuretext;
    notifyListeners();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }
}
