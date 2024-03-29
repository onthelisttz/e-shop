import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String readTimestamp(Timestamp timestamp) {
  var now = DateTime.now();
  var format = DateFormat('EEE, MMM d, ' 'hh:mm a');
  var date = timestamp.toDate();
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' Day ago';
    } else {
      time = diff.inDays.toString() + ' Days ago';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' Week ago';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' Weeks ago';
    }
  }

  return time;
}

String readTimestamp2(Timestamp timestamp) {
  var now = DateTime.now();
  var format = DateFormat('EEE, MMM d, ' 'hh:mm a');
  var date = timestamp.toDate();
  var diff = now.difference(date);
  var time = '';

  time = format.format(date);

  return time;
}

class proressDialogue extends StatelessWidget {
  String messsage;
  proressDialogue({
    Key? key,
    required this.messsage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.yellow,
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(
                width: 15.0,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              SizedBox(
                width: 26.0,
              ),
              Text(
                messsage,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}

const myGoogleApiKey = 'AIzaSyBPk3-sjJDBZfO4jcX-UlrEXJ4A5IdDW-A';
