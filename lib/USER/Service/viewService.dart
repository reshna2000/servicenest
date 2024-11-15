import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:service_nest/USER/Service/viewservice2.dart';
import '../../colors.dart';

class ServiceAdd extends StatefulWidget {
  const ServiceAdd({Key? key}) : super(key: key);

  @override
  State<ServiceAdd> createState() => _ServiceAddState();
}

class _ServiceAddState extends State<ServiceAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            // Handle back button press if needed
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: AppColors.c2,
        title: Text(
          "Service Types",
          style: TextStyle(fontFamily: 'Lato', fontSize: 30, color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check screen width to determine number of columns
          int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('service').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset("assets/images/loading.json"),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No Service available'),
                );
              }

              var types = snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return data['type'];
              }).toSet().toList();

              if (types.isEmpty) {
                return Center(
                  child: Text(
                    'No service available',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Schyler1',
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: types.length,
                itemBuilder: (context, index) {
                  var type = types[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          type,
                          style: TextStyle(
                            fontFamily: 'Schyler1',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('service')
                            .where('type', isEqualTo: type)
                            .snapshots(),
                        builder: (context, serviceSnapshot) {
                          if (serviceSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (serviceSnapshot.hasError) {
                            return Center(
                              child: Text('Error: ${serviceSnapshot.error}'),
                            );
                          }

                          if (!serviceSnapshot.hasData || serviceSnapshot.data!.docs.isEmpty) {
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('No $type service available'),
                                ),
                              );
                            });
                            return SizedBox.shrink(); // Skip rendering children
                          }

                          var services = serviceSnapshot.data!.docs;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.8, // Adjust this ratio as needed
                            ),
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              var service = services[index];
                              var data = service.data() as Map<String, dynamic>;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ServiceDetail(data: data),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (data.containsKey('imageUrl') && data['imageUrl'].isNotEmpty)
                                        Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            image: DecorationImage(
                                              image: NetworkImage(data['imageUrl']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        data['service'] ?? 'Unknown Service',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
