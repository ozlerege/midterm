

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatArea.dart';
import 'loginapp.dart';
import 'main.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
Future<List> getChats() async {
  List user_list = [];
  List chat_user_list = [];
  final _auth = FirebaseAuth.instance.currentUser?.uid;
  final firestore = FirebaseFirestore.instance;

  final chats = await firestore.collection("all_chats").get();
  for (var chat in chats.docs) {

    if (chat.data()["user1"] == _auth) {

      user_list.add(chat.data()["user2"]);
    } else if (chat.data()["user2"] == _auth) {

      user_list.add(chat.data()["user1"]);
    }
  }
  final users = await firestore.collection("Users").get();
  for (var user in users.docs) {
    if (user_list.contains(user.data()["userID"])) {

      chat_user_list.add(user.data()["username"]);
    }
  }

  return chat_user_list;
}

Future<List> getUserIDgetter(String getter) async {
  List user_list = [];
  final _auth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  final users = await firestore.collection("Users").get();
  for (var x in users.docs) {
    if (getter == x.data()["username"]) {
      user_list.add(x.data()["userID"]);
    }
  }

  return user_list;
}

Future<List> getUsername() async {
  List username = [];
  final _auth = FirebaseAuth.instance.currentUser?.email;
  final firestore = FirebaseFirestore.instance;
  final users = await firestore.collection("Users").get();
  for (var x in users.docs) {
    if (x.data()["email"] == _auth) {
      username.add(x.data()["username"]);
    }
  }
  return username;
}
String rank_user_id = "";
String current_user_username = "";

var random = Random();
class ChatList extends StatefulWidget {
  const ChatList();

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String rank = "";
  final firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: getChats(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshots) {
          if (!snapshots.hasData) {

            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Widget> widgets = [];
          for (var message in snapshots.data!) {
            var containers = Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(00.0),
                    color: Colors.red,
                    width: 500.0,
                    child: Row(children: [
                      FloatingActionButton.extended(
                        extendedPadding:
                        EdgeInsetsDirectional.only(start: 30.0, end: 50.0),
                        heroTag: "$message",
                        backgroundColor: Colors.red,
                        label: Text("Username: $message",
                            style: TextStyle(fontSize: 12, color: Colors.white)),
                        onPressed: () async {
                          String username = message;
                          List userID_list = await getUserIDgetter(username);
                          String userID = userID_list[0];

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(userID, username)));
                        },
                      ),
                      FloatingActionButton.extended(
                        extendedPadding:
                        EdgeInsetsDirectional.only(start: 40.0, end: 50.0),
                        heroTag: random.nextInt(100),
                        backgroundColor: Colors.red,
                        label: Text("Rank"),
                        icon: Icon(Icons.star),
                        onPressed: () async {
                          rank_user_id = message;
                          return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "Rank the user $rank_user_id",
                                  style:
                                  TextStyle(color: Colors.red, fontSize: 20),
                                ),
                                actions: [
                                  Container(
                                    padding: const EdgeInsets.all(0.0),
                                    color: Colors.green,
                                    width: 600.0,
                                    height: 30.0,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          "Ranking (1 to 5):",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 17),
                                        ),
                                        Container(
                                          width: 100.0,
                                          child: TextField(
                                            cursorColor: Colors.green,
                                            style: TextStyle(color: Colors.red),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder:
                                              OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    25.0),
                                              ),
                                              focusedBorder:
                                              UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),),
                                            onChanged: (value){
                                              rank = value;
                                            },



                                          ),
                                        ),
                                        IconButton(
                                            onPressed:() async{
                                              final sender_uid = _auth.currentUser?.uid;

                                              List rank_id_list = await getUserIDgetter(rank_user_id);
                                              List sender_username = await getUsername();
                                              current_user_username = sender_username[0];
                                              String rank_getter_id = rank_id_list[0];
                                              firestore.collection(rank_getter_id + "_rank").doc(sender_uid).set({
                                                "rank" : rank,
                                              });



                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => LoginApp()));
                                            }, icon: Icon(Icons.exit_to_app,color: Colors.red,size: 30,))],
                                    ),

                                  ),
                                ],
                              ));
                        },
                      ),
                    ],)

                ),
              ],
            );

            widgets.add(containers);
          }
          return Center(
            child: Column(
              children: widgets,


            ),
          );
        });
  }
}