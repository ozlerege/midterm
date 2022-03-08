import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "send_message.dart";
import 'chat_bubble.dart';
import 'check.dart';

var son;
var collection;
var collection_2;
class Messages extends StatelessWidget {
  Messages(this.getter_userID);

  final String getter_userID;
  final firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    String? current_user = _auth.currentUser?.uid;
    final firestore = FirebaseFirestore.instance;
    collection = getter_userID + current_user!;
    collection_2 = current_user + getter_userID;

    Future<bool> checkExists(String collection) async {
      final firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection(collection).get();

      // Get data from docs and convert map to List
      var allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      //for a specific field
      return allData.isNotEmpty;
    }
    void foo(var collection) async{
      var all_data = await checkExists(collection);
      son = all_data;
    }
    foo(collection);


    if (son == true){
      return StreamBuilder<QuerySnapshot>(
          stream: firestore.collection(collection).orderBy(
              "createdAt", descending: true).snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            final chatDocuments = chatSnapshot.data!.docs;
            final _auth = FirebaseAuth.instance;
            return ListView.builder(
                reverse: true,
                itemCount: chatDocuments.length,
                itemBuilder: (context, index) =>
                    ChatBubble(chatDocuments[index]['text'],
                        chatDocuments[index]["userID"] ==
                            _auth.currentUser?.uid,
                        ValueKey(chatDocuments[index].id)
                    ));
          }


      );
    }
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection(collection_2).orderBy(
            "createdAt", descending: true).snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          final chatDocuments = chatSnapshot.data!.docs;
          final _auth = FirebaseAuth.instance;
          return ListView.builder(
              reverse: true,
              itemCount: chatDocuments.length,
              itemBuilder: (context, index) =>
                  ChatBubble(chatDocuments[index]['text'],
                      chatDocuments[index]["userID"] == _auth.currentUser?.uid,
                      ValueKey(chatDocuments[index].id)
                  ));
        }


    );
  }
}







