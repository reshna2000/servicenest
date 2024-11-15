import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'otp_main.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  Stream<DocumentSnapshot> _getUserStream() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      return _firestore.collection('Registered Users').doc(currentUser.uid).snapshots();
    }
    throw Exception("User not logged in");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFbcacd4),
      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: const Color(0xFFbcacd4),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _getUserStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error fetching data"));
            } else if (snapshot.hasData) {
              var userDocument = snapshot.data!;
              phoneController.text = userDocument['phoneno'] ?? '';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                            color: Color(0xFF431a74)
                          )
                        ),
                        hintText: "Enter Phone Number",
                        suffixIcon: const Icon(Icons.phone),
                        prefixText: "+91 ",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:BorderSide(
                              color: Color(0xFF431a74)

                          )
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF431a74)
                    ),
                    onPressed: () async {
                      String phoneNumber = '+91' + phoneController.text.trim();
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phoneNumber,
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException ex) {
                          print('Verification failed: ${ex.message}');
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => otp(verificationid: verificationId),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: const Text("Send OTP",style: TextStyle(color:Color(0xFFbcacd4)),),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }
}
