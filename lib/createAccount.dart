import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'loginapp.dart';
import 'main.dart';

class CreateAnAccount extends StatefulWidget {
  const CreateAnAccount({Key? key}) : super(key: key);
  @override
  _createAccountState createState() => _createAccountState();
}

class _createAccountState extends State<CreateAnAccount> {
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  String email = "";
  String username = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade600,
      body: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          Padding(
            padding: EdgeInsets.all(18),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  icon: Icon(
                    Icons.email,
                    color: Colors.red,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter Your Email",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontFamily: "RobotoMono",
                  )),
                onChanged: (value){
                  email = value;
                }
            ),
          ),


          Padding(
            padding: EdgeInsets.all(18),
            child: TextFormField(
              cursorColor: Colors.black,
              onChanged: (value){
                username = value;
              },
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  icon: Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Create Username",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontFamily: "RobotoMono",
                  )),
            ),
          ),


          Padding(
            padding: EdgeInsets.all(18),
            child: TextFormField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.black,
                onChanged: (value){
                  password = value;
                },
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  icon: Icon(
                    Icons.email,
                    color: Colors.red,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter Your Password",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontFamily: "RobotoMono",
                  )),
            ),
          ),

          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              FloatingActionButton.extended(
                heroTag: "Button1",
                backgroundColor: Colors.red,
                label: Text("Back"),
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
              ),
              SizedBox(
                width: 20,
              ),
              FloatingActionButton.extended(
                  heroTag: "Button2",
                  backgroundColor: Colors.red,
                  label: Text("Create Account"),
                  icon: Icon(Icons.people),
                  onPressed: () async {
                    firestore.collection("Users").doc(email).set({
                      'email': email,
                      'password': password,
                      'username': username,
                    });

                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {

                        firestore.collection("Users").doc(email).set({
                          'email': email,
                          'password': password,
                          'username': username,
                          'userID' : _auth.currentUser?.uid,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginApp()));
                      }
                    } catch (e) {
                    }
                  }),
            ],
          )
        ],
      ),
    );
  }
}
