import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddSales extends StatefulWidget {
  const AddSales({Key? key}) : super(key: key);
  static const String idScreen = "addSales";

  @override
  _RegisterClassState createState() => _RegisterClassState();
}

TextEditingController productNametextEditingController =
    TextEditingController();

TextEditingController priceEditingController = TextEditingController();

TextEditingController quantiyEditingController = TextEditingController();

// TextEditingController descrptionEditingController = TextEditingController();

class _RegisterClassState extends State<AddSales> {
  final GlobalKey<FormState> AddSalesKey = GlobalKey<FormState>();

  bool _loading = false;

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009999),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Add Product',
          style: TextStyle(fontSize: 11, letterSpacing: 1, color: Colors.white),
        ),
      ),
      body: Form(
        key: AddSalesKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
                child: Text(
                  'Product Name.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: productNametextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Color(0xFF009999),
                    filled: true,
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      color: Color.fromARGB(255, 177, 237, 237),
                      icon: Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onPressed: () {
                        productNametextEditingController.clear();
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.title,
                      size: 16,
                      color: Color.fromARGB(255, 177, 237, 237),
                    ),
                    hintStyle: TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.white),
                    hintText: "Eg. Phone",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Product name required';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
                child: Text(
                  'Buying Price.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: priceEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Color(0xFF009999),
                    filled: true,
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      color: Color.fromARGB(255, 177, 237, 237),
                      icon: Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onPressed: () {
                        priceEditingController.clear();
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.price_change,
                      size: 16,
                      color: Color.fromARGB(255, 177, 237, 237),
                    ),
                    hintStyle: TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.white),
                    hintText: "Eg. 200000",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Buying price required';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Quantity.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: quantiyEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Color(0xFF009999),
                    filled: true,
                    suffixIcon: IconButton(
                      color: Color.fromARGB(255, 177, 237, 237),
                      icon: Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onPressed: () {
                        quantiyEditingController.clear();
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.sanitizer_outlined,
                      size: 16,
                      color: Color.fromARGB(255, 177, 237, 237),
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.white),
                    hintText: "Write a total size",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "quantity is required";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF009999),
                        ),
                        side: MaterialStateProperty.all(BorderSide(
                          color: Color.fromARGB(255, 177, 237, 237),
                        )),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: _loading
                        ? null
                        : () {
                            if (AddSalesKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              AddSales();

                              // Navigator.of(context).push(
                            }
                          },
                    child: _loading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Color.fromARGB(255, 255, 255, 255),
                              ),
                            ))
                        : Text(
                            ' Add Sales',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  User? user = FirebaseAuth.instance.currentUser;

  AddSales() async {
    try {
      await document.set({
        'id': document.id,
        "productName": productNametextEditingController.text.trim(),
        "postedBy": user!.uid,
        "price": priceEditingController.text.trim(),
        "quantity": quantiyEditingController.text.trim(),
        "PostedAt": FieldValue.serverTimestamp(),
      });
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('sales added Successfull'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to add product'),
        ),
      );
    }

    // Navigator.pop(context);
  }

  final document = FirebaseFirestore.instance.collection('sales').doc();
}
