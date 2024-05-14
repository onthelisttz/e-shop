import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/shop-owner/addExpenses.dart';
import 'package:e_shop/shop-owner/editProduct.dart';
import 'package:e_shop/shop-owner/expensesDetals.dart';
import 'package:e_shop/shop-owner/productDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({Key? key}) : super(key: key);

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

User? user = FirebaseAuth.instance.currentUser;
final Stream<QuerySnapshot> _ExpensesListtreams = FirebaseFirestore.instance
    .collection('expenses')
    .where("shopId", isEqualTo: user!.uid)
    // .where("status", isEqualTo: 'approved')
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

class _ExpensesListState extends State<ExpensesList> {
  final _format = NumberFormat('##,###,###.##');
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
            child: Text('Expenses',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.9), fontSize: 14)),
          ),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'expenseList',
          onPressed: () {
            // Add your onPressed action here
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return AddExpenses();
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
                      .collection('expenses')
                      .where("shopId", isEqualTo: UserID)
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
                        String priceString = data['price'].toString();
                        double price = double.parse(priceString);
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ExpensesDetails(
                                docId: data["id"],
                              );
                            }));
                          },
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
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        VerticalDivider(
                                          thickness: 2,
                                          width: 20,
                                          color: data["status"] != "pending"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              data["status"] ==
                                                                      "approved"
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    4.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    4.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    4.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    4.0),
                                                          )),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                right: 8.0,
                                                                top: 1,
                                                                bottom: 1.0),
                                                        child: Text(
                                                          data["status"] ==
                                                                  "approved"
                                                              ? "Approved"
                                                              : data["status"] ==
                                                                      "pending"
                                                                  ? "Pending"
                                                                  : "Rejected",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.timer_sharp,
                                                    size: 15,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(data[
                                                                'PostedAt'] !=
                                                            null
                                                        ? readTimestamp2(
                                                            data['PostedAt'])
                                                        : "No timestamp available"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    80,
                                                height: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .title_outlined,
                                                            size: 10,
                                                            color: Colors.grey,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              data["title"],
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.money,
                                                    size: 10,
                                                    color: Colors.grey,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      _format.format(price),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // child: Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Card(
                          //     child: Container(
                          //       width: MediaQuery.of(context).size.width,
                          //       // ignore: prefer_const_constructors
                          //       color: Colors.white,
                          //       // decoration: BoxDecoration(border: Border.all()),
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: IntrinsicHeight(child: Text(data['title'])),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        );
                      }).toList(),
                    );
                  },
                ),
              )
            : Container());
  }
}
