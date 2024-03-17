// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/employers/employerHome.dart';
import 'package:e_shop/registration/register.dart';
import 'package:e_shop/shop-owner/shopOwnerHomepage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class LoginClass extends StatefulWidget {
  const LoginClass({Key? key}) : super(key: key);
  static const String idScreen = "login";
  @override
  _LoginClassState createState() => _LoginClassState();
}

TextEditingController emailtextEditingController = TextEditingController();
TextEditingController passwordtextEditingController = TextEditingController();

bool isPasswordVisibleOne = true;
bool isPasswordVisible = true;

class _LoginClassState extends State<LoginClass> {
  final GlobalKey<FormState> loginUserKey = GlobalKey<FormState>();
  String role = 'user';
  bool emaild = false;
  bool passwordoned = false;
  String emailtext = 'email required';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009999),
        iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text('Login', style: TextStyle(color: Colors.white)),
        ),
        elevation: 0,
      ),
      body: Form(
        key: loginUserKey,
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.9, bottom: 8.0),
          child: ListView(
            children: [
              // Image(image: AssetImage('assets/heavy.jpg')),
              Image(image: AssetImage('images/shop2.png')),
              Padding(
                padding: const EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Name.',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: emailtextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: Color(0xFF009999),

                    filled: true,
                    prefixIcon: Icon(
                      Icons.email,
                      size: 16,
                      color: Color.fromARGB(255, 177, 237, 237),
                    ),

                    suffixIcon: IconButton(
                      color: Color.fromARGB(255, 177, 237, 237),
                      icon: Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onPressed: () {
                        emailtextEditingController.clear();
                      },
                    ),
                    // prefixIconConstraints: BoxConstraints(
                    //   maxHeight: 10,
                    //   maxWidth: 20,
                    // ),
                    // prefixIcon: Icon(
                    //   Icons.email,
                    //   size: 16,
                    //   color: Color.fromARGB(255, 177, 237, 237),
                    // ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                    hintText: "E.g johnDoe@gmail.com",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'email is reqired';
                    }

                    if (!RegExp(
                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Enter a Password.',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: passwordtextEditingController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: isPasswordVisibleOne,
                  // keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    fillColor: Color(0xFF009999),
                    filled: true,
                    suffixIcon: IconButton(
                      color: Color.fromARGB(255, 177, 237, 237),
                      icon: isPasswordVisibleOne
                          ? Icon(
                              Icons.visibility_off,
                              size: 16,
                            )
                          : Icon(
                              Icons.visibility,
                              size: 16,
                            ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisibleOne = !isPasswordVisibleOne;
                        });
                      },
                    ),

                    // prefixIcon: Icon(
                    //   Icons.lock,
                    //   size: 16,
                    //   color: Color.fromARGB(255, 177, 237, 237),
                    // ),
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 16,
                      color: Color.fromARGB(255, 177, 237, 237),
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                    hintText: "****",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'password is required';
                    }
                  },
                ),
              ),

              SizedBox(
                height: 5,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF009999),
                        ),
                        side: MaterialStateProperty.all(BorderSide(
                          color: Color(0xFF009999),
                        )),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: _loading
                        ? null
                        : () {
                            if (loginUserKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              LoginAndAutheniticateUser(context);
                            }
                          },
                    child: _loading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                            ))
                        : Text(
                            ' login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          )),
              ),

              Align(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return RegisterClass();
                        }));
                      },
                      child: Text(
                        "You dont Have Account Register",
                        style: TextStyle(
                          color: Color(0xFF383840),
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void LoginAndAutheniticateUser(BuildContext context) async {
    try {
      final User? firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(
              email: emailtextEditingController.text,
              password: passwordtextEditingController.text))
          .user;

      if (firebaseUser != null) {
        // Navigator.pushNamedAndRemoveUntil(
        //     context, MyHomePage.idScreen, (route) => false);
        displayToastMessage("Login succesfull", context);
        _chekRole();
      }

      // Navigator.pushNamedAndRemoveUntil(
      //     context, MyHomePage.idScreen, (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
      });
      if (e.code == 'user-not-found') {
        displayToastMessage("User not found", context);
      } else if (e.code == 'wrong-password') {
        displayToastMessage("Wrong password", context);
      }
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  void _chekRole() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle case where user is not authenticated
        return;
      }

      final DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      print("check role");
      print("ROLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
      print(user.uid);
      if (snap.exists) {
        print(
            "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
        // Check if the document exists
        final data = snap.data() as Map<String, dynamic>?; // Explicit cast
        if (data != null && data.containsKey('role')) {
          // Check if the 'role' field exists in the document
          String userRole = data['role'];
          print("ROLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
          setState(() {
            role = userRole;
          });
          // Navigation logic...
          if (role == 'owner') {
            Navigator.pushNamedAndRemoveUntil(
                context, ShopOwnerHomepage.idScreen, (route) => false);
          } else if (role == 'employer') {
            Navigator.pushNamedAndRemoveUntil(
                context, EmployerHomepage.idScreen, (route) => false);
          }
        } else {
          // Handle case where 'role' field is missing
          setState(() {
            role = 'unknown_role';
          });
        }
      } else {
        print("NOT FOUNDDDDDDDDDDDDDDDDDDDDDDDDDDD");
        // Handle case where document doesn't exist
        setState(() {
          role = 'user_not_found';
        });
      }
    } catch (e) {
      // Handle errors
      print("Error checking user role: $e");
      setState(() {
        role = 'error';
      });
    }
  }
}
