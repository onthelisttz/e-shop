import 'package:flutter/material.dart';

class ShopOwnerHomepage extends StatefulWidget {
  const ShopOwnerHomepage({super.key});
  static const String idScreen = "shopOwnerHomepage";

  @override
  State<ShopOwnerHomepage> createState() => _ShopOwnerHomepageState();
}

class _ShopOwnerHomepageState extends State<ShopOwnerHomepage> {
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
          child: Text('Shop', style: TextStyle(color: Colors.white)),
        ),
        elevation: 0,
      ),
      body: Container(
        child: Text("hellow"),
      ),
    );
  }
}
