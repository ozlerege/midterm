import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'createAccount.dart';
import 'loginapp.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home:
    MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green.shade600,
        body: Column(
          children: [
            SizedBox(
              height: 320,
            ),
            Stack(
              children: [
                Text("Social Page",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 5
                        ..color = Colors.red[700]!,
                    )),
                Text("Social Page",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    )),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(18),
              child: TextFormField(
              onChanged: (value) {
                email = value;
              },
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.red),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    icon: Icon(Icons.email,
                      color: Colors.red,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Enter Your Email",
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontFamily: "RobotoMono",

                    )
                ),),),
            Padding(
              padding: EdgeInsets.all(18),
              child: TextFormField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.red),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    icon: Icon(Icons.password,
                      color: Colors.red,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Password",
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontFamily: "RobotoMono",

                    )
                ),),),
            FloatingActionButton.extended(
              heroTag: "Button4",
              backgroundColor: Colors.red,
              label: Text("Login"),
              icon: Icon(Icons.login),
              onPressed: () async{
                try {
                  final oldUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if(oldUser != null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginApp()));
                  }
                }
                catch(e){
                  print(e);
                }
              },

            ),
            SizedBox(height: 10,),
            FloatingActionButton.extended(
              heroTag: "Button3",
              backgroundColor: Colors.red,
              label: Text("Create An Account"),
              icon: Icon(Icons.people),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateAnAccount()));
              },

            ),



          ],
        ),

      ),
    );
  }
}


