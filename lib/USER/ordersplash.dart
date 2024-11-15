import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:service_nest/USER/User_home.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String paymentMethod;
  final Timestamp paymentTimestamp;

  PaymentSuccessPage({
    required this.paymentMethod,
    required this.paymentTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showPaymentSuccessDialog(context);
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // This will be shown while the dialog is displayed
      ),
    );
  }

  Future<void> _showPaymentSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: Column(
            children: [
              // Lottie.asset("assets/images/payment.json"),
              Icon(Icons.done_outline_rounded, color: Colors.white, size: 40),
              Text('Payment Successful', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your payment was successful!', style: TextStyle(color: Colors.white)),
                SizedBox(height: 20),
                Text('Payment Method: $paymentMethod', style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                Text('Payment Time: ${paymentTimestamp.toDate().toString()}', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserHome(userID: user.uid),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
