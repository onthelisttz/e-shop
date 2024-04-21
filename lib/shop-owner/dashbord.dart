import 'dart:ffi';

import 'package:e_shop/shop-owner/employerList.dart';
import 'package:e_shop/shop-owner/shopProgressChart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Dashbord extends StatefulWidget {
  @override
  _DashbordState createState() => _DashbordState();
}

User? user = FirebaseAuth.instance.currentUser;

class _DashbordState extends State<Dashbord> {
  late Stream<QuerySnapshot> _salesListStream;
  late Stream<QuerySnapshot> _expensesListStream;
  double totalSalesToday = 0;
  double totalSalesMonth = 0;
  double totalSalesYesterday = 0;
  double totalExpensesToday = 0;
  double totalExpenseYesterday = 0;
  double totalExpensesThisMonth = 0;
  double estimatedBudgetTomorrow = 0;
  double estimatedBudgetToday = 0;
  double profitLossToday = 0;
  double profitLossThisMonth = 0;

  final _format = NumberFormat('##,###,###.##');
  @override
  void initState() {
    super.initState();
    _salesListStream = FirebaseFirestore.instance
        .collection('sales')
        .where("postedBy", isEqualTo: user!.uid)
        .snapshots();
    _expensesListStream = FirebaseFirestore.instance
        .collection('expenses')
        .where("owner", isEqualTo: user!.uid)
        .where("status", isEqualTo: 'approved')
        .snapshots();

    calculateMetrics();
  }

