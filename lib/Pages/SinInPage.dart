import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:blogapp/Pages/ForgetPassword.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Pages/SignUpPage.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';

import '../NetworkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'designs/Otp.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin:  EdgeInsets.fromLTRB(30, 60, 30,40),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),//remove color to make it transpatent
                border: Border.all(
                    style: BorderStyle.solid,
                    color: Colors.green,width: 3)),
            // height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
        /*    decoration: BoxDecoration(
              color: const Color(0xffadc2de),
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstIn),
                image: AssetImage("assets/loginimg2.png"),
                fit: BoxFit.cover,
              ),
            ),*/
            child: Form(
              key: _globalkey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    usernameTextField(),
                    SizedBox(
                      height: 15,
                    ),
                    passwordTextField(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Otp()));
                          },
                          child: Text(
                            "Forgot Password ?",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: Text(
                            "New User?",
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        if(_globalkey.currentState.validate())
                        {
                          setState(() {
                            circular = true;
                          });
                          await Future.delayed(Duration(seconds: 15));
                       /*   setState(() {
                            circular = false;
                          });*/
                          //Login Logic start here
                          Map<String, String> data = {
                            "email": _usernameController.text,
                            "password": _passwordController.text,
                          };
                          var response =
                          await networkHandler.post("/auths/login", data);

                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            Map<String, dynamic> output = json.decode(response.body);
                            print(output["token"]);
                            await storage.write(key: "token", value: output["token"]);
                            setState(() {
                              validate = true;
                              circular = false;
                            });

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                                    (route) => false);
                          } else {
                            // String output = json.decode(response.body);
                            Fluttertoast.showToast(
                              msg: "Error",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            setState(() {
                              validate = true;

                              circular = false;
                            });
                          }

                        }

                        // login logic End here
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightGreen,
                        ),
                        child: Center(
                          child: circular
                              ? CircularProgressIndicator()
                              : Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Divider(
                    //   height: 50,
                    //   thickness: 1.5,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget usernameTextField() {
    return Column(
      children: [
        TextFormField(
          validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",
          controller: _usernameController,
          decoration: InputDecoration(

            border: OutlineInputBorder(),
            labelText: "Email",
            errorText: validate ? null : errorText,

          ),
        )
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some password';
            }
            return null;
          },
          controller: _passwordController,
          obscureText: vis,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Password",
            errorText: validate ? null : errorText,
            suffixIcon: IconButton(
              icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  vis = !vis;
                });
              },
            ),
            helperStyle: TextStyle(
              fontSize: 14,
            ),
          ),
        )
      ],
    );
  }
}
