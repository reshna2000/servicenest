import 'package:flutter/material.dart';
import 'package:service_nest/colors.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('About Us',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 30,fontFamily: 'Lato'),
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
                'About ServiceNest',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c4,
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'ServiceNest is a premier platform dedicated to connecting users with a diverse range of services, from home repairs and cleaning to professional consultations and more. Our mission is to streamline the process of finding and booking reliable service providers, ensuring a seamless and efficient experience for our users.',
                style: TextStyle(fontSize: 18, color: AppColors.c4),
              ),
              SizedBox(height: height * 0.03),
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c4,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Our mission at ServiceNest is to provide a trusted, efficient, and user-friendly platform that connects users with the best service providers in their area. We strive to make the process of finding and booking services as simple and hassle-free as possible.',
                style: TextStyle(fontSize: 18, color: AppColors.c4),
              ),
              SizedBox(height: height * 0.03),
              Text(
                'Our Values',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c4,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                '- Trust: We meticulously vet all our service providers to ensure they meet our high standards of quality and reliability.\n- Efficiency: Our platform is designed for ease of use, enabling users to find and book services quickly and conveniently.\n- User-Centric: We prioritize the needs and satisfaction of our users, continually enhancing our platform to meet their evolving requirements.',
                style: TextStyle(fontSize: 18, color: AppColors.c4),
              ),
              SizedBox(height: height * 0.03),
              Text(
                'Our Team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c4,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                'ServiceNest is powered by a dedicated team of professionals committed to enhancing the service booking experience. Our team works tirelessly to improve our platform, ensuring it meets the highest standards of quality and usability.',
                style: TextStyle(fontSize: 18, color: AppColors.c4),
              ),
              SizedBox(height: height * 0.03),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c4,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                'We are always here to assist and answer any questions you may have. Please reach out to us at contact@servicenest.com or call us at (123) 456-7890.',
                style: TextStyle(fontSize: 18, color: AppColors.c4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
