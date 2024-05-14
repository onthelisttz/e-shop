import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/AllWigtes/Dialog.dart';
import 'package:e_shop/shop-owner/addSales.dart';
import 'package:e_shop/shop-owner/editProduct.dart';
import 'package:e_shop/shop-owner/productDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesList extends StatefulWidget {
  const SalesList({Key? key}) : super(key: key);

  @override
  State<SalesList> createState() => _ProductListState();
}

User? user = FirebaseAuth.instance.currentUser;

final Stream<QuerySnapshot> _SalesListtreams = FirebaseFirestore.instance
    .collection('sales')
    .where("postedBy", isEqualTo: user!.uid)
    .snapshots();

final _format = NumberFormat('##,###,###.##');

class _ProductListState extends State<SalesList> {
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
          iconTheme: const IconThemeData(color: Colors.black),
          titleSpacing: 0,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('Sales',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.9), fontSize: 14)),
          ),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'slaesList',
          onPressed: () {
            // Add your onPressed action here
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const AddSales();
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
        body: UserID != null
            ? Container(
                color: const Color.fromARGB(179, 241, 241, 241),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('sales')
                      .where("postedBy", isEqualTo: UserID)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        // return ListTile(
                        //   title: Text(data['title']),
                        //   subtitle: Text(data['des']),
                        // );
                        String priceString = data["price"].toString();
                        double price = double.parse(priceString);
                        return InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    color: Colors.black,
                                    width: 0.1), // Border here
                              ),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(data['productName']),
                                  subtitle: Text(_format.format(price)),
                                  trailing: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(data['PostedAt'] != null
                                            ? readTimestamp2(data['PostedAt'])
                                            : "No timestamp"),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            deleteSale(data['id']);
                                          },
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors
                                                  .red, // Customize the text color if needed
                                            ),
                                          ),
                                        ),
                                      )
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
              )
            : Container());
  }

  void deleteSale(String id) async {
    try {
      // Construct the reference to the sale document using the provided ID
      final saleReference =
          FirebaseFirestore.instance.collection('sales').doc(id);

      // Delete the sale document
      await saleReference.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sale deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to delete sale'),
        ),
      );
    }
  }
}
