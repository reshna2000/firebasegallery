import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        title: Text('Registered Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Registered Users')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Loading indicator while waiting for data
          }

          // Once data is received
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              // Extracting the fields you want to display
              String username = data['username'] ?? 'Unknown';
              String email = data['email'] ?? 'Unknown';
              String place = data['place'] ?? 'Unknown';
              String phone = data['phone'] ?? 'Unknown';
              String? profileImageUrl = data['Profilepic'];

              // Create a Container to wrap the ListTile and display user details
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : null, // If profileImageUrl is null, set backgroundImage to null
                  ),
                  title: Text(username),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: $email'),
                      Text('Place: $place'),
                      Text('Phone: $phone'),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
