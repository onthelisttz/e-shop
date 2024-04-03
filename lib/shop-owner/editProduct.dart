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

      print("HEROOOOOOOOOOOOOOOOOOOOO");
      print(widget.docId);
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      print(data);
      print(data['productName']);
      print("product nName");

      _productNameController.text = data['productName'];
      _descriptionController.text = data['descripton'];
      _buyingPriceController.text = data['buyingPrice'].toString();
      _sellingPriceController.text = data['sellingPrice'].toString();
      _quantityController.text = data['quantity'].toString();
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
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
        title: Text("Edit Product",
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: editProductKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 18, left: 18, right: 18),
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
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                          controller: _productNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFf2dfce),
                            filled: true,
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              color: Color(0xFFe26f39),
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                              ),
                              onPressed: () {
                                _productNameController.clear();
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.title,
                              size: 16,
                              color: Color(0xFFe26f39),
                            ),
                            hintStyle: const TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.black),
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
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 1, left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                          controller: _buyingPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFf2dfce),
                            filled: true,
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              color: Color(0xFFe26f39),
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                              ),
                              onPressed: () {
                                _buyingPriceController.clear();
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.price_change,
                              size: 16,
                              color: Color(0xFFe26f39),
                            ),
                            hintStyle: const TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.black),
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
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 1, left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                          controller: _sellingPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFf2dfce),
                            filled: true,
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              color: Color(0xFFe26f39),
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                              ),
                              onPressed: () {
                                _sellingPriceController.clear();
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.price_change,
                              size: 16,
                              color: Color(0xFFe26f39),
                            ),
                            hintStyle: const TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.black),
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
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFf2dfce),
                            filled: true,
                            suffixIcon: IconButton(
                              color: Color(0xFFe26f39),
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                              ),
                              onPressed: () {
                                _quantityController.clear();
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.sanitizer_outlined,
                              size: 16,
                              color: Color(0xFFe26f39),
                            ),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.black),
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
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                          controller: _measurementController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFf2dfce),
                            filled: true,
                            suffixIcon: IconButton(
                              color: Color(0xFFe26f39),
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                              ),
                              onPressed: () {
                                _measurementController.clear();
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.kitchen_outlined,
                              size: 16,
                              color: Color(0xFFe26f39),
                            ),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.black),
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
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black),
                          controller: _descriptionController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFf2dfce),
                            filled: true,
                            suffixIcon: IconButton(
                              color: Color(0xFFe26f39),
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                              ),
                              onPressed: () {
                                _descriptionController.clear();
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.description,
                              size: 16,
                              color: Color(0xFFe26f39),
                            ),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: Colors.black),
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
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
                                    color: const Color(0xFFf2dfce),
                                  ),
                                  child: Container(
                                    child: _image == null
                                        ? _imageUrl.isNotEmpty
                                            ? Container(
                                                margin: const EdgeInsets.all(3),
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
                                        color: const Color(0xFFf2dfce),
                                        child: const Icon(
                                          Icons.add_a_photo,
                                          color: Color(0xFFe26f39),
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
                                side:
                                    MaterialStateProperty.all(const BorderSide(
                                  color: Color(0xFFe26f39),
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
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        Color(0xFFe26f39),
                                      ),
                                    ))
                                : const Text(
                                    ' Update Product',
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

      var buyingPrice = int.parse(_buyingPriceController.text.trim());
      var sellingPrice = int.parse(_sellingPriceController.text.trim());
      var qntity = int.parse(_quantityController.text.trim());
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.docId)
          .update({
        'productName': _productNameController.text,
        'descripton': _descriptionController.text,
        "buyingPrice": buyingPrice,
        "sellingPrice": sellingPrice,
        "quantity": qntity,
        'measuremnet': _measurementController.text,
        'image': imageUrl,
      });

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update product')),
      );
    }
  }
}
