import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/AllWigtes/Dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesDetails extends StatefulWidget {
  String? docId;

  ExpensesDetails({super.key, required this.docId});

  @override
  State<ExpensesDetails> createState() => _ExpensesDetailsState();
}

class _ExpensesDetailsState extends State<ExpensesDetails> {
  User? user = FirebaseAuth.instance.currentUser;

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

  // final Stream<QuerySnapshot> _usersStream = ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
        title: Text("Expenses",
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
      body: UserID != null
          ? Container(
              color: const Color.fromARGB(179, 241, 241, 241),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('expenses')
                    .where("id", isEqualTo: widget.docId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      // String userId = user!.uid;
                      // String otherUserId = userId == data['clientId']
                      //     ? data['lawyerId']
                      //     : data['clientId'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Expenses Details",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: data["status"] == "approved"
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            data["status"] == "approved"
                                                ? "Approved"
                                                : "Pending",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            color: Colors
                                                .grey, // Background color for the container
                                            child: const Center(
                                              child: Icon(
                                                Icons.monetization_on_rounded,
                                                color:
                                                    Colors.white, // Icon color
                                                size: 24, // Icon size
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Amount: ${data['price']}",
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 20, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          readTimestamp2(data["date"]),
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(Icons.access_time,
                                            size: 20, color: Colors.grey),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.description,
                                            size: 20, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            "Title: ${data["title"]}",
                                            style:
                                                const TextStyle(fontSize: 11),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.notes,
                                            size: 20, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            "Description: ${data["description"]}",
                                            style:
                                                const TextStyle(fontSize: 11),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: _buildApprovalButtons(data),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            )
          : Container(),
    );
  }

  Widget _buildApprovalButtons(data) {
    if (data["shopId"] == UserID && data["status"] == "pending") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              approveExpenses(widget.docId, "approved");
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Approve'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              approveExpenses(widget.docId, "rejected");
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Reject'),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Future approveExpenses(id, status) async {
    final document = FirebaseFirestore.instance.collection('expenses').doc(id);
    await document.update({
      "status": status,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Operation Perfomed successfull'),
      ),
    );
    Navigator.pop(context);
  }
}
