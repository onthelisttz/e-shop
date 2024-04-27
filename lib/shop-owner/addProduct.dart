import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/registration/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as Path;

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>[
  'user',
  'lawyer',
];

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);
  static const String idScreen = "addProduct";

  @override
  _RegisterClassState createState() => _RegisterClassState();
}

TextEditingController productNametextEditingController =
    TextEditingController();
TextEditingController descrptionEditingController = TextEditingController();

TextEditingController buyingPriceEditingController = TextEditingController();
TextEditingController sellingPriceEditingController = TextEditingController();
TextEditingController quantiyEditingController = TextEditingController();
TextEditingController measuremntEditingCotroller = TextEditingController();
TextEditingController codeEditingController = TextEditingController();

class _RegisterClassState extends State<AddProduct> {
  final GlobalKey<FormState> addProductKey = GlobalKey<FormState>();

  bool _loading = false;

  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
        title: Text("Add Product",
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
        key: addProductKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 18, left: 18, right: 18),
                child: Text(
                  'Product Name.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: productNametextEditingController,
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
                        productNametextEditingController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.title,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Eg. Phone",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Product name required';
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18, left: 18, right: 18),
                child: Text(
                  'Buying Price.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: buyingPriceEditingController,
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
                        buyingPriceEditingController.clear();
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
                  'Selling Price.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: sellingPriceEditingController,
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
                        sellingPriceEditingController.clear();
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
                      return 'Selling price required';
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Quantity.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: quantiyEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFf2dfce),
                    filled: true,
                    suffixIcon: IconButton(
                      color: const Color(0xFFe26f39),
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onPressed: () {
                        quantiyEditingController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.sanitizer_outlined,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Write a total size",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "quantity is required";
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Code.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: codeEditingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFf2dfce),
                    filled: true,
                    suffixIcon: IconButton(
                      color: const Color(0xFFe26f39),
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onPressed: () {
                        codeEditingController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.sanitizer_outlined,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Write a product Code",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "code is required";
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Measurement.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: measuremntEditingCotroller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFf2dfce),
                    filled: true,
                    suffixIcon: IconButton(
                      color: const Color(0xFFe26f39),
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onPressed: () {
                        measuremntEditingCotroller.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.kitchen_outlined,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Measurement of the product",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Measurement is required";
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Description.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: descrptionEditingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFf2dfce),
                    filled: true,
                    suffixIcon: IconButton(
                      color: const Color(0xFFe26f39),
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onPressed: () {
                        descrptionEditingController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.description,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Write a short description of the product",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Description is required";
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'product Image',
                  style: TextStyle(
                      fontSize: 11, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          chooseImage();
                        },
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            shape: BoxShape.rectangle,
                            color: const Color(0xFFf2dfce),
                          ),
                          child: Container(
                            child: _image == null
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(_image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () {
                          chooseImage();
                        },
                        child: ClipOval(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(3.0),
                            child: ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: const Color(0xFFe26f39),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: Color(0xFFf2dfce),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: _loading
                        ? null
                        : () {
                            if (addProductKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              addProduct();

                              // Navigator.of(context).push(
                            }
                          },
                    child: _loading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Color.fromARGB(255, 255, 255, 255),
                              ),
                            ))
                        : const Text(
                            ' Add Product',
                            style: TextStyle(
                              color: Colors.black,
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

  bool isEnabled = true;
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;
  File? _image;

  final picker = ImagePicker();
  chooseImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);
    setState(() {
      _image = File(pickedFile!.path);
    });

    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    }
  }

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> addProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    if (userId != null) {
      try {
        // Check if the product code already exists
        final codeExistsQuery = await FirebaseFirestore.instance
            .collection('products')
            .where('code', isEqualTo: codeEditingController.text.trim())
            .limit(1)
            .get();

        // If the query returns any documents, the code already exists
        if (codeExistsQuery.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Product code already exists. Please use another code.'),
            ),
          );
          setState(() {
            _loading = false;
          });
          return; // Exit the method without adding the product
        }

        // If the code is unique, proceed to add the product
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(_image!.path)}');
        await ref.putFile(_image!);
        final String downloadUrl = await ref.getDownloadURL();
        var buyingPrice = int.parse(buyingPriceEditingController.text.trim());
        var sellingPrice = int.parse(sellingPriceEditingController.text.trim());
        var qntity = int.parse(quantiyEditingController.text.trim());
        await document.set({
          'id': document.id,
          'image': downloadUrl,
          "productName": productNametextEditingController.text.trim(),
          "descripton": descrptionEditingController.text.trim(),
          "code": codeEditingController.text.trim(),
          "owner": userId,
          "buyingPrice": buyingPrice,
          "sellingPrice": sellingPrice,
          "quantity": qntity,
          "measuremnet": measuremntEditingCotroller.text.trim(),
          "PostedAt": FieldValue.serverTimestamp(),
        });
        addExpenses();
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully'),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to add product'),
          ),
        );
      }
    }
  }

  Future addExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    if (userId != null) {
      var price = int.parse(buyingPriceEditingController.text.trim());
      var quantity = int.parse(quantiyEditingController.text.trim());

      var result = price * quantity;
      await documentExpenses.set({
        'id': documentExpenses.id,
        "date": FieldValue.serverTimestamp(),
        "owner": userId,
        "title": "Buying product",
        "price": result,
        "description": " this is the cost associated after buying product",
        "status": "approved",
        "PostedAt": FieldValue.serverTimestamp(),
      });

      // Navigator.pop(context);s
    }
  }

  final documentExpenses =
      FirebaseFirestore.instance.collection('expenses').doc();

  final document = FirebaseFirestore.instance.collection('products').doc();
}
