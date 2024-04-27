import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpenses extends StatefulWidget {
  AddExpenses({
    Key? key,
  }) : super(key: key);

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

TextEditingController titletextEditingController = TextEditingController();
TextEditingController adescriptiontextEditingController =
    TextEditingController();
TextEditingController locationtextEditingController = TextEditingController();
TextEditingController datetextEditingController = TextEditingController();
TextEditingController priceEditingController = TextEditingController();
User? user = FirebaseAuth.instance.currentUser;

class _AddExpensesState extends State<AddExpenses> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool autoplays = false;
  bool showLoading = false;
  bool showLoadingWidget = false;
  String selectedCountry = 'user';
  bool _loading = false;
  DateTime date = DateTime.now();
  // TimeOfDay? time;
  String currentTime = DateFormat.Hm().format(DateTime.now());
  final User? currentUser = FirebaseAuth.instance.currentUser;

  DateTime timeBackPressed = DateTime.now();

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
        title: Text("Add Expense",
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
      body: Form(
        key: _formKey,
        child: ListView(children: [
          const Padding(
            padding: EdgeInsets.only(top: 18, left: 18, right: 18),
            child: Text(
              'Title',
              style: TextStyle(
                  fontSize: 14, letterSpacing: 1, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
            child: TextFormField(
              style: TextStyle(
                  fontSize: 14, letterSpacing: 1, color: Colors.black),
              controller: titletextEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                fillColor: const Color(0xFFf2dfce),
                filled: true,
                border: InputBorder.none,
                suffixIcon: IconButton(
                  color: const Color(0xFFe26f39),
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                  onPressed: () {
                    titletextEditingController.clear();
                  },
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  size: 16,
                  color: Color(0xFFe26f39),
                ),
                hintStyle: const TextStyle(
                    fontSize: 11, letterSpacing: 1, color: Colors.black),
                hintText: "Eg: enter title",
              ),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Title is required';
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 18, left: 18, right: 18),
            child: Text(
              'Description.',
              style: TextStyle(
                  fontSize: 14, letterSpacing: 1, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
            child: TextFormField(
              style: TextStyle(
                  fontSize: 14, letterSpacing: 1, color: Colors.black),
              controller: adescriptiontextEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                fillColor: const Color(0xFFf2dfce),
                filled: true,
                border: InputBorder.none,
                suffixIcon: IconButton(
                  color: const Color(0xFFe26f39),
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                  onPressed: () {
                    adescriptiontextEditingController.clear();
                  },
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  size: 16,
                  color: Color(0xFFe26f39),
                ),
                hintStyle: const TextStyle(
                    fontSize: 11, letterSpacing: 1, color: Colors.black),
                hintText: "E.g describe the purporse of appointment",
              ),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Description required';
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 18, left: 18, right: 18),
            child: Text(
              'Price.',
              style: TextStyle(
                  fontSize: 14, letterSpacing: 1, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
            child: TextFormField(
              style: TextStyle(
                  fontSize: 14, letterSpacing: 1, color: Colors.black),
              controller: priceEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: const Color(0xFFf2dfce),
                filled: true,
                border: InputBorder.none,
                suffixIcon: IconButton(
                  color: const Color(0xFFe26f39),
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                  onPressed: () {
                    priceEditingController.clear();
                  },
                ),
                prefixIcon: const Icon(
                  Icons.price_change,
                  size: 16,
                  color: Color(0xFFe26f39),
                ),
                hintStyle: const TextStyle(
                    fontSize: 11, letterSpacing: 1, color: Colors.black),
                hintText: "Eg. 200000",
              ),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Buying price required';
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 18, left: 18, right: 18),
            child: Text(
              'Date.',
              style: TextStyle(
                  fontSize: 14, letterSpacing: 1, color: Colors.black),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
              child: InkWell(
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2024),
                    // firstDate: DateTime.now().subtract(Duration(days: 0)),
                    lastDate: DateTime(2100),
                  );
                  if (newDate == null) return;
                  setState(() {
                    date = newDate;
                  });
                },
                child: Container(
                  height: 46.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color(0xFFf2dfce),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14.0, left: 8),
                    child: Text(
                      '${date.day}/ ${date.month}/ ${date.year} ',
                      style: const TextStyle(
                          fontSize: 14, letterSpacing: 1, color: Colors.black),
                    ),
                  ),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFFf2dfce),
                    ),
                    side: MaterialStateProperty.all(const BorderSide(
                      color: Color(0xFFe26f39),
                    )),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                onPressed: _loading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          // registerNewUser(context);
                          addExpenses();

                          // Navigator.of(context).push(
                          //     MaterialPageRoute(builder: (BuildContext context) {
                          //   return MyHomePage();
                          // }));
                        }
                      },
                child: _loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ))
                    : const Text(
                        ' Submit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      )),
          ),
        ]),
      ),
    );
  }

  Future addExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    if (userId != null) {
      // Fetching the current user's document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      // Extracting createdBy from the user document
      String createdBy = userDoc['createdBy'];

      // Setting the expenses document with shopId taken from createdBy
      await document.set({
        'id': document.id,
        "date": date,
        "owner": userId,
        "title": titletextEditingController.text,
        "price": priceEditingController.text,
        "description": adescriptiontextEditingController.text,
        "status": "pending",
        "shopId": createdBy, // Setting shopId with createdBy
        "PostedAt": FieldValue.serverTimestamp(),
      });

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expenses added successfully'),
        ),
      );

      Navigator.pop(context);
    }
  }

  final document = FirebaseFirestore.instance.collection('expenses').doc();
}
