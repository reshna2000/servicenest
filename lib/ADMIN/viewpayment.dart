import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentDetailsView extends StatelessWidget {
  final String bookingId;

  const PaymentDetailsView({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF8d74af),
        title: const Text(
          "Payment Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 30,fontFamily: 'Lato'),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Bookings').doc(bookingId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No payment details found'));
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          String paymentMethod = data['paymentMethod'] ?? 'Unknown';
          String status = data['status'] ?? 'Unknown';
          String paymentTimestamp = (data['paymenttimestamp'] != null)
              ? data['paymenttimestamp'].toDate().toString()
              : 'Unknown';

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Method: $paymentMethod'),
                  Text('Status: $status'),
                  Text('Payment Time: $paymentTimestamp'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
