import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:service_nest/ADMIN/viewpayment.dart';
import 'package:service_nest/colors.dart';

class AdminBookingDetailsPage extends StatelessWidget {
  const AdminBookingDetailsPage({Key? key}) : super(key: key);

  Stream<List<Map<String, dynamic>>> _fetchBookingsStream() {
    return FirebaseFirestore.instance.collection('Bookings').snapshots().asyncMap((snapshot) async {
      List<Map<String, dynamic>> bookings = [];

      // Collect all user detail fetch futures
      List<Future<Map<String, dynamic>?>> userDetailFutures = [];

      for (DocumentSnapshot bookingDoc in snapshot.docs) {
        Map<String, dynamic> booking = bookingDoc.data() as Map<String, dynamic>;
        userDetailFutures.add(_fetchUserDetails(booking['userId']).then((user) {
          if (user != null) {
            booking['user'] = user;
            booking['bookingId'] = bookingDoc.id;
            return booking;
          }
          return null;
        }));
      }

      // Wait for all user detail fetches to complete
      List<Map<String, dynamic>?> resolvedBookings = await Future.wait(userDetailFutures);

      // Filter out null results and return the final list
      bookings.addAll(resolvedBookings.where((booking) => booking != null).cast<Map<String, dynamic>>());

      return bookings;
    });
  }

  Future<Map<String, dynamic>?> _fetchUserDetails(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Registered Users').doc(userId).get();
    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All User Bookings'
          ,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 30,fontFamily: 'Lato'),
        ),
        backgroundColor: AppColors.c3,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchBookingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset("assets/images/loading.json"),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found.'));
          } else {
            List<Map<String, dynamic>> bookings = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> booking = bookings[index];
                Map<String, dynamic> user = booking['user'];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user['user name'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('Email: ${user['email'] ?? 'Unknown'}'),
                        SizedBox(height: 10),
                        Text('Service: ${booking['serviceName'] ?? 'Unknown'}'),
                        SizedBox(height: 10),
                        Text('Price: ${booking['price'] ?? 'Unknown'}'),
                        SizedBox(height: 10),
                        Text('Date: ${booking['selectedDate'] ?? 'Unknown'}'),
                        SizedBox(height: 10),
                        Text('Time: ${booking['selectedTime'] ?? 'Unknown'}'),
                        SizedBox(height: 10),
                        Text('Address: ${booking['address'] ?? 'Unknown'}'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentDetailsView(bookingId: booking['bookingId']),
                              ),
                            );
                          },
                          child: Text('View Payment Details'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
