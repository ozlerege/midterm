import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:midterm/chat/messages.dart';
import 'chat_bubble.dart';
import "check.dart";

var son = true;
class SendMessage extends StatefulWidget {
  SendMessage(this.getter_userID,this.data);
  final String getter_userID;
  bool data;
  @override
  _SendMessageState createState() => _SendMessageState();


}

class _SendMessageState extends State<SendMessage> {
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final myController = TextEditingController();


  var message = "";


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(child: TextField(
              cursorColor: Colors.black,
              controller: myController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.red,
                    fontFamily: "RobotoMono",

                  ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelText: "Send Message",labelStyle: TextStyle(color:Colors.red)),
            onChanged: (value){
              setState(() {
                message = value;
              });
            }
          )
          ),
          IconButton(color: Colors.red,icon: Icon(Icons.send),onPressed: () async {
            String? current_user = _auth.currentUser?.uid;
            String getter_userId = widget.getter_userID;
            print("Getter id $getter_userId");
            print("Current user $current_user");
            final firestore = FirebaseFirestore.instance;
            var collection = getter_userId + current_user!;
            QuerySnapshot querySnapshot = await firestore.collection(collection).get();
            var allData = querySnapshot.docs.map((doc) => doc.data()).toList();



            if(allData.isNotEmpty){
              widget.data = allData.isNotEmpty;
              Checking check = new Checking();
              check.checks = widget.data;
              son = widget.data;
             firestore.collection(collection).add({
                "text": message,
               'createdAt':Timestamp.now(),
                'userID' :_auth.currentUser?.uid,
              });
             firestore.collection("all_chats").doc(collection).set({
               "user1":current_user,
               "user2":getter_userId,
             });


             myController.clear();
            }
            else {if (message.trim().isEmpty == false) {
              widget.data = allData.isNotEmpty;
               firestore.collection(current_user + getter_userId).add({
                 "text": message,
                  'createdAt': Timestamp.now(),
                  'userID': _auth.currentUser?.uid,
                });
              firestore.collection("all_chats").doc(current_user + getter_userId).set({
                "user1":current_user,
                "user2":getter_userId,
              });
               myController.clear();
             }
            }
            },)
        ],
      ),
    );
  }
}

Future<bool> checkExists(String user1, String? user2) async {
  final firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore.collection(user1 + user2!).get();

  // Get data from docs and convert map to List
  var allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //for a specific field
  return allData.isNotEmpty;
}
class Return{

  bool ret(){
    return son;
  }
}

Future<List> getUsername(String getter) async{
  List username = [];
  final firestore = FirebaseFirestore.instance;

  final users = await firestore.collection("Users").get();
  for(var x in users.docs){
    if(getter == x.data()["userID"]){
      username.add(x.data()["username"]);
    }

  }

  return username;

}