  void calculateMetrics() {
    DateTime today = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    _expensesListStream.listen((expensesSnapshot) {
      totalExpensesToday = 0;
      totalExpenseYesterday = 0;
      totalExpensesThisMonth = 0;

      expensesSnapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>;
        // DateTime expenseDate = (data['date'] as Timestamp).toDate();

        DateTime expenseDate;
        if (data['date'] != null) {
          expenseDate = (data['date'] as Timestamp).toDate();
        } else {
          Timestamp defaultTimestamp = Timestamp.fromDate(DateTime(1998, 1, 2));
          expenseDate = defaultTimestamp.toDate();
        }

        if (expenseDate.day == yesterday.day &&
            expenseDate.month == yesterday.month &&
            expenseDate.year == yesterday.year) {
          if (data['price'] != null) {
            totalExpenseYesterday += double.parse(data['price'].toString());
          }
        }

        if (expenseDate.day == today.day &&
            expenseDate.month == today.month &&
            expenseDate.year == today.year) {
          if (data['price'] != null) {
            totalExpensesToday += double.parse(data['price'].toString());
          }
        }

        if (expenseDate.month == today.month &&
            expenseDate.year == today.year) {
          if (data['price'] != null) {
            totalExpensesThisMonth += double.parse(data['price'].toString());
          }
        }
      });

      setState(() {
        // Trigger rebuild after calculations
      });
    });

    _salesListStream.listen((salesSnapshot) {
      totalSalesToday = 0;
      totalSalesMonth = 0;
      totalSalesYesterday = 0;

      salesSnapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>;
        // DateTime saleDate = (data['PostedAt'] as Timestamp).toDate();
        DateTime saleDate;
        if (data['PostedAt'] != null) {
          saleDate = (data['PostedAt'] as Timestamp).toDate();
        } else {
          Timestamp defaultTimestamp = Timestamp.fromDate(DateTime(1998, 1, 2));
          saleDate = defaultTimestamp.toDate();
        }

        if (saleDate.day == yesterday.day && saleDate.year == yesterday.year) {
          if (data['price'] != null) {
            totalSalesYesterday += double.parse(data['price'].toString());
          }
        }

        if (saleDate.day == today.day && saleDate.year == today.year) {
          if (data['price'] != null) {
            totalSalesToday += double.parse(data['price'].toString());
          }
        }

        if (saleDate.month == today.month && saleDate.year == today.year) {
          if (data['price'] != null) {
            totalSalesMonth += double.parse(data['price'].toString());
          }
        }
      });

      // Calculate estimated budget for tomorrow
      DateTime tomorrow = today.add(const Duration(days: 1));
      estimatedBudgetTomorrow = totalSalesToday - totalExpensesToday;

      estimatedBudgetToday = totalSalesYesterday - totalExpenseYesterday;
      // Calculate profit and loss for the current day
      profitLossToday = totalSalesToday - totalExpensesToday;

      // Calculate profit and loss for the current month
      profitLossThisMonth = totalSalesMonth - totalExpensesThisMonth;

      setState(() {
        // Trigger rebuild after calculations
      });
    });
  }

  bool Clicked1 = false;
  bool Clicked2 = false;
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
          child: Text('Home',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.9), fontSize: 14)),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'employerList',
        onPressed: () {
          // Add your onPressed action here
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return EmployerList();
          }));
        },
        backgroundColor: const Color(0xFFf2dfce), // Background color
        foregroundColor: const Color(0xFFe26f39), // Icon color
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFe26f39)), // Border color
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.people),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Budget',
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Color(0xFFe26f39),
                          blurRadius: 1,
                          spreadRadius: 0.1)
                    ],
                    // color: Color(0xFFFFFFFF),
                    color: Clicked1 ? const Color(0xFFf2dfce) : Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.monetization_on_rounded,
                          size: 25, color: Colors.black.withOpacity(0.6)),
                      Text(
                        _format.format(estimatedBudgetToday),
                        style: TextStyle(
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Today Analysis',
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D)),
                  ),
                ],
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Color(0xFFe26f39),
                                blurRadius: 1,
                                spreadRadius: 0.1)
                          ],
                          // color: Color(0xFFFFFFFF),
                          color:
                              Clicked2 ? const Color(0xFFf2dfce) : Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Sales',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12),
                            ),
                          ),
                          Text(
                            _format.format(totalSalesToday),
                            style: const TextStyle(
                                fontSize: 13,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Color(0xFFe26f39),
                                blurRadius: 1,
                                spreadRadius: 0.1)
                          ],
                          // color: Color(0xFFFFFFFF),
                          color:
                              Clicked2 ? const Color(0xFFf2dfce) : Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Expenses',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12),
                            ),
                          ),
                          Text(
                            _format.format(totalExpensesToday),
                            style: const TextStyle(
                                fontSize: 13,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Color(0xFFe26f39),
                                blurRadius: 1,
                                spreadRadius: 0.1)
                          ],
                          // color: Color(0xFFFFFFFF),
                          color:
                              Clicked2 ? const Color(0xFFf2dfce) : Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Profit',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12),
                            ),
                          ),
                          Text(
                            _format.format(profitLossToday),
                            style: const TextStyle(
                                fontSize: 13,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Current Month Analysis',
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D)),
                  ),
                ],
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Color(0xFFe26f39),
                                blurRadius: 1,
                                spreadRadius: 0.1)
                          ],
                          // color: Color(0xFFFFFFFF),
                          color:
                              Clicked2 ? const Color(0xFFf2dfce) : Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Sales',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12),
                            ),
                          ),
                          Text(
                            _format.format(totalSalesMonth),
                            style: const TextStyle(
                                fontSize: 13,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Color(0xFFe26f39),
                                blurRadius: 1,
                                spreadRadius: 0.1)
                          ],
                          // color: Color(0xFFFFFFFF),
                          color:
                              Clicked2 ? const Color(0xFFf2dfce) : Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Expenses',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12),
                            ),
                          ),
                          Text(
                            _format.format(totalExpensesThisMonth),
                            style: const TextStyle(
                                fontSize: 13,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Color(0xFFe26f39),
                                blurRadius: 1,
                                spreadRadius: 0.1)
                          ],
                          // color: Color(0xFFFFFFFF),
                          color:
                              Clicked2 ? const Color(0xFFf2dfce) : Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Profit',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12),
                            ),
                          ),
                          Text(
                            _format.format(profitLossThisMonth),
                            style: const TextStyle(
                                fontSize: 13,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Shop Progress',
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D)),
                  ),
                ],
              ),
            ),
            ShopPregress(),
            SizedBox(
              height: 33,
            )
            // Text(
            //   'Total Sales Today: \$${totalSalesToday.toStringAsFixed(2)}',
            //   style: const TextStyle(fontSize: 18),
            // ),
            // Text(
            //   'Total Expenses Today: \$${totalExpensesToday.toStringAsFixed(2)}',
            //   style: const TextStyle(fontSize: 18),
            // ),
            // Text(
            //   'Estimated Budget for Tomorrow: \$${estimatedBudgetTomorrow.toStringAsFixed(2)}',
            //   style: const TextStyle(fontSize: 18),
            // ),
            // Text(
            //   'Profit/Loss Today: \$${profitLossToday.toStringAsFixed(2)}',
            //   style: const TextStyle(fontSize: 18),
            // ),
            // Text(
            //   'Profit/Loss This Month: \$${profitLossThisMonth.toStringAsFixed(2)}',
            //   style: const TextStyle(fontSize: 18),
            // ),
          ],
        ),
      ),
    );
  }
}
