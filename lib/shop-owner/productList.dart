import 'package:e_shop/shop-owner/addProduct.dart';
import 'package:e_shop/shop-owner/editProduct.dart';
import 'package:e_shop/shop-owner/productDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AllWigtes/Dialog.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  User? user = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where("owner", isEqualTo: user!.uid)
      .snapshots();
  Map<String, bool> selectedProducts = {};
  Map<String, double> productPrices = {};
  double sellingPrice = 0.0;

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
      UserID = userId;
    }
  }

  void updateSellingPrice() {
    double price = 0.0;
    selectedProducts.forEach((productName, isSelected) {
      if (isSelected) {
        // Add the selling price of the selected product to the total selling price
        price += productPrices[productName] ?? 0.0;
      }
    });

    setState(() {
      sellingPrice = price;
    });
  }

  final _format = NumberFormat('##,###,###');
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
          child: Text('Products',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.9), fontSize: 14)),
        ),
        elevation: 0,
      ),
      body: UserID != null
          ? Container(
              child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where("owner", isEqualTo: UserID)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String productName = data['productName'];
                      int productPrice = data[
                          'sellingPrice']; // Fetch selling price from Firestore
                      productPrices[productName] = productPrice
                          .toDouble(); // Store selling price in the map

                      // return CheckboxListTile(
                      //   title: Text(productName),
                      //   value: selectedProducts.containsKey(productName)
                      //       ? selectedProducts[productName]
                      //       : false,
                      //   onChanged: (bool? value) {
                      //     setState(() {
                      //       selectedProducts[productName] = value!;
                      //       updateSellingPrice();
                      //     });
                      //   },
                      //   controlAffinity: ListTileControlAffinity.trailing,
                      // );

                      String price =
                          '\Tsh ${_format.format(data['sellingPrice'])}';
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 12.0, top: 2, right: 4, left: 4),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 2,
                            child: InkWell(
                              onTap: () async {
                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(builder: (BuildContext context) {
                                //   return TheDetais();
                                // }));
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        height: 200.0,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                              ),
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return ProductDetails(
                                                    docId: data['id'],
                                                  );
                                                }));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                ),
                                                child: Image.network(
                                                  data['image'],
                                                  fit: BoxFit.cover,
                                                  height:
                                                      220, // Adjust height as needed
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: 10,
                                          left: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFf2dfce),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Checkbox(
                                              value: selectedProducts
                                                      .containsKey(productName)
                                                  ? selectedProducts[
                                                      productName]
                                                  : false,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  selectedProducts[
                                                      productName] = value!;
                                                  updateSellingPrice();
                                                });
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                side: const BorderSide(
                                                    color: Color(
                                                        0xFFe26f39)), // Border color
                                              ),
                                              fillColor: MaterialStateProperty
                                                  .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return const Color(
                                                        0xFFe26f39); // Change the color of the checkbox when selected
                                                  }
                                                  return Colors.transparent;
                                                  // Use transparent color when not selected
                                                },
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 6.0,
                                      bottom: 0.0,
                                      top: 8.0,
                                      right: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('code: ${data['code']}',
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFe26f39),
                                            )
                                            // style: TextStyle(
                                            //   fontSize: 16,
                                            //   fontWeight: FontWeight.bold,
                                            // ),
                                            ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return EditProduct(
                                                docId: data['id'],
                                              );
                                            }));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            // primary: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: const Text('Edit'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      bottom: 6.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['productName'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          // style: TextStyle(
                                          //     fontSize: 13,
                                          //     fontWeight: FontWeight.bold,
                                          //     color: Color(0xFF3D3D3D)
                                          //     )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.only(top: 2, right: 4),
                                          child: Icon(
                                            Icons.price_change,
                                            size: 13,
                                            color: Color(0xFFe26f39),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(price,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.sports_hockey,
                                                size: 14,
                                                color: Color(0xFFe26f39),
                                              ),
                                              Row(
                                                children: [
                                                  const Text('  Quantity   ',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF3D3D3D),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                  Text(
                                                      data['quantity']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.square_foot,
                                                  size: 14,
                                                  color: Color(0xFFe26f39),
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                        '  Measurement   ',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF3D3D3D),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        )),
                                                    Text(data['measuremnet'],
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8, top: 5, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.lock_clock,
                                              size: 16,
                                              color: Color(0xFFe26f39),
                                            ),
                                            Text(
                                                data['PostedAt'] != null
                                                    ? readTimestamp2(
                                                        data['PostedAt'])
                                                    : "No timestamp",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 8.0, bottom: 8, top: 5, right: 8),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     children: [
                                  //       // Text('Listed by ' + widget.data['PostedByOwner'],
                                  //       //     style: TextStyle(
                                  //       //       fontSize: 12,
                                  //       //     )),
                                  //       Icon(
                                  //         MdiIcons.clock,
                                  //         size: 16,
                                  //       ),
                                  //       Text(readTimestamp(widget.data['PostedAt']),
                                  //           style: TextStyle(
                                  //             fontSize: 12,
                                  //           )),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
            ))
          : Container(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'productList',
        onPressed: () {
          // Add your onPressed action here
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return const AddProduct();
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
      bottomNavigationBar: sellingPrice != 0
          ? BottomAppBar(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Center(
                    child: Text(
                      'Total Price: \Tsh ${_format.format(sellingPrice)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
