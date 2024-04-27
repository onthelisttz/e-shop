import 'package:e_shop/shop-owner/dashbord.dart';
import 'package:e_shop/shop-owner/shopOwnerHomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  String name;

  Product(this.name);
}

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);
  static const String idScreen = "AddBudgetScreen";
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _importantProductController =
      TextEditingController();
  final TextEditingController _unimportantProductController =
      TextEditingController();
  final _format = NumberFormat('##,###,###');
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Product> _importantProducts = [];
  List<Product> _unimportantProducts = [];

  double _remainingBudget = 0.0;
  double _importantBudget = 0.0;
  double _unimportantBudget = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
        title: Text("Add Budget",
            style:
                TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 14)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 18, left: 18, right: 18),
                child: Text(
                  'Budget',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateRemainingBudget(),
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
                        _budgetController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Eg: enter budget",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Budget is required';
                    }
                  },
                ),
              ),

              // TextField(
              //   controller: _budgetController,
              //   decoration: InputDecoration(labelText: 'Enter Budget'),
              //   keyboardType: TextInputType.number,
              //   onChanged: (_) => _calculateRemainingBudget(),
              // ),

              SizedBox(height: 20.0),
              Center(
                child: Text(
                  'Direct Cost',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: Text(
                  'Rent',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: _rentController,
                  onChanged: (_) => _calculateRemainingBudget(),
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
                        _rentController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Eg: enter Rent",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Rent is required';
                    }
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 18, left: 18, right: 18),
                child: Text(
                  'Salary',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: _salaryController,
                  onChanged: (_) => _calculateRemainingBudget(),
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
                        _salaryController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Eg: enter Salary",
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 18, left: 18, right: 18),
                child: Text(
                  'Emergency',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: _emergencyController,
                  onChanged: (_) => _calculateRemainingBudget(),
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
                        _emergencyController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Eg: enter Emergency",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Emergency is required';
                    }
                  },
                ),
              ),

              // SizedBox(height: 20.0),
              // _remainingBudget != null
              //     ? Text('Remaining Budget: $_remainingBudget')
              //     : Container(),

              // SizedBox(height: 20.0),

              SizedBox(height: 20.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Important Products',
                      style: TextStyle(
                          fontSize: 14, letterSpacing: 1, color: Colors.black),
                    ),
                    _importantBudget != 0.0
                        ? Text(
                            ' (60%: ${_format.format(_importantBudget)})',
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1,
                                color: Colors.black),
                          )
                        : Container()
                  ],
                ),
              ),

              _buildProductInput(
                  _importantProductController, _addImportantProduct),
              SizedBox(height: 20.0),
              _buildProductList(_importantProducts, _removeImportantProduct),
              SizedBox(height: 20.0),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Unimportant Products',
                      style: TextStyle(
                          fontSize: 14, letterSpacing: 1, color: Colors.black),
                    ),
                    _importantBudget != 0.0
                        ? Text(
                            ' (40%: ${_format.format(_unimportantBudget)})',
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1,
                                color: Colors.black),
                          )
                        : Container()
                  ],
                ),
              ),

              _buildProductInput(
                  _unimportantProductController, _addUnimportantProduct),
              SizedBox(height: 20.0),
              _buildProductList(
                  _unimportantProducts, _removeUnimportantProduct),
              SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFf2dfce),
                              ),
                              side: MaterialStateProperty.all(const BorderSide(
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
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _loading = true;
                                    });
                                    // registerNewUser(context);
                                    _saveToFirestore();

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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInput(
      TextEditingController controller, Function(String) onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 18, left: 18, right: 18),
          child: Text(
            'Product Name',
            style:
                TextStyle(fontSize: 14, letterSpacing: 1, color: Colors.black),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                  controller: controller,
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
                        controller.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Eg: enter Product",
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    onPressed(controller.text);
                    controller.clear();
                  }
                },
                icon: Icon(Icons.add))
          ],
        ),

        // TextField(
        //   controller: controller,
        //   decoration: InputDecoration(labelText: 'Product Name'),
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     if (controller.text.isNotEmpty) {
        //       onPressed(controller.text);
        //       controller.clear();
        //     }
        //   },
        //   child: Text('Add Product'),
        // ),
      ],
    );
  }

  Widget _buildProductList(List<Product> products, Function(int) onRemove) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            // ignore: prefer_const_constructors

            child: ListTile(
              title: Text(products[index].name),
              trailing: IconButton(
                icon: Icon(color: Color(0xFFe26f39), Icons.delete),
                onPressed: () => onRemove(index),
              ),
            ),
          ),
        );
      },
    );
  }

  void _calculateRemainingBudget() {
    double budget = double.tryParse(_budgetController.text) ?? 0.0;
    double rent = double.tryParse(_rentController.text) ?? 0.0;
    double salary = double.tryParse(_salaryController.text) ?? 0.0;
    double emergency = double.tryParse(_emergencyController.text) ?? 0.0;

    double totalDirectCost = rent + salary + emergency;
    setState(() {
      _remainingBudget = budget - totalDirectCost;
      _allocateBudget();
    });
  }

  void _allocateBudget() {
    if (_remainingBudget != null) {
      _importantBudget = _remainingBudget * 0.6;
      _unimportantBudget = _remainingBudget * 0.4;
    }
  }

  void _addImportantProduct(String productName) {
    setState(() {
      if (!_importantProducts.any((product) => product.name == productName)) {
        _importantProducts.add(Product(productName));
      }
    });
  }

  void _addUnimportantProduct(String productName) {
    setState(() {
      if (!_unimportantProducts.any((product) => product.name == productName)) {
        _unimportantProducts.add(Product(productName));
      }
    });
  }

  void _removeImportantProduct(int index) {
    setState(() {
      _importantProducts.removeAt(index);
    });
  }

  void _removeUnimportantProduct(int index) {
    setState(() {
      _unimportantProducts.removeAt(index);
    });
  }

  Future<void> _saveToFirestore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the user ID from SharedPreferences
    String? userId = prefs.getString('userId');
    if (userId != null) {
      double rent = double.tryParse(_rentController.text) ?? 0.0;
      double salary = double.tryParse(_salaryController.text) ?? 0.0;
      double emergency = double.tryParse(_emergencyController.text) ?? 0.0;

      // Calculate the price per product for important and unimportant products
      double importantProductPrice =
          _importantBudget / _importantProducts.length;
      double unimportantProductPrice =
          _unimportantBudget / _unimportantProducts.length;

      FirebaseFirestore.instance
          .collection('budget')
          .where('owner', isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // If a document already exists for the user, handle this case (e.g., show an error message)
          setState(() {
            _loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Failed To add Budget, this Shop has already have budget'),
            ),
          );
        } else {
          // If no document exists for the user, add the new budget document
          FirebaseFirestore.instance.collection('budget').add({
            'totalBudget': double.tryParse(_budgetController.text) ?? 0.0,
            "unimportantBudget": _unimportantBudget,
            "importantBudget": _importantBudget,
            "PostedAt": FieldValue.serverTimestamp(),
            "owner": userId,
            'directCost': {
              'rent': rent,
              'salary': salary,
              'emergency': emergency,
            },
            'remainingBudget': _remainingBudget,
            'importantProducts': _importantProducts.map((product) {
              // Create subcollection for important products
              return {
                'name': product.name,
                'id': FirebaseFirestore.instance.collection('budget').doc().id,
                'price': importantProductPrice,
              };
            }).toList(),
            'unimportantProducts': _unimportantProducts.map((product) {
              // Create subcollection for unimportant products
              return {
                'name': product.name,
                'id': FirebaseFirestore.instance.collection('budget').doc().id,
                'price': unimportantProductPrice,
              };
            }).toList(),
          }).then((value) {
            // Handle success

            FirebaseFirestore.instance
                .collection('users')
                .doc(
                  userId,
                )
                .update({
              "isBudgetAdded": true,
            });

            setState(() {
              _loading = false;
            });

            Navigator.pushNamedAndRemoveUntil(
                context, ShopOwnerHomepage.idScreen, (route) => false);
          }).catchError((error) {
            // Handle error
            print('Failed to save budget: $error');
          });
        }
      }).catchError((error) {
        // Handle errors
        print('Failed to check existing budget documents: $error');
      });
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _rentController.dispose();
    _salaryController.dispose();
    _emergencyController.dispose();
    _importantProductController.dispose();
    _unimportantProductController.dispose();
    super.dispose();
  }
}
