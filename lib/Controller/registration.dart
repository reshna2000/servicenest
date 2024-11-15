import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../REGISTRATION/Signin.dart';

class RegistrationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  bool isobscuretext = true;
  bool isobscuretext1 = true;
  String? selectedState;

  final List<String> states = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana',
    'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
    'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand',
    'West Bengal', 'Andaman and Nicobar Islands', 'Chandigarh', 'Dadra and Nagar Haveli', 'Daman and Diu', 'Lakshadweep', 'Delhi',
    'Puducherry'
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> register({
    required BuildContext context,
  }) async {
    String email = emailController.text.trim();
    String username = usernameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('Registered Users').doc(userCredential.user!.uid).set({
        "email": email,
        "user name": username,
        "place": selectedState ?? '',
        "phoneno": phone,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );

      clearFields();

      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedState(String? state) {
    selectedState = state;
    notifyListeners();
  }

  void togglePasswordVisibility1() {
    isobscuretext1 = !isobscuretext1;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isobscuretext = !isobscuretext;
    notifyListeners();
  }

  void clearFields() {
    emailController.clear();
    usernameController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    selectedState = null;
    notifyListeners();
  }
}
