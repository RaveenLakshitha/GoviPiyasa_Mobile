import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';





class Imagelabel extends StatefulWidget {
  Imagelabel({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ImagelabelState createState() => _ImagelabelState();
}

class _ImagelabelState extends State<Imagelabel> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  File _image;
  final picker = ImagePicker();
  final ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler();
  var result;
  List<String> strArr = ['hello'];

  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }
  void writeimahelabel() async{
    await storage.write(key: "label", value:strArr[1]);
    Fluttertoast.showToast(
      msg: "image saved",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );


  }
@override
  void initState() {

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text("${strArr}"),
       ),
      body:RefreshIndicator(
       onRefresh: refreshList2,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Center(
              child: _image == null ? Text('No image selected.') : Image.file(_image),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(
              child: result == null
                  ? Text('Nothing here')
                  : Text(
                result,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        processImageLabels();
      } else {
        print('No image selected.');
      }
    });
  }

  processImageLabels() async {
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(_image);
    ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    var _imageLabels = await labeler.processImage(myImage);
    result = "";
    for (ImageLabel imageLabel in _imageLabels) {
      setState(() {
        result = result + imageLabel.text + ":" + imageLabel.confidence.toString() + "\n";
        strArr.add(imageLabel.text);
      });
    }
    writeimahelabel();
  }
}