import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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

class EditProduct extends StatefulWidget {
  final String? docId;

  EditProduct({Key? key, required this.docId}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> editProductKey = GlobalKey<FormState>();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _buyingPriceController = TextEditingController();
  TextEditingController _sellingPriceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _measurementController = TextEditingController();

  bool _loading = false;
  String _imageUrl = ''; // Store the current image URL
  File? _image;

  @override
  void initState() {
    super.initState();
    getProductDetails();
  }

  void getProductDetails() async {
    try {
      setState(() {
        _loading = true;
      });
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.docId)
          .get();

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      _productNameController.text = data['productName'];
      _descriptionController.text = data['descripton'];
      _buyingPriceController.text = data['buyingPrice'];
      _sellingPriceController.text = data['sellingPrice'];
      _quantityController.text = data['quantity'];
      _measurementController.text = data['measuremnet'];
      _imageUrl = data['image']; // Initialize with current image URL
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: editProductKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 18, left: 18, right: 18),
                        child: Text(
                          'Product Name.',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 1, left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _productNameController,
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
                                _productNameController.clear();
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.title,
                              size: 16,
                              color: Color.fromARGB(255, 177, 237, 237),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.white),
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
                        padding:
                            const EdgeInsets.only(top: 18, left: 18, right: 18),
                        child: Text(
                          'Buying Price.',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 1, left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _buyingPriceController,
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
                                _buyingPriceController.clear();
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.price_change,
                              size: 16,
                              color: Color.fromARGB(255, 177, 237, 237),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.white),
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
                        padding:
                            const EdgeInsets.only(top: 18, left: 18, right: 18),
                        child: Text(
                          'Selling Price.',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 1, left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _sellingPriceController,
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
                                _sellingPriceController.clear();
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.price_change,
                              size: 16,
                              color: Color.fromARGB(255, 177, 237, 237),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.white),
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
                        padding:
                            const EdgeInsets.only(top: 19, left: 18, right: 18),
                        child: Text(
                          'Quantity.',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _quantityController,
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
                                _quantityController.clear();
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.sanitizer_outlined,
                              size: 16,
                              color: Color.fromARGB(255, 177, 237, 237),
                            ),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.white),
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
                        padding:
                            const EdgeInsets.only(top: 19, left: 18, right: 18),
                        child: Text(
                          'Measurement.',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _measurementController,
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
                                _measurementController.clear();
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.kitchen_outlined,
                              size: 16,
                              color: Color.fromARGB(255, 177, 237, 237),
                            ),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.white),
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
                        padding:
                            const EdgeInsets.only(top: 19, left: 18, right: 18),
                        child: Text(
                          'Description.',
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _descriptionController,
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
                                _descriptionController.clear();
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.description,
                              size: 16,
                              color: Color.fromARGB(255, 177, 237, 237),
                            ),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.white),
                            hintText:
                                "Write a short description of the product",
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
                              fontSize: 11,
                              letterSpacing: 1,
                              color: Colors.black),
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
                                        ? _imageUrl.isNotEmpty
                                            ? Container(
                                                margin: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image:
                                                        NetworkImage(_imageUrl),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : Container()
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
                                        color:
                                            Color.fromARGB(255, 177, 237, 237),
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
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            onPressed: _loading
                                ? null
                                : () {
                                    if (editProductKey.currentState!
                                        .validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      updateProduct();

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
                                    ' Update Product',
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
            ),
    );
  }

  bool isEnabled = true;
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;
  // File? _image;

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

  void updateProduct() async {
    try {
      setState(() {
        _loading = true;
      });

      String imageUrl = _imageUrl; // Default to current image URL
      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(_image!.path)}');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.docId)
          .update({
        'productName': _productNameController.text,
        'descripton': _descriptionController.text,
        'buyingPrice': _buyingPriceController.text,
        'sellingPrice': _sellingPriceController.text,
        'quantity': _quantityController.text,
        'measuremnet': _measurementController.text,
        'image': imageUrl,
      });

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product')),
      );
    }
  }
}
