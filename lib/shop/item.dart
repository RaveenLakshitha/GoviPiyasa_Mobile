

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import 'DataModel.dart';
import 'inputDeco_design.dart';


class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

Future<DataModel> submitData(String itemname,String description,String price,String qty,String category,String image,String deliverystatus)async{
  var response=await http.post(Uri.parse('https://mongoapi3.herokuapp.com/additem'),
      body:{"itemname":itemname,"description":description,"price":price,"quantity":qty,"category":category,"deliverystatus":deliverystatus,"image":image});
  var data=response.body;
  print(data);
  if(response.statusCode==201){
    String responseString=response.body;
    dataModelFromJson(responseString);
  }
}
class _FormPageState extends State<FormPage> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  var log = Logger();
  File _image;

  final picker=ImagePicker();

  chooseImage(ImageSource source) async{
    final image=await picker.getImage(source:source);
    setState(() {
      _image=File(image.path);
    });
  }
  DataModel _datamodel;
  TextEditingController _itemname = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _qty = TextEditingController();
  var deliverystatus;
  List listitem = ["Delivery Available", "Delivery not Available"];

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  child: Image.network("https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png"),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:15,left: 10,right: 10),
                  child: TextFormField(
                    controller: _itemname,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.person,"Full Name"),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return "Please enter name";
                      }
                      return null;
                    },
                    onSaved: (String name){

                    },

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                  child: TextFormField(
                    controller: _description,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.person,"Category"),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return "Please enter name";
                      }
                      return null;
                    },
                    onSaved: (String name){

                    },

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                  child: TextFormField(
                    controller: _price,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.person,"Description"),
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return "Please enter name";
                      }
                      return null;
                    },
                    onSaved: (String name){

                    },

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                  child: TextFormField(
                  controller: _qty,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(Icons.person,"Image"),
                  validator: (String value){
                    if(value.isEmpty)
                    {
                      return "Please enter name";
                    }
                    return null;
                  },
                  onSaved: (String name){

                  },),),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),    child: TextFormField(
                  controller: _category,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(Icons.person,"Category"),
                  validator: (String value){
                    if(value.isEmpty)
                    {
                      return "Please enter name";
                    }
                    return null;
                  },
                  onSaved: (String name){

                  },),),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightGreen,width: 3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left:16,right:16),
                          child: _image!=null
                              ?Container(
                            height: 50,
                            width:50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent,width: 3),
                              image:DecorationImage(
                                image:FileImage(_image),
                              ),
                            ),
                          ):Container(
                            padding: EdgeInsets.only(left:16,right:16),
                            height: 50,
                            width:50,
                            decoration: BoxDecoration(
                              color:Colors.grey,
                            ),
                          ),


                        ),
                      SizedBox(height: 10.0,),
                        Container(child:Row(
                          children: [
                            IconButton(
                                onPressed:(){
                                  chooseImage(ImageSource.gallery);
                                }, icon: Icon(Icons.camera_alt_sharp) )
                          ],
                        )),
                      ],
                    )
                ),
                Container(
                  child:Center(
                    child:Padding(
                      padding:const EdgeInsets.all(16.0),
                      child: Container(
                        padding: EdgeInsets.only(left:16,right:16),
                        decoration:BoxDecoration(
                            border:Border.all(color:Colors.grey,width:1),
                            borderRadius:BorderRadius.circular(15)
                        ),
                        child: DropdownButton(
                          hint: Text("Delivery Availability"),
                          dropdownColor: Colors.grey,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                          value:  deliverystatus,
                          onChanged: (value) {
                            setState(() {
                              deliverystatus=value;
                            });
                          },
                          items: listitem.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                        ),),),),),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.redAccent,
                    onPressed: () async{

                      if(_formkey.currentState.validate())
                      {
                        String itemname=_itemname.text;
                        String price=_price.text;
                        String category=_category.text;
                        String description=_description.text;
                        String quantity=_qty.text;
                        DataModel data=await submitData(itemname,description, category, price,quantity,deliverystatus,_image.path);
                        setState(() {
                          _datamodel=data;
                        });
                     //   RegistrationUser();
                        _itemname.clear();
                        _category.clear();
                        _description.clear();
                        _qty.clear();
                        _price.clear();
                        Fluttertoast.showToast(
                          msg: "Successfull",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }else
                      {
                        Fluttertoast.showToast(
                          msg: "Unsuccessfull",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }

                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue,width: 2)
                    ),
                    textColor:Colors.white,child: Text("Submit"),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
/*
  Future RegistrationUser()  async{
    // url to registration php script
    var APIURL = "https://mongoapi3.herokuapp.com/addposts";

    //json maping user entered details
    Map mapeddate ={
      'title':_name.text,
      'category':_email.text,
      'description':_phone.text,
      'image':_password.text

    };
    //send  data using http post to our php code
    http.Response reponse = await http.post(APIURL,body:mapeddate );

    //getting response from php code, here
    var data = jsonDecode(reponse.body);
    print("DATA: ${data}");

  }*/
}