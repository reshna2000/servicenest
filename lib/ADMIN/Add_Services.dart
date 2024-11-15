import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../colors.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final TextEditingController servicenameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? _selectedImage;

  String selectedType = '';
  List<String> serviceTypes = [];

  @override
  void initState() {
    super.initState();
    fetchServiceTypes();
  }

  Future<void> fetchServiceTypes() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Categories').get();
      setState(() {
        serviceTypes = querySnapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String).toList();
        selectedType = serviceTypes.isNotEmpty ? serviceTypes[0] : '';
      });
      print('Fetched service types: $serviceTypes');
    } catch (e) {
      print('Error fetching categories: $e');
      // Handle error as needed
    }
  }




  Future<void> _getImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> submitService() async {
    if (_selectedImage == null ||
        servicenameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    final imageUrl = await _uploadImageToFirestore();

    await FirebaseFirestore.instance.collection('service').add({
      'service': servicenameController.text,
      'description': descriptionController.text,
      'imageUrl': imageUrl,
      'price': priceController.text,
      'type': selectedType,
      'timestamp': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service added successfully')),
    );

    servicenameController.clear();
    descriptionController.clear();
    priceController.clear();
    setState(() {
      _selectedImage = null;
      selectedType = serviceTypes.isNotEmpty ? serviceTypes[0] : '';
    });
  }

  Future<String> _uploadImageToFirestore() async {
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('service images')
        .child(DateTime.now().toString() + '.jpg');

    await firebaseStorageRef.putFile(_selectedImage!);
    return await firebaseStorageRef.getDownloadURL();
  }

  Future<void> deleteService(String documentId) async {
    await FirebaseFirestore.instance.collection('service').doc(documentId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service deleted successfully')),
    );
  }

  Future<void> editService(String documentId, Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance.collection('service').doc(documentId).update(updatedData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service updated successfully')),
    );
  }

  Future<void> showEditDialog(String documentId, Map<String, dynamic> data) async {
    servicenameController.text = data['service'];
    descriptionController.text = data['description'];
    priceController.text = data['price'];
    selectedType = data['type'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Service'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  onChanged: (newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  items: serviceTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(hintText: 'Service Type'),
                ),
                TextField(
                  controller: servicenameController,
                  decoration: InputDecoration(hintText: 'Service Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(hintText: 'Price'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.c2,
                  ),
                  onPressed: () {
                    editService(documentId, {
                      'service': servicenameController.text,
                      'description': descriptionController.text,
                      'price': priceController.text,
                      'type': selectedType,
                      'timestamp': Timestamp.now(),
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );

    servicenameController.clear();
    descriptionController.clear();
    priceController.clear();
    setState(() {
      selectedType = (serviceTypes.isNotEmpty ? serviceTypes[0] : null)!; // Reset to default type
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.c3,
        title: Text(
          "Add Services",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontFamily: 'Lato',fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: _getImageFromGallery,
                            child: Card(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: 100,
                                height: 180,
                                child: Center(
                                  child: _selectedImage == null
                                      ? Icon(Icons.add_a_photo_outlined, color: Colors.white)
                                      : Image.file(_selectedImage!, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DropdownButtonFormField<String>(
                                  value: selectedType,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedType = newValue!;
                                    });
                                  },
                                  items: serviceTypes.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(hintText: 'Service Type'),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: servicenameController,
                                  decoration: InputDecoration(hintText: 'Service Name'),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(hintText: 'Description'),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: priceController,
                                  decoration: InputDecoration(hintText: 'Price'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(300, 40),
                        backgroundColor: AppColors.c2,
                      ),
                      onPressed: submitService,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('service').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  Center(
                      child: Lottie.asset("assets/images/loading.json")
                  );                }

                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                    String type = data['type'] ?? 'Unknown';
                    String service = data['service'] ?? 'Unknown';
                    String description = data['description'] ?? 'Unknown';
                    String price = data['price'] ?? 'Unknown';
                    String imageUrl = data['imageUrl'] ?? '';

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFbcacd4),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        leading: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                            : null,
                        title: Text(type, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(' $service'),
                            Text('$description'),
                            Row(
                              children: [
                                Text('₹ $price', style: TextStyle(color: Color(0xFF29802D), fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                showEditDialog(document.id, data);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Delete Service"),
                                      content: Text("Are you sure you want to delete this service?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            deleteService(document.id);
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
