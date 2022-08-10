import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
class translator extends StatefulWidget {
  @override
  _translatorState createState() => _translatorState();
}

class _translatorState extends State<translator> {

  GoogleTranslator translator = new GoogleTranslator();   //using google translator


  Translation out;
  final lang=TextEditingController();   //getting text


  void trans()
  {

    translator.translate(lang.text, to: 'en')   //translating to hi = hindi
        .then(( output)
    {
      setState(() {
            out=output;                  //placing the translated text to the String to be used
      });
      print(out);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transalate !!"),
      ),
      body: Container(
        child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: lang,
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text("Press !!"),            //on press to translate the language using function
                  onPressed: ()
                  {
                    trans();
                  },
                ),
                Text(out.toString())                    //translated string
              ],
            )
        ),
      ),
    );
  }
}