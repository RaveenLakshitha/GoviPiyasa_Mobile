import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ForgetPassword.dart';

class Otp extends StatefulWidget {
  const Otp({Key key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _otp=TextEditingController();
  void sendOTP() async{
    EmailAuth.sessionName="Test Sesstion";
    var res =await EmailAuth.sendOtp(receiverMail:_emailController.text);
    if(res){
      Fluttertoast.showToast(
        msg: 'OTP Send',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }else{
      Fluttertoast.showToast(
        msg: 'not OTP Send',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  void verifyOtp(){
   var res=EmailAuth.validate(receiverMail:_emailController.text,userOTP:_otp.text);
   if(res){
     Navigator.push(
         context,
         MaterialPageRoute(
             builder: (context) => Forgetpassword()));
     Fluttertoast.showToast(
       msg: 'Sucessfull',
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
       backgroundColor: Colors.red,
       textColor: Colors.white,
       fontSize: 16.0,
     );
   }else{

   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

           Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(8.0)),
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80'),
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child:Column(
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter email",
                    labelText: "Email",
                    suffixIcon: TextButton(
                      child:Text("Send Otp"),
                      onPressed: (){
                        sendOTP();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                TextField(
                  controller: _otp,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Otp",
                    labelText: "Otp",

                  ),
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child:Text('Verify OTP'),
                  onPressed: (){
                    verifyOtp();
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
