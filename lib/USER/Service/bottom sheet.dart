import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_nest/colors.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'bottomsheet2.dart'; // Import the booking bottom sheet 1

class BookingBottomSheet extends StatefulWidget {
  final String serviceName;
  final String price;

  BookingBottomSheet({required this.serviceName, required this.price});

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  DateTime dateTime = DateTime.now();
  DateTime selectedDate = DateTime.now();

  void _proceedToAddress() {
    final bookingDetails = {
      'serviceName': widget.serviceName,
      'price': widget.price,
      'selectedDate': selectedDate,
      'selectedTime': TimeOfDay(hour: dateTime.hour, minute: dateTime.minute), // Save only time part
    };

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BookingBottomSheet1(bookingDetails: bookingDetails);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: 400,
        width: 400,
        decoration: BoxDecoration(
          color: AppColors.c1,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Text(
              "Select Date And Time",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 100,
              child: DatePicker(
                DateTime.now(),
                initialSelectedDate: DateTime.now(),
                selectionColor: AppColors.c4,
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  if (date.isBefore(DateTime.now())) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please select a future date.'),
                    ));
                  } else {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 30),
            TimePickerSpinner(
              locale: const Locale('en', ''),
              time: dateTime,
              is24HourMode: false,
              itemHeight: 30,
              itemWidth: 50,
              normalTextStyle: const TextStyle(
                fontSize: 20,
              ),
              highlightedTextStyle: const TextStyle(fontSize: 24, color: AppColors.c4),
              isForce2Digits: true,
              onTimeChange: (time) {
                setState(() {
                  dateTime = time;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.c4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _proceedToAddress,
              child: Text(
                'Proceed to CheckOut',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
