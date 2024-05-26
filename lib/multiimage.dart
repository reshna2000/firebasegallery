import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class multiimage extends StatefulWidget {
  const multiimage({super.key});

  @override
  State<multiimage> createState() => _multiimageState();
}

class _multiimageState extends State<multiimage> {
  get path => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        var img=await ImagePicker().pickMultiImage();
        for(var element in img){
          File image = File(element!.path);
          Reference storage=FirebaseStorage.instance
              .ref()
          .child("Pimages/${image.path}");
        }

      },child: Text("add"),),
    );
  }
}
