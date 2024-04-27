import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
TextEditingController codeEditingController = TextEditingController();

// TextEditingController descrptionEditingController = TextEditingController();

class _RegisterClassState extends State<AddSales> {
  final GlobalKey<FormState> AddSalesKey = GlobalKey<FormState>();

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
        title: Text("Add Sales",
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
        key: AddSalesKey,
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
                    hintText: "product Code",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "code is required";
                    }
                  },
                ),
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
                            if (AddSalesKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              addSales();

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
                            ' Add Sales',
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

  User? user = FirebaseAuth.instance.currentUser;

  // Your AddSales method with product update
  Future<void> addSales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    if (userId != null) {
      try {
        final productQuery = await FirebaseFirestore.instance
            .collection('products')
            .where('code', isEqualTo: codeEditingController.text.trim())
            .limit(1)
            .get();

        if (productQuery.docs.isNotEmpty) {
          print("PRODUCT FOUNDDDDDDDDDDDDDDDDDDDDDDDDD");
          final productDoc = productQuery.docs.first;

          print(productDoc);
          final productId = productDoc.id;
          print(productId);
          final productData = productDoc.data() as Map<String, dynamic>;
          print("product data is");
          print(productData);
          final int availableQuantity = productData['quantity'] ?? 0;
          final int soldQuantity =
              int.parse(quantiyEditingController.text.trim());

          print(soldQuantity);
          print(availableQuantity);
          // Check if there is enough quantity available for sale
          if (soldQuantity <= availableQuantity) {
            // Update product quantity
            await FirebaseFirestore.instance
                .collection('products')
                .doc(productId)
                .update({
              'quantity': availableQuantity - soldQuantity,
            });
            final document =
                FirebaseFirestore.instance.collection('sales').doc();
            // Add sale
            await document.set({
              'id': document.id,
              "productName": productNametextEditingController.text.trim(),
              "code": codeEditingController.text.trim(),
              "postedBy": userId,
              "price": int.parse(priceEditingController.text.trim()),
              "quantity": soldQuantity,
              "PostedAt": FieldValue.serverTimestamp(),
            });

            setState(() {
              _loading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sales added successfully'),
              ),
            );
            Navigator.pop(context);
          } else {
            // Insufficient quantity available for sale
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Insufficient quantity available for sale.'),
              ),
            );
            setState(() {
              _loading = false;
            });
          }
        } else {
          print("PRODUCT NOT FOUNDDDDDDDDD");
          // Product not found
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Product not found with that code. Unable to add sale.'),
            ),
          );
          setState(() {
            _loading = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to add sale'),
          ),
        );
        setState(() {
          _loading = false;
        });
      }
    }

    // AddSales() async {
    //   try {
    //     await document.set({
    //       'id': document.id,
    //       "productName": productNametextEditingController.text.trim(),
    //       "code": codeEditingController.text.trim(),
    //       "postedBy": userId,
    //       "price": priceEditingController.text.trim(),
    //       "quantity": quantiyEditingController.text.trim(),
    //       "PostedAt": FieldValue.serverTimestamp(),
    //     });
    //     setState(() {
    //       _loading = false;
    //     });
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('sales added Successfull'),
    //       ),
    //     );
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Unable to add product'),
    //       ),
    //     );
    //   }

    //   // Navigator.pop(context);
    // }

    // final document = FirebaseFirestore.instance.collection('sales').doc();
  }
}
