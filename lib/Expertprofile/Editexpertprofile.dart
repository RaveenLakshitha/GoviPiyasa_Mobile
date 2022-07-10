import 'dart:convert';
import 'dart:io';

import 'package:blogapp/CustumWidget/shopservice.dart';
import 'package:blogapp/Profile/map.dart';
import 'package:blogapp/shop/shoprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Editexpert extends StatefulWidget {

  @override
  _EditexpertState createState() => _EditexpertState();
}

class _EditexpertState extends State<Editexpert> {
  final picker=ImagePicker();

  File _image;
  chooseImage(ImageSource source) async{
    final image=await picker.getImage(source:source);
    setState(() {
      _image=File(image.path);
    });
  }
  var shopName,email,sellerName,phoneNo,address,city;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Edit Expert Profile',
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
                SizedBox(height:5.0),
                Container(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person,color: Colors.blue,),
                              ),
                              onChanged: (val){
                                shopName=val;
                              },
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.lightGreen,width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),

                            )
                        ),
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(

                                labelText: 'Designation',
                                prefixIcon: Icon(Icons.article_sharp,color: Colors.blue,)),
                            onChanged: (val){
                              sellerName=val;
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
                          ),
                        ),
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.attach_email_rounded,color: Colors.blue,),
                            ),
                            onChanged: (val){
                              email=val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                          ),
                        ),
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Qualification',
                              prefixIcon: Icon(Icons.lock,color: Colors.blue,),
                            ),
                            onChanged: (val){
                              city=val;
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
                              labelText: 'Location',
                              prefixIcon:GestureDetector(
                                child:Icon(Icons.add_location,color: Colors.blue,),
                                onTap: (){
                                  // _showToast(context);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Map1()));
//                                    uploadImage();
                                },
                              ),
                            ),
                            onChanged: (val){
                              address=val;
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
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.lightGreen,width: 1),
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
                        SizedBox(height:5.0),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Upload Proof Document',
                              prefixIcon:GestureDetector(
                                child:Icon(Icons.upload,color: Colors.blue,),
                                onTap: (){
                                  // _showToast(context);
                                  chooseImage(ImageSource.gallery);
//                                    uploadImage();
                                },
                              ),
                            ),
                            onChanged: (val){
                              _image=val as File;
                            },
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),),
                        OutlinedButton(
                          style:OutlinedButton.styleFrom(
                            padding:const EdgeInsets.symmetric(horizontal: 40),
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),

                          ),
                          onPressed: (){

                            ShopService().addShop(shopName,sellerName,phoneNo,email,address,city).then((val){
                              Fluttertoast.showToast(
                                msg: val.data['msg'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Showitem()));

                            });

                          },
                          child:Text("Edit Profile",style:TextStyle(
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
}
