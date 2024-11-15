import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_nest/USER/ordersplash.dart';
import '../colors.dart';
import 'Service/bottomsheet2.dart';

class PaymentPage extends StatefulWidget {
  final String serviceId;
  final String bookingId;

  PaymentPage({
    required this.serviceId,
    required this.bookingId,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String, dynamic>? bookingDetails;
  String? selectedPaymentOption;

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  void fetchBookingDetails() async {
    try {
      DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance.collection('Bookings').doc(widget.bookingId).get();

      if (bookingSnapshot.exists) {
        setState(() {
          bookingDetails = bookingSnapshot.data() as Map<String, dynamic>;
        });
      } else {
        print('Booking not found!');
      }
    } catch (e) {
      print('Error fetching booking details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c3,
        title: Text('Payment', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30, fontFamily: 'Lato')),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingBottomSheet1(bookingDetails: {})));
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: bookingDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Price: \$${bookingDetails!['price']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildPaymentOption(
              title: 'Google Pay',
              imagePath: 'assets/images/gpay.jpg',
            ),
            SizedBox(height: 20),
            buildPaymentOption(
              title: 'Paytm',
              imagePath: 'assets/images/paytm.png',
            ),
            SizedBox(height: 20),
            buildPaymentOption(
              title: 'PhonePe',
              imagePath: 'assets/images/phonepe.png',
            ),
            SizedBox(height: 20),
            buildPaymentOption(
              title: 'Cash on Delivery',
              imagePath: 'assets/images/cod.png',
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.c4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: selectedPaymentOption == null ? null : _completePayment,
                child: Text(
                  'Proceed to Pay',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentOption({required String title, required String imagePath}) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: ListTile(
          leading: Image.asset(imagePath, width: 50, height: 50),
          title: Text(title),
          trailing: Radio<String>(
            value: title,
            groupValue: selectedPaymentOption,
            onChanged: (value) {
              setState(() {
                selectedPaymentOption = value;
              });
            },
          ),
        ),
      ),
    );
  }

  void _completePayment() async {
    try {
      String status = selectedPaymentOption == 'Cash on Delivery' ? 'pending' : 'paid';
      Timestamp timestamp = Timestamp.now();

      await FirebaseFirestore.instance.collection('Bookings').doc(widget.bookingId).update({
        'status': status,
        'paymentMethod': selectedPaymentOption,
        'paymenttimestamp': timestamp,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment Successful!'),
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            paymentMethod: selectedPaymentOption!,
            paymentTimestamp: timestamp,
          ),
        ),
      );
    } catch (e) {
      print('Error completing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment Failed. Please try again.'),
      ));
    }
  }
}
