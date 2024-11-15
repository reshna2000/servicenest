import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:service_nest/colors.dart';
import 'package:intl/intl.dart';  // Add this import for date formatting

class UserBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Bookings'),
          backgroundColor: AppColors.c2,
        ),
        body: Center(
          child: Text('No user is logged in.'),
        ),
      );
    }

    Future<void> deleteBooking(String documentId) async {
      await FirebaseFirestore.instance.collection('Bookings').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Cancelled')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        backgroundColor: AppColors.c2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Bookings')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset("assets/images/loading.json"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Lottie.asset("assets/images/booknw.json"),
            );
          }

          DateTime now = DateTime.now();
          List<DocumentSnapshot> validBookings = snapshot.data!.docs.where((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            DateTime bookingDateTime = DateTime.parse("${data['selectedDate']} ${data['selectedTime']}");
            return bookingDateTime.isAfter(now);
          }).toList();

          if (validBookings.isEmpty) {
            return Center(
              child: Lottie.asset("assets/images/booknw.json"),
            );
          }

          return ListView(
            children: validBookings.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    data['serviceName'] ?? 'Unknown Service',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Price: ',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            '₹${data['price']}',
                            style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        'Date: ${data['selectedDate']}',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Time: ${data['selectedTime']}',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Address: ${data['address']}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  // Uncomment this part if you want to add a cancel button
                  // trailing: ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.c1,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  //   child: Text(
                  //     "Cancel ",
                  //     style: TextStyle(color: Colors.red, fontSize: 20, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                  //   ),
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AlertDialog(
                  //           title: Text("Delete Service"),
                  //           content: Text("Are you sure you want to delete this Booked service?"),
                  //           actions: [
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.of(context).pop(); // Close the dialog
                  //               },
                  //               child: Text("Cancel"),
                  //             ),
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.of(context).pop();
                  //                 deleteBooking(document.id);
                  //               },
                  //               child: Text(
                  //                 "Delete",
                  //                 style: TextStyle(color: Colors.red),
                  //               ),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
