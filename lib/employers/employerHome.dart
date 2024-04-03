import 'package:flutter/material.dart';

class EmployerHomepage extends StatefulWidget {
  const EmployerHomepage({super.key});
  static const String idScreen = "employerHompeage";

  @override
  State<EmployerHomepage> createState() => _EmployerHomepageState();
}

class _EmployerHomepageState extends State<EmployerHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFf2dfce),
        iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text('Employer', style: TextStyle(color: Colors.white)),
        ),
        elevation: 0,
      ),
      body: Container(
        child: Text("hellow"),
      ),
    );
  }
}
