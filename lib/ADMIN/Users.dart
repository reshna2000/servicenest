import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../REGISTRATION/Signin.dart';

class Full extends StatefulWidget {
  const Full({Key? key});

  @override
  State<Full> createState() => _FullState();
}

class _FullState extends State<Full> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8d74af),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Registered Users",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontFamily: 'Lato',fontSize: 30),),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Signin(),));
          }, icon: Icon(Icons.logout))
        ],
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Registered Users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(
                child: Lottie.asset("assets/images/loading.json")
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              String username = data['user name'] ?? 'Unknown';
              String email = data['email'] ?? 'Unknown';
              String place = data['place'] ?? 'Unknown';
              String phone = data['phoneno'] ?? 'Unknown';

              if (email == 'admin@gmail.com') {
                return Container();
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color:  Color(0xFFbcacd4),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(username,style: TextStyle(fontSize: 30,fontFamily: 'Lato',color: Colors.black),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: $email',style: TextStyle(fontSize: 15,color: Colors.black),),
                      Text('Place: $place',style: TextStyle(fontSize: 15,color: Colors.black),),
                      Text('Phone: $phone',style: TextStyle(fontSize: 15,color: Colors.black),),
                    ],
                  ),
                ),
              );
            }).toList().where((widget) => widget != Container()).toList(),
          );
        },
      ),
    );
  }
}
