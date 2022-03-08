import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:midterm/chatArea.dart';
import 'dart:math';
import 'chatlist.dart';
import 'main.dart';

var getter_userID_final;

class LoginApp extends StatefulWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  var current_index = 0;

  void onTapped(int index) {
    setState(() {
      current_index = index;
    });
  }

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hi User",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        centerTitle: false,
        leading: Icon(
          Icons.verified_user,
          color: Colors.red,
        ),
        backgroundColor: Colors.green,
        actions: [
          FloatingActionButton.extended(
            heroTag: "Button110",
            backgroundColor: Colors.red,
            label: Text(
              "LogOut",
              style: TextStyle(fontSize: 12),
            ),
            icon: Icon(Icons.logout),
            onPressed: () async {
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        backgroundColor: Colors.green,
                        content: Text(
                          "Are You Sure?",
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                          ),
                          Container(
                            padding: const EdgeInsets.all(0.0),
                            color: Colors.green,
                            width: 300.0,
                            height: 50.0,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 70,
                                ),
                                FloatingActionButton.extended(
                                  heroTag: "Button 100",
                                  backgroundColor: Colors.red,
                                  label: Text("No",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginApp()));
                                  },
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                FloatingActionButton.extended(
                                  heroTag: "Button 100",
                                  backgroundColor: Colors.red,
                                  label: Text("Yes",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onPressed: () async {
                                    try {

                                      final oldUser = await _auth.signOut();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyApp()));
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ));
            },
          ),
        ],
      ),
      body: checkPage(current_index),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble,
                color: Colors.red,
              ),
              label: 'Chats'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.red),
            label: "Search",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.red), label: 'Profile')
        ],
        selectedItemColor: Colors.white,
        currentIndex: current_index,
        onTap: onTapped,
      ),
    );
  }
}

checkPage(int index) {
  if (index == 1) {
    return Search();
  } else if (index == 2) {
    return Profile();
  } else if (index == 0) {
    return ChatList();
  }
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

Future<List> getUser() async {
  List user_list = [];
  final _auth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  final users = await firestore.collection("Users").get();
  for (var x in users.docs) {
    user_list.add(x.data()["username"]);
  }

  return user_list;
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

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _auth = FirebaseAuth.instance;
  String getter_username = "";
  String getter_userID = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  icon: Icon(
                    Icons.search,
                    color: Colors.red,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter User Name",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontFamily: "RobotoMono",
                  )),
              onChanged: (value) {
                getter_username = value;
              }),
        ),
        FloatingActionButton.extended(
            heroTag: "Button6",
            backgroundColor: Colors.red,
            label: Text("Search"),
            onPressed: () async {
              try {
                List userIDlist = await getUserIDgetter(getter_username);
                getter_userID = userIDlist[0];


                List userlist = await getUser();
                List sender_username_list = await getUsername();
                String sender_username = sender_username_list[0];
                if (userlist.contains(getter_username) &&
                    getter_username != sender_username) {
                  return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Colors.green,
                            content: TextButton(
                                child: Text(
                                  "Start Conversation",
                                ),
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor:
                                      Colors.red, // Background Color
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              getter_userID, getter_username)));
                                }),
                            actions: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                              ),
                              Container(
                                padding: const EdgeInsets.all(0.0),
                                color: Colors.green,
                                width: 300.0,
                                height: 50.0,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.verified_user,
                                      color: Colors.red,
                                    ),
                                    Text('Username: $getter_username',
                                        style: TextStyle(fontSize: 15)),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                } else {}
              } catch (e) {
                print(e);
              }
            }),
      ],
    );
  }
}










String rank_user_id = "";
String current_user_username = "";


Future<List> getRanks() async{
  List rank_avg = [];
  final _auth = FirebaseAuth.instance.currentUser?.uid;
  final firestore = FirebaseFirestore.instance;
  String? current_userID = _auth;
  String collection = current_userID! + "_rank";
  int counter = 0;
  int sum = 0;
  final ranks = await firestore.collection(collection).get();
  for(var rank in ranks.docs){

    sum += int.parse(rank.data()["rank"]);
    counter ++;
  }
  rank_avg.add(sum/counter);
  return rank_avg;
}

// show the dialog
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List>(
        future: getRanks(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshots) {
          if (!snapshots.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );


          }

          List<Widget> widgets = [];
          double avg = snapshots.data![0];
          String average = "$avg";
           var wid = Column(
             children: [
               Center(
                 child: Text("Average Ranking $average",style: TextStyle(
                     color: Colors.red,
                 fontSize: 30,
                 fontWeight: FontWeight.bold),),
               )
             ],
           );
           widgets.add(wid);



          return Center(
            child: Column(
              children: widgets,


            ),
          );
        });
  }
}
