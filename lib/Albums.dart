import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  List<String> albumImageUrls = [];

  @override
  void initState() {
    super.initState();
  }

  Stream<DocumentSnapshot> _userDocStream() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('Registered Users').doc(user.uid).snapshots();
    } else {
      throw Exception("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _userDocStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading images"));
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text("No images found", style: TextStyle(color: Colors.green)));
                  }

                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  albumImageUrls = data.containsKey('Albumimages') ? List<String>.from(data['Albumimages']) : [];

                  if (albumImageUrls.isEmpty) {
                    return const Center(child: Text("No images found", style: TextStyle(color: Colors.green)));
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: albumImageUrls.length,
                    itemBuilder: (context, index) {
                      var imageUrl = albumImageUrls[index];
                      return Image.network(imageUrl, fit: BoxFit.cover);
                    },
                  );
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
            Reference storageReference = FirebaseStorage.instance.ref().child("albumPhotos/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}");
            UploadTask uploadTask = storageReference.putFile(image);
            var taskSnapshot = await uploadTask.whenComplete(() => null);
            String url = await taskSnapshot.ref.getDownloadURL();
            print("Image uploaded: $url");

            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final DocumentReference userDoc = FirebaseFirestore.instance.collection('Registered Users').doc(user.uid);
              await userDoc.update({
                "Albumimages": FieldValue.arrayUnion([url])
              });
            }
          }
        },
        child: const Icon(Icons.photo_album),
      ),
    );
  }
}
