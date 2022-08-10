import 'dart:convert';
import 'dart:io';


import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
class Addprojects extends StatefulWidget {
  const Addprojects({Key key}) : super(key: key);

  @override
  State<Addprojects> createState() => _AddprojectsState();
}

class _AddprojectsState extends State<Addprojects> {
  Dio dio =Dio();
  final picker=ImagePicker();
  File _image;


  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path) ;
    });
  }
  consumerProfile(File file,id) async {
    String token = await storage.read(key: "token");
    dio.options.contentType = 'application/json';
   dio.options.headers["authorization"] = "Bearer $token";
    print(token);
    try {

      String fileName=file.path.split('/').last;
      FormData formData=FormData.fromMap({
        "profilePicture": await MultipartFile.fromFile(file.path, filename:fileName),
      });

      return await dio.put('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/updateProfilePic/$id', data: formData);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  final storage = FlutterSecureStorage();
  addProjects(description,title) async {
    String token = await storage.read(key: "token");
    print(token);
    /*   print(date);
    print(time);*/

    final body = {
      'description': description,
      'title': title,
    };
    http
        .post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/projects",
      body: jsonEncode(body),
    )
        .then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      }
    });
  }
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some message';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Title",
                  ),
                )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some message';
                    }
                    return null;
                  },
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Description",
                  ),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: TextFormField(

                decoration: InputDecoration(
                  labelText: 'Upload Proof Document',
                  prefixIcon: GestureDetector(
                    child: Icon(
                      Icons.upload,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      chooseImage(ImageSource.gallery);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
          AnimatedButton(
            width: 200,
            text: 'Add Projects',
            pressEvent: () {

              if (_formkey.currentState.validate()) {
                String description = _descriptionController.text;
                String title = _titleController.text;
                // addProjects(description,title);

                consumerProfile(_image,"62ac01f65db35f1b19e6a22b");
                // addTimeSlot(description, date, time);
                /*AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  headerAnimationLoop: false,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Sucess',
                  buttonsTextStyle: const TextStyle(color: Colors.black),
                  showCloseIcon: false,

                  btnOkOnPress: () {},
                ).show();*/
              }

            },
          ),


          ],
        ),
      )
    );
  }
}
