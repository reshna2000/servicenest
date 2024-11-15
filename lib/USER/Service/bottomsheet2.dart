import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Payment.dart';
import 'package:service_nest/colors.dart';
import 'package:intl/intl.dart';

class BookingBottomSheet1 extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;

  BookingBottomSheet1({required this.bookingDetails});

  @override
  _BookingBottomSheet1State createState() => _BookingBottomSheet1State();
}

class _BookingBottomSheet1State extends State<BookingBottomSheet1> {
  TextEditingController _addressController = TextEditingController();

  Future<void> _submitBooking() async {
    if (_addressController.text.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Map<String, dynamic> booking = {
            'userId': user.uid,
            'serviceName': widget.bookingDetails['serviceName'],
            'price': widget.bookingDetails['price'],
            'selectedDate': widget.bookingDetails['selectedDate'].toIso8601String(),
            'selectedTime': widget.bookingDetails['selectedTime'].format(context),
            'address': _addressController.text,
            'timestamp': Timestamp.now(),
          };

          DocumentReference bookingRef = await FirebaseFirestore.instance.collection('Bookings').add(booking);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Booking confirmed for ${DateFormat.yMd().format(widget.bookingDetails['selectedDate'])} at ${widget.bookingDetails['selectedTime'].format(context)}'),
          ));
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentPage(serviceId: bookingRef.id, bookingId: bookingRef.id,),
              ),
            );
          });
        } else {
          print("No user is logged in.");
        }
      } catch (e) {
        print("Error saving booking: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error saving booking: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter the address.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 400,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.c1,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addressController,
              maxLines: 4,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                hintText: 'Address',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.c4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _submitBooking,
              child: Text(
                'Confirm Booking',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
