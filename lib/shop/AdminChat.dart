import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdminChat extends StatefulWidget {
  //const AdminChat({Key? key}) : super(key: key);

  @override
  _AdminChatState createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0.0,
        centerTitle: true,
        title: Text('ChatBot',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Color(0xFF545D68))),
      ),*///https://www.domex.lk/
      body:  WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: "https://nilura.github.io/AdminChat.kommunicate/",
      ),
    );
  }
}
