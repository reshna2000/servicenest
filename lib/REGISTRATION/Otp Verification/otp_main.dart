// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:service_nest/ADMIN/Admin_home.dart';
// import 'package:service_nest/USER/User_home.dart';
//
// import '../../USER/Profile.dart';
//
// class otp extends StatefulWidget {
//   String verificationid;
//   otp({super.key, required this.verificationid});
//
//   @override
//   State<otp> createState() => _otpState();
// }
//
// class _otpState extends State<otp> {
//   TextEditingController otpController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFbcacd4),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFbcacd4),
//         automaticallyImplyLeading: false,
//         // title: Text("OTP Screen"),
//         // centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                   hintText: "Enter the otp",
//                   focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide:BorderSide(
//                       color: Color(0xFF431a74)
//                   )
//                   ),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide(
//                         color: Color(0xFF431a74)
//                     )
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF431a74)
//               ),
//               onPressed: () async {
//                 try {
//                   PhoneAuthCredential credential =
//                   await PhoneAuthProvider.credential(
//                       verificationId: widget.verificationid,
//                       smsCode: otpController.text.toString());
//                   FirebaseAuth.instance.signInWithCredential(credential).then((value) {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) =>
//                             UserHome(userID: '')));
//                   });
//                 }
//                 catch (ex) {
//                   log(ex.toString());
//                 }
//               },
//               child: Text("VERIFY",style: TextStyle(color:Color(0xFFbcacd4)),))
//         ],
//       ),
//     );
//   }
// }


import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:service_nest/ADMIN/Admin_home.dart';
import 'package:service_nest/USER/User_home.dart';

class otp extends StatefulWidget {
  final String verificationid;
  otp({super.key, required this.verificationid});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  TextEditingController otpController = TextEditingController();

  Future<void> navigateBasedOnRole(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Registered Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        var role = userDoc['role']; // Assuming the role is stored in 'role' field

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home_page()),
          );
        } else if (role == 'user') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserHome(userID: userId)),
          );
        } else {
          // Handle unknown role
          log('Unknown role: $role');
        }
      } else {
        // Handle user document not found
        log('User document not found');
      }
    } catch (e) {
      log('Error fetching user document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFbcacd4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFbcacd4),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter the OTP",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Color(0xFF431a74)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Color(0xFF431a74)),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF431a74)),
            onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationid,
                  smsCode: otpController.text.trim(),
                );

                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithCredential(credential);

                String userId = userCredential.user?.uid ?? '';

                if (userId.isNotEmpty) {
                  await navigateBasedOnRole(userId);
                } else {
                  log('User ID is empty');
                }
              } catch (ex) {
                log('Error during OTP verification: $ex');
              }
            },
            child: Text(
              "VERIFY",
              style: TextStyle(color: Color(0xFFbcacd4)),
            ),
          ),
        ],
      ),
    );
  }
}
