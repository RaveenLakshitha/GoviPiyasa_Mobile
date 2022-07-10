import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;

Future<Response> sendForm(
    String url, Map<String, dynamic> data, Map<String, File> files) async {
  Map<String, MultipartFile> fileMap = {};
  for (MapEntry fileEntry in files.entries) {
    File file = fileEntry.value;
    String fileName = basename(file.path);
    fileMap[fileEntry.key] =
        MultipartFile(file.openRead(), await file.length(), filename: fileName);
  }
  data.addAll(fileMap);
  var formData = FormData.fromMap(data);
  Dio dio = new Dio();
  return await dio.post(url,
      data: formData, options: Options(contentType: 'multipart/form-data'));
}

Future<Response> sendFile(String url, File file) async {
  Dio dio = new Dio();
  var len = await file.length();
  var response = await dio.post(url,
      data: file.openRead(),
      options: Options(headers: {
        Headers.contentLengthHeader: len,
      } // set content-length
      ));
  return response;
}


class Ads extends StatefulWidget {
  Ads({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  File _image;
  final picker=ImagePicker();

  chooseImage(ImageSource source) async{
    final image=await picker.getImage(source:source);
    setState(() {
      _image=File(image.path);
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    print('upload started');
    //upload image
    //scenario  one - upload image as poart of formdata
    var res1 = await sendForm('https://mongoapi3.herokuapp.com/additem',
        {'itemname': 'iciruit', 'description': 'description'}, {'image': image});
    print("res-1 $res1");
    var res2 =
    await sendFile('https://mongoapi3.herokuapp.com/additem', image);
    print("res-2 $res2");
    setState(() {
      _image = image;
    });
  }


  uploadImage(String title, File file) async{

    var request = http.MultipartRequest("POST",Uri.parse("https://api.imgur.com/3/image"));

    request.fields['title'] = "dummyImage";
    request.headers['Authorization'] = "Client-ID " +"f7........";

    var picture = http.MultipartFile.fromBytes('image', (await rootBundle.load('assets/about.jpg')).buffer.asUint8List(),
        filename: 'about.jpg');

    request.files.add(picture);

    var response = await request.send();

    var responseData = await response.stream.toBytes();

    var result = String.fromCharCodes(responseData);

    print(result);



  }
  //uploadImage('image', File('assets/about.jpg'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Subtitle',
              ),
            ),
          ),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: _image!=null
                        ?Container(
                      height: 100,
                      width:100,
                      decoration: BoxDecoration(
                        image:DecorationImage(
                          image:FileImage(_image),
                        ),
                      ),
                    ):Container(
                      height: 50,
                      width:50,
                      decoration: BoxDecoration(
                        color:Colors.grey,
                      ),
                    ),),
                  Container(
                      child:Row(
                    children: [
                      IconButton(
                          onPressed:(){
                            chooseImage(ImageSource.gallery);
                          }, icon: Icon(Icons.camera_alt_sharp) )
                    ],
                  )),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                      onSurface: Colors.red,
                    ),
                    onPressed: null,
                    child: Text('TextButton'),
                  ),
           /*      Container(child:LinearPercentIndicator(
                    width: 140.0,
                    lineHeight: 14.0,
                    percent: 0.5,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),)*/
                ],
              )
          ),

        ],
      ),
    );
  }
}