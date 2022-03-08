import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midterm/chat/messages.dart';
import 'package:midterm/chat/send_message.dart';
import 'createAccount.dart';
import 'loginapp.dart';
import 'package:firebase_core/firebase_core.dart';


class ChatScreen extends StatefulWidget {
   ChatScreen(this.getter_userID, this.getter_username);
  final String getter_userID;
  final String getter_username;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  bool data = false;
  String text = "";
  final firestore = FirebaseFirestore.instance;

  String getUsername() {
    return widget.getter_username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(getUsername(),style: TextStyle(color:Colors.red,fontSize: 25),),
        centerTitle: false,
        leading: Icon(Icons.verified_user,color: Colors.red,size: 34),
        actions: [IconButton(
            onPressed:(){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginApp()));
            }, icon: Icon(Icons.exit_to_app,color: Colors.red,size: 34,))],
      ),
      body: Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          Expanded(
              child:Messages(widget.getter_userID)),
          SendMessage(widget.getter_userID,false),

        ],
        ),
      ),
    );
  }
}
