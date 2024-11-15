import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:service_nest/colors.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'          ,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 30,fontFamily: 'Lato'),
        ),
        backgroundColor: AppColors.c3,
      ),
      backgroundColor: AppColors.c1,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/sn.png",
                  scale: 3,
                ),
              ),
              SizedBox(height: height * 0.03),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c4,
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'We are here to assist you with any questions or concerns you may have. Please feel free to reach out to us through any of the following contact methods.',
                style: TextStyle(fontSize: 18, color: AppColors.c4),
              ),
              SizedBox(height: height * 0.03),
              Text(
                'Phone:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c4,
                ),
              ),
              SizedBox(height: height * 0.01),
              InkWell(
                onTap: () async {
                  const phoneNumber = 'tel:+1234567890';
                  if (await canLaunch(phoneNumber)) {
                    await launch(phoneNumber);
                  } else {
                    throw 'Could not launch $phoneNumber';
                  }
                },
                child: Text(
                  '+123 456 7890',
                  style: TextStyle(fontSize: 18, color: AppColors.c4, decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: height * 0.03),
              Text(
                'Email:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c4,
                ),
              ),
              SizedBox(height: height * 0.01),
              InkWell(
                onTap: () async {
                  const emailAddress = 'mailto:contact@servicenest.com';
                  if (await canLaunch(emailAddress)) {
                    await launch(emailAddress);
                  } else {
                    throw 'Could not launch $emailAddress';
                  }
                },
                child: Text(
                  'contact@servicenest.com',
                  style: TextStyle(fontSize: 18, color: AppColors.c4, decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: height * 0.03),
              Text(
                'Address:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c4,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                '123 ServiceNest Lane\nCity, State, 12345',
                style: TextStyle(fontSize: 18, color: AppColors.c4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
