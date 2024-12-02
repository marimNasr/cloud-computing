import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/message.dart';

class ChatSentWidget extends StatelessWidget {
  const ChatSentWidget({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    // Assume createdAt is already a DateTime object
    DateTime createdAt = message.createdAt;
    String formattedTime = DateFormat('MMM dd, hh:mm a').format(createdAt);

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          color: Colors.green,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "You",
            ),
            Text(
              message.message,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              formattedTime,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
