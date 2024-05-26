import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase2/Albums.dart';
import 'package:firebase2/Register.dart';
import 'package:firebase2/full%20details.dart';
import 'package:firebase2/photos.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  final String userID;

  const Gallery({super.key, required this.userID});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ));
                },
                icon: Icon(Icons.logout))
          ],
          actionsIconTheme: IconThemeData(color: Colors.green),
          iconTheme: IconThemeData(color: Colors.green),
          title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Registered Users')
                .doc(widget.userID)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text("User not found"));
              }

              String username = snapshot.data!['username'];
              return Text(
                "Hello, $username",
                style: TextStyle(color: Colors.green),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 130.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Registered Users')
                          .doc(widget.userID)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(color: Colors.green);
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Center(child: Text("User not found"));
                        }

                        String? profileImageUrl = snapshot.data!['Profilepic'];
                        return CircleAvatar(
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl)
                              : null,
                          backgroundColor: Colors.green,
                        );
                      },
                    ),
                    TextButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Full(),));
                    },child: Text("Photos",
                      style: TextStyle(color: Colors.greenAccent, fontSize: 30),
                    ),),
                    Icon(Icons.search, color: Colors.white),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(70),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: "My Photos"),
                          Tab(text: "Album"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Photos(),
                            ImageGallery(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
