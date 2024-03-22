import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/shop-owner/editProduct.dart';
import 'package:e_shop/shop-owner/productDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesList extends StatefulWidget {
  const SalesList({Key? key}) : super(key: key);

  @override
  State<SalesList> createState() => _ProductListState();
}

User? user = FirebaseAuth.instance.currentUser;
final Stream<QuerySnapshot> _SalesListtreams = FirebaseFirestore.instance
    .collection('sales')
    // .where("clientId", isEqualTo: user!.uid)
    .snapshots();

String readTimestamp2(Timestamp timestamp) {
  var now = DateTime.now();
  var format = DateFormat('EEE, MMM d ');
  var date = timestamp.toDate();

  var time = '';

  time = format.format(date);

  return time;
}

class _ProductListState extends State<SalesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF009999),
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          "SalesList",
          style: TextStyle(fontSize: 17, letterSpacing: 2, color: Colors.white),
        ),
      ),
      body: Container(
        color: Color.fromARGB(179, 241, 241, 241),
        child: StreamBuilder<QuerySnapshot>(
          stream: _SalesListtreams,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                // return ListTile(
                //   title: Text(data['title']),
                //   subtitle: Text(data['des']),
                // );
                return InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // ignore: prefer_const_constructors
                        color: Colors.white,
                        // decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(data['productName']),
                            subtitle: Text(data['price']),
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
      ),
    );
  }
}
