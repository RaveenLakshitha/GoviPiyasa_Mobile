import 'dart:convert';

import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class Forgetpassword extends StatefulWidget {
  const Forgetpassword({Key key}) : super(key: key);

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {

  forget(email)async{
    var headers = {
      'Content-Type':'application/json',
    };

    final body = {
      "email":email,

    };
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/forgotPassword",body:jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _otp=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            SizedBox(height: 20.0,),
            Padding(
                padding: const EdgeInsets.all(18.0),
                child:Column(
                  children: [
              /*      TextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter email",
                        labelText: "Email",
                        suffixIcon: TextButton(
                          child:Text("Send Otp"),
                          onPressed: (){
                          },
                        ),
                      ),
                    ),*/
                    SizedBox(height: 20.0,),
                    ElevatedButton(
                      child:Text('Change Password'),
                      onPressed: (){
                        forget(_passwordController);
                        Fluttertoast.showToast(
                          msg: 'Check your email box ',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                    )
                  ],
                )
            ),
          ],


        )
    );
  }
}
