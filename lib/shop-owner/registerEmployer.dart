import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/AllWigtes/Dialog.dart';
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

const List<String> list = <String>[
  'user',
  'lawyer',
];

class RegisterEmployerClass extends StatefulWidget {
  const RegisterEmployerClass({Key? key}) : super(key: key);
  static const String idScreen = "registerEmployer";

  @override
  _RegisterEmployerClassState createState() => _RegisterEmployerClassState();
}

TextEditingController nametextEditingController = TextEditingController();
TextEditingController emailtextEditingController = TextEditingController();
TextEditingController locationtextEditingController = TextEditingController();

TextEditingController PhoneNumbertextEditingController =
    TextEditingController();

bool isPasswordVisibleOne = true;
bool isPasswordVisible = true;

class _RegisterEmployerClassState extends State<RegisterEmployerClass> {
  final GlobalKey<FormState> reigsterUser = GlobalKey<FormState>();

  String dropdownValue = list.first;
  bool autoplays = false;
  bool showLoading = false;
  bool showLoadingWidget = false;
  String selectedCountry = 'user';
  bool _loading = false;

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
        key: reigsterUser,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'profile',
                  style: TextStyle(
                      fontSize: 11, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Center(
                child: Stack(
                  children: [
                    ClipOval(
                      child: InkWell(
                          onTap: () {
                            chooseImage();
                          },
                          child: CircleAvatar(
                            backgroundColor: const Color(0xFFf2dfce),
                            radius: 60,
                            child: ClipOval(
                              child: _image == null
                                  ? Container()
                                  : Container(
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: FileImage(_image!),
                                              fit: BoxFit.cover)),
                                    ),
                            ),
                          )),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 4,
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
                        ))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18, left: 18, right: 18),
                child: Text(
                  'Username.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: nametextEditingController,
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
                        nametextEditingController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "E.g john Doe",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'name required';
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Email Address.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: emailtextEditingController,
                  keyboardType: TextInputType.emailAddress,
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
                        emailtextEditingController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "E.g johnDoe@gmail.com",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "email required";
                    }

                    if (!RegExp(
                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 18, right: 18),
                child: Text(
                  'location.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
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
                    child: Center(
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: locationtextEditingController,
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
                              locationtextEditingController.clear();
                            },
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            size: 16,
                            color: Color(0xFFe26f39),
                          ),
                          hintStyle: const TextStyle(
                              fontSize: 11,
                              letterSpacing: 1,
                              color: Colors.white),
                          hintText: "Location",
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "location required";
                          }
                        },
                      ),
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 19, left: 18, right: 18),
                child: Text(
                  'Phone Number.',
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 1, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 18, right: 18),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: PhoneNumbertextEditingController,
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
                        PhoneNumbertextEditingController.clear();
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFFe26f39),
                    ),
                    hintStyle: const TextStyle(
                        fontSize: 11, letterSpacing: 1, color: Colors.black),
                    hintText: "Phone number",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "phone requred";
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () => registerEmployerImgaf(context),
                  child: Text("Send email")),
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
                            if (reigsterUser.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              registerEmployer(context);

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
                                Color.fromARGB(255, 255, 255, 255),
                              ),
                            ))
                        : const Text(
                            ' Register Employer',
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

  String generateRandomPassword(int length) {
    const String _chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random _rnd = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  registerEmployerImgaf(BuildContext context) async {
    try {
      print("hellow");
      String password =
          generateRandomPassword(8); // Change the length as needed
      print('Generated Password: $password');

      sendEmailToEmployer('msigwamb@gmail.com', password);
    } catch (e) {
      // Handle errors here
      displayToastMessage("Failed to upload image , $e", context);
      print("Error uploading image: $e");
      // You can also show an error message to the user using a Snackbar or Toast
    }
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  registerEmployer(BuildContext context) async {
    try {
      if (_image == null) {
        displayToastMessage("Image is required", context);
        return;
      }

      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: currentUser!.uid)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;

        print(userDoc);
        final userId = userDoc.id;
        print(userId);

        final productData = userDoc.data() as Map<String, dynamic>;

        print(productData);
        final String shopName = productData['shopName'];

        String password = generateRandomPassword(8);
        final firebaseUser =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailtextEditingController.text,
          password: password,
        );

        // Upload image to Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(_image!.path)}');
        await ref.putFile(_image!);
        final String downloadUrl = await ref.getDownloadURL();

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.user!.uid)
            .set({
          "id": firebaseUser.user!.uid,
          "displayName": nametextEditingController.text.trim(),
          "email": emailtextEditingController.text.trim(),
          "phoneNo": PhoneNumbertextEditingController.text.trim(),
          "location": locationtextEditingController.text.trim(),
          "shopName": shopName,
          "createdBy": currentUser!.uid,
          "mapLocation":
              const GeoPoint(-6.1659, 39.2026), // Your hardcoded coordinates
          "created_at": FieldValue.serverTimestamp(),
          "role": "employer",
          "PhotoUrl": downloadUrl,
        });

        sendEmailToEmployer(emailtextEditingController.text.trim(), password);

        // Update user display name
        await firebaseUser.user!
            .updateDisplayName(nametextEditingController.text.trim());

        // Update user email
        await firebaseUser.user!
            .verifyBeforeUpdateEmail(emailtextEditingController.text.trim());

        await FirebaseAuth.instance.signOut();
        _loading = false;
        // Navigator.pushReplacementNamed(
        //   context,
        //   LoginClass.idScreen,
        // );
        Navigator.pop(context);
        displayToastMessage("Your Employer has been created", context);
      }
    } catch (e) {
      // Handle errors here
      print("Error registering user: $e");
      // You can also show an error message to the user using a Snackbar or Toast
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  Future updateEmail(String newEmail, BuildContext context) async {
    var message;
    User? user = FirebaseAuth.instance.currentUser;
    user!
        .updateEmail(newEmail)
        .then(
          (value) => message,
        )
        .catchError(
          (onError) => message = displayToastMessage(
              "Error on displaying email $onError", context),
        );
    return message;
  }

  void sendEmailToEmployer(email, password) async {
    try {
      var message = """

  <h2>Verification 🕒</h2>

  <p>Dear ${email}, </p>

<p>Your password is <strong>${password}</strong>. Use that password to log in to the shop management app.</p>

""";

      if (email != null && email is String && email.isNotEmpty) {
        await sendEmailMessage(email, message); // Send email
      }
    } catch (error) {
      print('Error sending email: $error');
    }
  }
}
