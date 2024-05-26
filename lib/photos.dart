import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Photos extends StatefulWidget {
  const Photos({super.key});

  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  List<String> imageUrls = [];
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Registered Users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          username = data['username'] ?? '';
          email = data['email'] ?? '';
          if (data.containsKey('imageurls')) {
            imageUrls = List<String>.from(data['imageurls']);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,style: TextStyle(fontSize: 12,color: Colors.black),),
                Text(
                  email,
                  style: TextStyle(fontSize: 12,color: Colors.black),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  var imageUrl = imageUrls[index];
                  return Image.network(imageUrl, fit: BoxFit.cover);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () async {
          var img = await ImagePicker().pickImage(source: ImageSource.gallery);
          if (img != null) {
            File image = File(img.path);
            Reference storageReference = FirebaseStorage.instance.ref().child("/galleryPhotos/${image.path}");
            UploadTask uploadTask = storageReference.putFile(image);
            var taskSnapshot = await uploadTask.whenComplete(() => null);
            String url = await taskSnapshot.ref.getDownloadURL();
            print("Image uploaded: $url");
            setState(() {
              imageUrls.add(url);
            });
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final DocumentReference userDoc = FirebaseFirestore.instance.collection('Registered Users').doc(user.uid);
              await userDoc.update({
                "imageurls": FieldValue.arrayUnion([url])
              });
            }
          }
        },
        child: Icon(Icons.photo_album),
      ),
    );
  }
}
