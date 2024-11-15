// import 'package:flutter/material.dart';
// import 'package:service_nest/REGISTRATION/Signin.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../USER/User_home.dart';
//
// class sharedpref extends StatefulWidget {
//   const sharedpref({super.key});
//
//   @override
//   State<sharedpref> createState() => _sharedprefState();
// }
//
// class _sharedprefState extends State<sharedpref> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//     if (isLoggedIn) {
//       String? userId = prefs.getString('userId');
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => UserHome(userID: ''),
//         ),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Signin(),
//         ),
//       );
//     }
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CircularProgressIndicator(
//             backgroundColor: Colors.green,
//           )
//         ],
//       ),
//     );
//
//   }
// }
