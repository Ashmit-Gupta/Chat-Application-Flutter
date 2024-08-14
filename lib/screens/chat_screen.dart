import 'package:chat_app/screens/components/message_bubble.dart';
import 'package:chat_app/screens/components/messages_stream.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String messageText;
  final messageTextController = TextEditingController();

  /* Future<dynamic> getMessage() async {
       final messages = await _firestore.collection('messages').get();
       for (var message in messages.docs) {
         print("sender : ${message.data()["sender"]}");
         print("text : ${message.data()["text"]}");
       }
   }
  */

  /*void messagesStream() async {
    //Notifies of query results at this location.
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      print(
          "snapshot : ${snapshot.docChanges}"); //An array of the documents that changed since the last snapshot. If this is the first snapshot, all documents will be in the list as Added changes.

      for (var message in snapshot.docs) {
        print("sender : ${message.data()}");
      }
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    print(_auth.currentUser?.email);
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // logout functionality
                _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
                // getMessage();
                // messagesStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessagesStream(),
            // StreamBuilder<QuerySnapshot>(
            //   stream: _firestore.collection("messages").snapshots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       final messages = snapshot.data!.docs;
            //       List<Text> messageWidgets = [];
            //       for (var message in messages) {
            //         final messageText = message['text'];
            //         final messageSender = message['sender'];
            //
            //         final messageWidget = Text('$messageSender: $messageText');
            //         messageWidgets.add(messageWidget);
            //       }
            //       return Expanded(
            //         child: ListView(
            //           children: messageWidgets,
            //         ),
            //       );
            //     } else if (snapshot.hasError) {
            //       return Text('Something went wrong!');
            //     }
            //     return const CircularProgressIndicator();
            //   },
            // ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      controller: messageTextController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      //sending the message and the Email to cloud Firestore.
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': _auth.currentUser?.email
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
