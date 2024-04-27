import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetDisplayPage extends StatefulWidget {
  BudgetDisplayPage({
    Key? key,
  }) : super(key: key);

  @override
  _BudgetDisplayPageState createState() => _BudgetDisplayPageState();
}

class _BudgetDisplayPageState extends State<BudgetDisplayPage> {
  late Future<QuerySnapshot> _budgetFuture;
  User? user = FirebaseAuth.instance.currentUser;
  final _format = NumberFormat('##,###,###.##');
  @override
  void initState() {
    super.initState();
    _budgetFuture = _fetchBudgetData();
  }

  Future<QuerySnapshot> _fetchBudgetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection('budget')
          .where("owner", isEqualTo: userId)
          .get();
    } else {
      // Throw an exception indicating userId is missing
      throw Exception('userId not found in SharedPreferences');
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
        title: Text("Budget Details",
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
      body: FutureBuilder<QuerySnapshot>(
        future: _budgetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Total Budget',
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
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.monetization_on_rounded,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.6)),
                              Text(
                                _format.format(data['totalBudget']),
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
                    SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Direct Cost',
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Rent',
                            style: TextStyle(
                                fontSize: 11,
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
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _format.format(data['directCost']['rent']),
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency',
                            style: TextStyle(
                                fontSize: 11,
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
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _format
                                      .format(data['directCost']['emergency']),
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Salary',
                            style: TextStyle(
                                fontSize: 11,
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
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _format.format(data['directCost']['salary']),
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Important Products 60%: ${_format.format(data['importantBudget'])}',
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    _buildProductList(data['importantProducts']),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Unimportant Products 40%: ${_format.format(data['unimportantBudget'])}',
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D3D3D)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    _buildProductList(data['unimportantProducts']),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductList(List<dynamic> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: products.map<Widget>((product) {
        return Card(
          elevation: 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            // ignore: prefer_const_constructors

            child: ListTile(
              title: Text(
                product['name'],
                style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3D3D)),
              ),
              subtitle: Text(
                ' Price: ${_format.format(product['price'])}',
                style: TextStyle(
                    fontSize: 12, letterSpacing: 1, color: Color(0xFF3D3D3D)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
