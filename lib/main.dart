import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/employers/employerHome.dart';
import 'package:e_shop/registration/login.dart';
import 'package:e_shop/registration/register.dart';
import 'package:e_shop/shop-owner/shopOwnerHomepage.dart';
import 'package:flutter/material.dart';

import 'package:splash_screen_view/SplashScreenView.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyDa_gqaPrO_3ecLJoY5x8Sw3R8Gbzx8Mqk',
        appId: '1:20729682081:web:9b5789134508c0c21e38e0',
        messagingSenderId: '20729682081',
        projectId: 'e-shop-be81f',
        databaseURL: 'https://e-shop-be81f-default-rtdb.firebaseio.com',
        storageBucket: 'e-shop-be81f.appspot.com',
        measurementId: "G-J8C136M5EG"),
  );

  runApp(const MyApp());
}

DatabaseReference userRef = FirebaseDatabase.instance.reference().child("user");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: FirebaseAuth.instance.currentUser != null
          ? const RoleChecker()
          : const LoginClass(),
      duration: 5000,
      // imageSize: 130,
      // imageSrc: "logo.jpg",
      text: "E-shop",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );
    return MaterialApp(
      title: 'E-Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: example1,
      home: FirebaseAuth.instance.currentUser != null
          ? const RoleChecker()
          : const LoginClass(),
      routes: {
        ShopOwnerHomepage.idScreen: (context) => ShopOwnerHomepage(),
        EmployerHomepage.idScreen: (context) => const EmployerHomepage(),
        RegisterClass.idScreen: (context) => RegisterClass(),
        LoginClass.idScreen: (context) => LoginClass(),
      },
    );
  }
}

// flutter pub run splash_screen_view:create
// flutter build appbundle
// flutter clean
// #f05929
// rename setAppName --targets ios,android --value "E-lawyer"
// adb connect 10.25.202.202:5555

class RoleChecker extends StatefulWidget {
  const RoleChecker({Key? key}) : super(key: key);

  @override
  _RoleCheckerState createState() => _RoleCheckerState();
}

class _RoleCheckerState extends State<RoleChecker> {
  String role = '';

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
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

      if (snap.exists) {
        // Check if the document exists
        final data = snap.data() as Map<String, dynamic>?; // Explicit cast
        if (data != null && data.containsKey('role')) {
          // Check if the 'role' field exists in the document
          String userRole = data['role'];

          setState(() {
            role = userRole;
          });

          // Navigation logic...
          if (role == 'owner') {
            Navigator.pushNamedAndRemoveUntil(
                context, ShopOwnerHomepage.idScreen, (route) => false);
          } else if (role == 'employer') {
            // Replace 'LawyerHomePage' with the actual name of your lawyer home page
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    ); // You can return an empty container here
  }
}
