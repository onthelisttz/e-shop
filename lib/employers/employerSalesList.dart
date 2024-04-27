import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AllWigtes/Dialog.dart';

class EmployerSalesList extends StatefulWidget {
  const EmployerSalesList({Key? key}) : super(key: key);

  @override
  State<EmployerSalesList> createState() => _ProductListState();
}

class _ProductListState extends State<EmployerSalesList> {
  late String createdBy;
  late Stream<QuerySnapshot> _EmployerSalesListtreams = Stream.empty();
  final _format = NumberFormat('##,###,###.##');
  @override
  void initState() {
    super.initState();
    fetchCreatedBy();
  }

  void fetchCreatedBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      setState(() {
        createdBy = userDoc['createdBy'];
        _EmployerSalesListtreams = FirebaseFirestore.instance
            .collection('sales')
            .where("postedBy", isEqualTo: createdBy)
            .snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        titleSpacing: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text('Sales List',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.9), fontSize: 14)),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _EmployerSalesListtreams,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              String priceString = data["price"].toString();
              double price = double.parse(priceString);
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black, width: 0.1),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(data['productName']),
                        subtitle: Text(_format.format(
                            price)), // Modify as per your formatting needs
                        trailing: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(data['PostedAt'] != null
                                  ? readTimestamp2(data['PostedAt'])
                                  : "No timestamp"),
                            ),
                          ],
                        ),
                      ),
                    ),
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
