import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../colors.dart';
import 'bottom sheet.dart';

class ServiceDetail extends StatelessWidget {
  final Map<String, dynamic> data;

  const ServiceDetail({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: AppColors.c2,
        title: Text(
          data['service'],
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.favorite_border, color: Colors.white),
        //     onPressed: () {
        //       // Logic to add to favorites
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text('Added to favorites')),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.containsKey('imageUrl') && data['imageUrl'].isNotEmpty)
                CachedNetworkImage(
                  imageUrl: data['imageUrl'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => SizedBox.shrink(),
                ),
              SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(data['description'], style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text(
                'Price:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('\$${data['price']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text(
                'Availability:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Monday - Friday: 9:00 AM - 6:00 PM',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Saturday: 10:00 AM - 4:00 PM',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Sunday: Closed',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Ratings:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star_half, color: Colors.amber, size: 20),
                  Icon(Icons.star_border, color: Colors.amber, size: 20),
                  SizedBox(width: 10),
                  Text('3.5', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Service Provider:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Provider Name: XYZ Services',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Experience: 10 years in the industry',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Contact: (123) 456-7890',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.c2,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return BookingBottomSheet(
                          serviceName: data['service'],
                          price: data['price'],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Book Slot',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
