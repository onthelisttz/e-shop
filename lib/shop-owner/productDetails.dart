import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetails extends StatelessWidget {
  final String? docId;

  ProductDetails({Key? key, required this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
        title: Text("Product Details",
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
      body: Container(
        color: const Color.fromARGB(179, 241, 241, 241),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc(docId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.network(
                              data['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.description,
                              size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Name: ${data["productName"]}",
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.monetization_on_rounded,
                              size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Buying Price: \$${data['buyingPrice']}',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.monetization_on,
                              size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Selling Price: \$${data['sellingPrice']}',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.code, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Code: \$${data['code']}',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.sports_hockey,
                              size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Quantity: ${data['quantity']}',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.square_foot,
                              size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Measuremnt: ${data['measuremnet']}',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.notes, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Description: ${data["descripton"]}",
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      // Add more details as needed
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
