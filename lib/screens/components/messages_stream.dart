import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class MessagesStream extends StatelessWidget {
  MessagesStream({super.key});
  final _firestore = FirebaseFirestore.instance;
  final _firebase = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final currUser = _firebase.currentUser?.email;
            final messageText = message['text'];
            final messageSender = message['sender'];

            messageBubbles.add(
              MessageBubble(
                  text: messageText,
                  sender: messageSender,
                  isMe: (messageSender == currUser)),
            );
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: messageBubbles,
            ),
          );
        } else {
          print("ERROR ${snapshot.hasError}");
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.redAccent,
          ),
        );
      },
    );
  }
}
