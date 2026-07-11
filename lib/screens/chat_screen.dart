import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

final _firestore = FirebaseFirestore.instance;

/**
 * Chat screen to send and receive messages
 * */
class ChatScreen extends StatefulWidget {
  static String id = 'Chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {}
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  // Future<void> getMessages() async {
  //   print("method call");
  //  final messages = await _firestore.collection('messages').get();
  //  for(var message in messages.docs){
  //     print(message.data());
  //  }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24.0),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(
                        color: Colors.black
                      ),
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection("messages").add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });

                      messageTextController.clear();
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data?.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages!) {
          final messageText = message.get('text');
          final sender = message.get('sender');
          messageBubbles.add(
            MessageBubble(message: messageText, sender: sender),
          );
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            children: messageBubbles,
          ),
        );
        return Column();
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String message;
  final String sender;

  const MessageBubble({required this.message, required this.sender});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(sender,
          style: TextStyle(fontSize: 12.0, color: Colors.black54),),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5.0,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                style: TextStyle(color: Colors.white, fontSize: 15.0),
                message,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
