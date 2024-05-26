// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ImageGallery extends StatefulWidget {
//   const ImageGallery({super.key});
//
//   @override
//   State<ImageGallery> createState() => _ImageGalleryState();
// }
//
// class _ImageGalleryState extends State<ImageGallery> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Image Gallery"),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             FloatingActionButton(
//               onPressed: () async {
//                 var img = await ImagePicker().pickImage(source: ImageSource.gallery);
//                 if (img != null) {
//                   File image = File(img.path);
//                   Reference storageReference = FirebaseStorage.instance.ref().child("images/${DateTime.now()}");
//                   UploadTask uploadTask = storageReference.putFile(image);
//                   var taskSnapshot = await uploadTask.whenComplete(() => null);
//                   String url = await taskSnapshot.ref.getDownloadURL();
//                   print("Image uploaded: $url");
//
//                   await FirebaseFirestore.instance.collection("Images").add({"imageurl": url});
//                 }
//               },
//               child: Icon(Icons.add),
//             ),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection("Images").snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Center(child: Text("No images found"));
//                   }
//
//                   var images = snapshot.data!.docs;
//                   return GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemCount: images.length,
//                     itemBuilder: (context, index) {
//                       var imageUrl = images[index]["imageurl"];
//                       return Image.network(imageUrl, fit: BoxFit.cover);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
