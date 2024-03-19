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
// TextEditingController descrptionEditingController = TextEditingController();

class _RegisterClassState extends State<AddProduct> {
  final GlobalKey<FormState> addProductKey = GlobalKey<FormState>();

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
        key: addProductKey,
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
                  controller: buyingPriceEditingController,
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
                        buyingPriceEditingController.clear();
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
                padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
                child: Text(
                  'Selling Price.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: sellingPriceEditingController,
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
                        sellingPriceEditingController.clear();
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
                      return 'Selling price required';
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
                        descrptionEditingController.clear();
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
                padding: const EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Measurement.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: measuremntEditingCotroller,
                  keyboardType: TextInputType.text,
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
                        descrptionEditingController.clear();
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.kitchen_outlined,
                      size: 16,
                      color: Color.fromARGB(255, 177, 237, 237),
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.white),
                    hintText: "Measurement of the product",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Measurement is required";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Description.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: descrptionEditingController,
                  keyboardType: TextInputType.text,
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
                        descrptionEditingController.clear();
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.description,
                      size: 16,
                      color: Color.fromARGB(255, 177, 237, 237),
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.white),
                    hintText: "Write a short description of the product",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Description is required";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                            color: Color(0xFF009999),
                          ),
                          child: Container(
                            child: _image == null
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.all(3),
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
                            padding: EdgeInsets.all(3.0),
                            child: ClipOval(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                color: Color.fromARGB(255, 177, 237, 237),
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Color(0xFF009999),
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
              SizedBox(
                height: 20,
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
                            if (addProductKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              addProduct();

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
                            ' Add Product',
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

  addProduct() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_image!.path)}');
      await ref.putFile(_image!);
      final String downloadUrl = await ref.getDownloadURL();

      await document.set({
        'id': document.id,
        'image': downloadUrl,
        "productName": productNametextEditingController.text.trim(),
        "descripton": descrptionEditingController.text.trim(),
        "owner": user!.uid,
        "buyingPrice": buyingPriceEditingController.text.trim(),
        "sellingPrice": sellingPriceEditingController.text.trim(),
        "quantity": quantiyEditingController.text.trim(),
        "measuremnet": measuremntEditingCotroller.text.trim(),
        "PostedAt": FieldValue.serverTimestamp(),
      });
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('product added Successfull'),
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

  final document = FirebaseFirestore.instance.collection('products').doc();
}
