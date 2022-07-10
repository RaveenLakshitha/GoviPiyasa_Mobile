import 'dart:convert';
import 'dart:io';

import 'package:blogapp/CustumWidget/shopservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
class Architect extends StatefulWidget {

  @override
  _ArchitectState createState() => _ArchitectState();
}

class _ArchitectState extends State<Architect> {
  final picker=ImagePicker();

  File _image;
  chooseImage(ImageSource source) async{
    final image=await picker.getImage(source:source);
    setState(() {
      _image=File(image.path);
    });
  }

  var AName,about,designation,token,team,phoneNo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Create Architecture Profile',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
        ),
        body: SingleChildScrollView(

          child: Container(
            margin: const EdgeInsets.only(top: 5.0),
            padding: EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                    ),
                  ),
                  child: Image(
                    image: AssetImage("assets/architect.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height:5.0),
                Container(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'BusinessName',
                              prefixIcon: Icon(Icons.person,color: Colors.blue,),
                            ),
                            onChanged: (val){
                             AName=val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),

                  /*      SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Designation',
                                prefixIcon: Icon(Icons.attribution_outlined)),
                            onChanged: (val){
                              designation=val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),*/
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ContactNumber',
                              prefixIcon: Icon(Icons.contact_phone,color: Colors.blue,),
                            ),
                            onChanged: (val){
                              phoneNo=val;
                            },
                          ),
                            decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightGreen,width: 1),
                         borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),),
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ContactNumber',
                              prefixIcon: Icon(Icons.contact_phone,color: Colors.blue,),
                            ),
                            onChanged: (val){
                              phoneNo=val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),),
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ContactNumber',
                              prefixIcon: Icon(Icons.contact_phone,color: Colors.blue,),
                            ),
                            onChanged: (val){
                              phoneNo=val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),),
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'About',
                              prefixIcon: Icon(Icons.article_sharp,color: Colors.blue,),
                            ),
                            onChanged: (val){
                              about=val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Team',
                              prefixIcon: Icon(Icons.lock,color: Colors.blue,),
                            ),
                            onChanged: (val){
                              team=val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Upload Proof Document',
                                prefixIcon:GestureDetector(
                                child:Icon(Icons.upload,color: Colors.blue,),
                                  onTap: (){
                                    _showToast(context);
                                    chooseImage(ImageSource.gallery);
//                                    uploadImage();
                                  },
                                ),
                              ),
                              onChanged: (val){
                                team=val;
                              },
                            ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),),
                        SizedBox(height:5.0),
                        OutlinedButton(
                            style:OutlinedButton.styleFrom(
                              padding:const EdgeInsets.symmetric(horizontal: 40),
                              shape:RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                            ),

                          onPressed:(){
                            ShopService().addArchitect(AName,phoneNo,about,team).then((val){
                              Fluttertoast.showToast(
                                msg: val.data['msg'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );

                            });
                          },
                          child:Text("Create Architect shop",style:TextStyle(
                            fontSize: 16,
                            letterSpacing: 2.2,
                            color:Colors.black,
                          )),

                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  /*uploadFile() async {
    var postUri = Uri.parse("<APIUrl>");
    var request = new http.MultipartRequest("POST", postUri);
    request.fields['audio']="audio";
    request.fields['file']="folder";
    request.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri("<path/to/file>").readAsBytes(), contentType: new MediaType('image', 'jpeg')))

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
  }
  uploadImage(String title) async{
  var request=http.MultipartRequest("POST",Uri.parse(''));
  request.fields['audio']="audio";
  request.fields['file']="folder";
  Map<String,String> headers={"Authorization":"XYZ","ClientId":"ABC!@#"};
  request.headers.addAll(headers);
  request.headers['Authorization']="";
  //var audio=http.MultipartRequest.fromBytes('audio',(await rootBundle.load('assets/test.wav')).buffer.asUint8List(),filename:'test.wav');
  //var file=http.MultipartRequest.fromBytes('file',(await rootBundle.load('assets/NewFolder.zip'))..buffer.asUint8List(),filename:'NewFolder.zip');
  //var pdf=http.MultipartRequest.fromBytes('file',(await rootBundle.load('assets/NewFolder.zip'))..buffer.asUint8List(),filename:'NewFolder.zip');
  //request.files.add(audio);
  //request.files.add(file);
  //request.files.add(pdf);
  var response=await request.send();
  var responseData=await response.stream.toBytes();
  //var result =String.fromCharCode(responseData);
  }*/
  static Future<bool> _upload(File file, int id) async {
    var headers = {'Authorization': 'Bearer TOKEN'}; // remove headers if not wanted
    var request = http.MultipartRequest(
        'POST', Uri.parse("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/")); // your server url
    request.fields.addAll({'id': '$id'}); // any other fields required by your server
    request.files
        .add(await http.MultipartFile.fromPath('image', '${file.path}')); // file you want to upload
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }
}
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

