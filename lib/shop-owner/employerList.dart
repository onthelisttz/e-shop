import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/shop-owner/registerEmployer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployerList extends StatefulWidget {
  const EmployerList({super.key});

  @override
  State<EmployerList> createState() => _EmployerListState();
}

User? user = FirebaseAuth.instance.currentUser;
final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
    .collection('users')
    .where("role", isEqualTo: "employer")
    .where("createdBy", isEqualTo: user!.uid)
    .snapshots();

class _EmployerListState extends State<EmployerList> {
  String UserID = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    if (userId != null) {
      setState(() {
        UserID = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
        title: Text("Employer List",
            style:
                TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 14)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Color(0xFFe26f39),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'createEmloyer',
        onPressed: () {
          // Add your onPressed action here
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RegisterEmployerClass();
          }));
        },
        backgroundColor: const Color(0xFFf2dfce), // Background color
        foregroundColor: const Color(0xFFe26f39), // Icon color
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFe26f39)), // Border color
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.add),
      ),
      body: Container(
        color: Color.fromARGB(179, 241, 241, 241),
        child: ListView(
          children: [
            UserID != null
                ? Container(
                    color: const Color.fromARGB(179, 241, 241, 241),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where("role", isEqualTo: "employer")
                          .where("createdBy", isEqualTo: UserID)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return ListView(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            double kms = 2000;

                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  child: ListTile(
                                    onTap: () async {},
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xFFe26f39),
                                      radius: 24,
                                      child: ClipOval(
                                        child: data['PhotoUrl'] == null
                                            ? Text(
                                                'Dr',
                                                style: TextStyle(fontSize: 17),
                                              )
                                            : Image.network(
                                                data['PhotoUrl'],
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                    title: Text(
                                      data["displayName"],
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email_outlined,
                                              size: 10,
                                              color: Color(0xFFe26f39),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 1.0),
                                              child: Text(
                                                data['email'],
                                                // data['location'],
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          }).toList(),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
