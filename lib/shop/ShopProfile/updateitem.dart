import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import '../loadingpage.dart';
class Updateitem extends StatefulWidget {
  final String id;
  final String productName;
  final String price;
  final String image;
  final String quantity;
  final String description;
  final String categoryName;


  // receive data from the FirstScreen as a parameter
  Updateitem(
      {
        @required this.id,
        @required this.productName,
        @required this.description,
        @required this.price,
        @required this.quantity,
        @required this.categoryName, @required this.image,});

  @override
  State<Updateitem> createState() => _UpdateitemState(id,productName,description,price,quantity,categoryName,image);
}

class Album {
  final String id;
  final String productName;
  final String description;
  final String price;
  final String quantity;
  final String categoryName;
  final String image;

  const Album({@required this.id, @required this.productName,@required this.description,@required this.price,@required this.quantity,@required this.categoryName,@required this.image});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['_id'],
      productName: json['productName'],
      description: json['description'],
      price: json['price'],
      quantity: json['quantity'],
      categoryName: json['categoryName'],
      image: json['image'],
    );
  }
}
class _UpdateitemState extends State<Updateitem> {
  _UpdateitemState(this.id,this.productName, this.description, this.price, this.quantity, this.categoryName, this.image);

  Future<Album> updateAlbum(String id,String productName,String description, String price ,String quantity,String categoryName,String image) async {
    print(id);
    final response = await http.put(
      Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        '_id':id,
        'productName':productName,
        'description':description,
        'price':price,
        'quantity':quantity,
        'categoryName':categoryName,
        'image':image
      }),
    );
    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update album.');
    }
  }



TextEditingController _itemname = TextEditingController();
TextEditingController _description = TextEditingController();
TextEditingController _price = TextEditingController();
TextEditingController _category = TextEditingController();
TextEditingController _qty = TextEditingController();

TextEditingController _image = TextEditingController();
  final String id;
  final String productName;
  final String description;
  final String price;
  final String quantity;
  final String categoryName;
  final String image;
  bool isloading=false;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _itemname.text=productName;
      _description.text=description;
      _price.text=price;
      _qty.text=quantity;
      _category.text=categoryName;
      _image.text=image;

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context)=>isloading?Loadingpage()
    :Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Update Item',
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
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.all(15.0),
                          child: TextField(

                            controller:_itemname,
                            decoration: InputDecoration(
                              labelText: 'ProductName',

                              prefixIcon: Icon(Icons.person,color: Colors.green),
                            ),


                          ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.lightGreen,width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          child: TextField(
                            controller: _description,
                            decoration: InputDecoration(
                                labelText: 'Description',
                                prefixIcon: Icon(Icons.assignment_outlined,color: Colors.green)),

                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          child: TextField(
                            controller: _price,
                            decoration: InputDecoration(
                              labelText: 'Price',
                              prefixIcon: Icon(Icons.attach_money ,color: Colors.green),
                            ),

                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          child: TextField(

                            controller: _qty,
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              prefixIcon: Icon(Icons.attach_email_rounded,color: Colors.green),
                            ),

                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          child: TextField(

                            controller: _category,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              prefixIcon: Icon(Icons.lock,color: Colors.green),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.all(15.0),
                          child: TextField(
                            controller: _image,
                            decoration: InputDecoration(
                              labelText: 'Image',
                              prefixIcon: Icon(Icons.add_a_photo_sharp ,  color: Colors.green,),
                            ),

                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen,width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed:() async{
                            setState(()=>isloading=true);
                            await Future.delayed(const Duration(seconds: 5));
            updateAlbum(id,_itemname.text,_description.text, _price.text,  _qty.text,   _category.text,  _image.text);

                            setState(()=>isloading=false);
                            await Future.delayed(const Duration(seconds: 1));
                            Fluttertoast.showToast(
                              msg: "Item Updated",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          child: Text('Update Item',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
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

