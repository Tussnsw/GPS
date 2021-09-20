import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String username = "";
String password = "";
String email = "";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      if (value.getString("email") != null) {
        Navigator.pushReplacementNamed(context, "/map");
      }
    });
  }

  @override
  final formkey = GlobalKey<FormState>();
  final emailkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS Tracking'),
        backgroundColor: Color(0xFF00796B),
      ),
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(0xFFE8F5E9),
                Color(0xFFC8E6C9),
                Color(0xFFA5D6A7),
                Color(0xFF81C784),
                Color(0xFF66BB6A),
              ])),
        ),
        Form(
          key: formkey,
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: Column(children: <Widget>[
                Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                buildBoxUserID(),
                SizedBox(
                  height: 30.0,
                ),
                buildBoxPassword(),
                SizedBox(
                  height: 30.0,
                ),
                buildForgotPasswordButton(),
                SizedBox(
                  height: 30.0,
                ),
                buildSignInButton(context),
              ]),
            ),
          ),
        )
      ]),
    );
  }

  Widget buildBoxUserID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "User ID",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        SizedBox(
          height: 5.0,
        ),
        TextFormField(
          validator: (String? e) {
            if (e!.isEmpty) {
              return "กรุณากรอกข้อมูล";
            } else if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(e)) {
              return "กรุณากรอกอีเมลให้ถูกต้อง";
            } else {
              return null;
            }
          },
          onSaved: (String? e) {
            username = e!.trim();
          },
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 14),
              prefix: Icon(
                Icons.person,
                color: Colors.black,
              ),
              hintText: "Enter Your UserID.",
              hintStyle: TextStyle(color: Colors.white70)),
        )
      ],
    );
  }

  Widget buildBoxPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        SizedBox(
          height: 5.0,
        ),
        TextFormField(
          validator: (String? p) {
            if (p!.isEmpty) {
              return "กรุณากรอกรหัสผ่าน";
            } else {
              return null;
            }
          },
          onSaved: (String? p) {
            password = p!.trim();
          },
          obscureText: true,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 14),
              prefix: Icon(
                Icons.verified_user,
                color: Colors.black,
              ),
              hintText: "Enter Your Password.",
              hintStyle: TextStyle(color: Colors.white70)),
        )
      ],
    );
  }

  Widget buildForgotPasswordButton() {
    return Container(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text("Enter your E-mail"),
                  content: Text("We send E-mail for reset your Password"),
                  actions: <Widget>[
                    Form(
                      key: emailkey,
                      child: TextFormField(
                        validator: (String? e) {
                          if (e!.isEmpty) {
                            return "Enter your E-mail";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(e)) {
                            return "Invalid E-mail";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (e) => email = e!.trim(),
                      ),
                    ),
                    TextButton(
                      onPressed: ()   async {
                        if (emailkey.currentState!.validate()) {
                          emailkey.currentState!.save();
                          Navigator.pop(context, 'OK');
                          await repassword(context);
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: Colors.black,
              ),
            )));
  }

  Widget buildSignInButton(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (formkey.currentState!.validate()) {
            formkey.currentState!.save();
            await LogIn(context);
          }
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
        ),
        child: Text(
          "LOGIN",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Future<void> LogIn(context) async {
  String LogInURL =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCupr_lPLvh3fyowVwf4GCi0U2ygjafJWg";
  var url = Uri.parse(LogInURL);
  try {
    var response = await http.post(url, body: {
      'email': username,
      'password': password,
      'returnSecureToken': "true"
    });
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email", username);
      Navigator.pushReplacementNamed(context, "/map");
    } else {
      var data = jsonDecode(response.body);
      List error = data['error']['message'].toString().split(":");
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Warning'),
          content: Text(error.length < 2
              ? data['error']['message'].toString()
              : error[1]),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    print(e.toString());
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Warning'),
        content: Text(e.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

Future<void> repassword(context) async {
  String repasswordURL =
      "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyCupr_lPLvh3fyowVwf4GCi0U2ygjafJWg";
  var url = Uri.parse(repasswordURL);
  try {
    var response = await http.post(url, body: {
      'email': email,
      'requestType': "PASSWORD_RESET",
    });
    if (response.statusCode != 200) {
      var data = jsonDecode(response.body);
      List error = data['error']['message'].toString().split(":");
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Warning'),
          content: Text(error.length < 2
              ? data['error']['message'].toString()
              : error[1]),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    print(e.toString());
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Warning'),
        content: Text(e.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  }

