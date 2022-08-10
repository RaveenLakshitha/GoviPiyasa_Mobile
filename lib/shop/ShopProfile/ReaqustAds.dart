import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

/*Future<Response> sendForm(
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
}*/

class Ads extends StatefulWidget {
  Ads({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  final storage = FlutterSecureStorage();
@override
  void initState() {
  //checkvisibility();
  fetchshop();
    super.initState();
  }


  File _image;
  final picker = ImagePicker();
  bool visibility;

  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
  }

  var _adsjson;
  var  _reqads;
  void fetchshop() async {
    print('Shop');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/advertisements'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');

      print('Ads SHOW : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      print(jsonData);
      setState(() {
        _reqads = jsonData;
        visibility = _reqads[0]['Paid'];


      });
    //  print(_reqads[0]['Paid']);
    } catch (err) {}
  }
  void checkvisibility() async {
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/advertisements'));
      final jsonData = jsonDecode(response.body)['data'] as List;
      print("vis");
      print(jsonData);
      setState(() {
        _adsjson = jsonData;
        visibility=_adsjson[0]['Paid'];
      });
      print("done");
    } catch (err) {}
  }

  uploadImage(String title, File file) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://api.imgur.com/3/image"));

    request.fields['title'] = "dummyImage";
    request.headers['Authorization'] = "Client-ID " + "f7........";

    var picture = http.MultipartFile.fromBytes('image',
        (await rootBundle.load('assets/about.jpg')).buffer.asUint8List(),
        filename: 'about.jpg');

    request.files.add(picture);

    var response = await request.send();

    var responseData = await response.stream.toBytes();

    var result = String.fromCharCodes(responseData);

    print(result);
  }
  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }
  //uploadImage('image', File('assets/about.jpg'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshList2,
        child:visibility != true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child:Center(
                  child:Text("Make Your Advertistment",  style: TextStyle(
                      color: Colors.black, fontSize: 30.0, fontFamily: 'Indies'),),
                  )
                ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Subtitle',
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(13.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //                 <--- border radius here
                            ),
                        border: Border.all(color: Colors.lightGreen)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: _image != null
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    image: DecorationImage(
                                      image: FileImage(_image),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        Container(
                            child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  chooseImage(ImageSource.gallery);
                                },
                                icon: Icon(Icons.camera_alt_sharp))
                          ],
                        )),

                        /*      Container(child:LinearPercentIndicator(
                    width: 140.0,
                    lineHeight: 14.0,
                    percent: 0.5,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),)*/
                      ],
                    )),
                SizedBox(height: 10.0),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Apply",
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2.2,
                        color: Colors.black,
                      )),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child:Text("Approved your Advertistment",style: TextStyle(   fontFamily: 'Roboto',fontWeight: FontWeight.bold, fontSize: 14.0,))
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter amount',
                    ),
                  ),
                ),

                SizedBox(height: 10.0),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Pay ",
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2.2,
                        color: Colors.black,
                      )),
                ),
              ],
            ),)
    );
  }
}
