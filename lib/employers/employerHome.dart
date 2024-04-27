import 'package:e_shop/employers/employerExpensesList.dart';
import 'package:e_shop/employers/employerSalesList.dart';
import 'package:e_shop/shop-owner/addExpenses.dart';
import 'package:e_shop/shop-owner/addProduct.dart';
import 'package:e_shop/shop-owner/addSales.dart';
import 'package:e_shop/shop-owner/dashbord.dart';
import 'package:e_shop/shop-owner/listExpenses.dart';
import 'package:e_shop/shop-owner/salesList.dart';
import 'package:e_shop/shop-owner/shopProgressChart.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'dart:collection';
import 'dart:io';
import 'dart:math' as Math;

import '../sharedPages/Profile.dart';

class EmployerHomepage extends StatefulWidget {
  const EmployerHomepage({
    Key? key,
  }) : super(key: key);
  static const String idScreen = "employerHompeage";
  @override
  _EmployerHomepageState createState() => _EmployerHomepageState();
}

final _scaffoldKeys = GlobalKey<ScaffoldState>();

class _EmployerHomepageState extends State<EmployerHomepage> {
  bool _showBottom = false;

  List<NetworkImage> _listOfImages = <NetworkImage>[];
  bool autoplays = false;
  bool showLoading = false;
  bool showLoadingWidget = false;

  final User? currentUser = FirebaseAuth.instance.currentUser;

  final _firestore = FirebaseFirestore.instance;

  int size = 0;
  final User? auth = FirebaseAuth.instance.currentUser;

  DateTime timeBackPressed = DateTime.now();

  int? _currentIndex;
  int _counter = 0;
  bool? _showAppBar;
  bool? _showAppList;
  final _inactiveColor = Colors.black.withOpacity(0.5);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    _currentIndex = 0;
    _showAppBar = false;
    _showAppList = false;

    super.initState();
  }

  int currentIndexT = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          const message = 'Press back again to exit';
          Fluttertoast.showToast(
              backgroundColor: const Color(0xFFf2f2f2),
              textColor: Colors.black,
              msg: message,
              fontSize: 18);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const EmployerSalesList(),
            const EmployerExpenses(),
            const Profile()

            // HomePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex!,
          fixedColor: const Color(0xFFe26f39),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              // icon: Icon(MdiIcons.bookmark),
              icon: Icon(Icons.production_quantity_limits),
              backgroundColor: Color(0xFFe26f39),
              label: 'Sales',
            ),
            BottomNavigationBarItem(
              // icon: Icon(MdiIcons.bookmark),
              icon: Icon(Icons.card_giftcard_outlined),
              backgroundColor: Color(0xFFe26f39),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: Color(0xFFe26f39),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              setState(() {
                _currentIndex = index;
                _showAppList = true;
              });

              print(_currentIndex);
            } else {
              setState(() {
                _currentIndex = index;
                _showAppList = false;
              });
            }
          },
        ),
      ),
    );
  }
}
