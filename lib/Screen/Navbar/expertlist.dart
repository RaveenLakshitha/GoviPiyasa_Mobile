import 'package:blogapp/Expertprofile/expertview.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/assets/my_flutter_app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';

import 'package:url_launcher/url_launcher.dart';

class SellerList extends StatefulWidget{
  @override
  _SellerListState createState() => _SellerListState();
}

class _SellerListState extends State<SellerList> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  addrate(String rate,String id)async{

    String token = await storage.read(key: "token");
    print(token);
    print(id);
    print(rate);
    final body = {
      "rating": rate,
      "expertId":id
    };
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/ratings",body:jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }
/*  Future<http.Response> addrate(String rate,String id) async{
    String token = await storage.read(key: "token");
    print(id);
    print(rate);
    return http.post(
      Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/ratings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'rating': rate,
        'expertId':id
      }),
    );
  }*/
  addreview(String review,String id) async{

    String token = await storage.read(key: "token");
    print(token);
    print(id);
    print(review);
    final body = {
      "review": review,
      "expertId":id
    };
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/reviews",body:jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }


  double rating=0.0;
  double rating1;

  void lanchwhatsapp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("can't open whatsapp");
  }

  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //https://jsonplaceholder.typicode.com/posts
  // https://mongoapi3.herokuapp.com/users

  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/experts/";
  var _postsJson = [];

  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;
      print(jsonData);
      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {}
  }

  void initState() {
    super.initState();
    //  getUsers();
    setState(() {
      // this.rating = 5;
    });

    fetchPosts();
  }

  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.9,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft,color:Colors.black),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              }),
          title: Text('ExpertList',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20.0,
                  color: Colors.black)),
        ),
        body: RefreshIndicator(
          onRefresh: refreshList2,
          child: ListView.builder(
              itemCount: _postsJson.length,
              itemBuilder: (BuildContext context, index) {

                final post = _postsJson[index];
                if(_postsJson.length==0){
                  return SizedBox.shrink();
                }else{
                  return GestureDetector(
                    child:Container(
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                      ),
                      child: ListTile(
                        leading: post['user']['profilePicture']!=null?Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,

                            ),
                            child: Image.network("${post['user']['profilePicture']}")):Image.network('https://source.unsplash.com/random?sig=$index'),
                        title: Text("${post['userName']}",style: TextStyle(
                            fontSize: 15,
                            color:Colors.black,
                            fontFamily: 'Varela',
                            fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Designation:${post['designation']}"),
                            Text("City:${post['city']}"),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                 // Text("Contact:+94${post['contactNumber']}"),
                                ]),

                            Row(
                                children: [
                                  Text("${post['rating'].toString()}",style: TextStyle(
                                      color:Colors.amber)),
                                  buildRating1(double.parse(post['rating'].toString())),
                                ]),
                            Row(
                              children: [
                                TextButton(
                                  child: Text(
                                    'Rate',
                                    style: TextStyle(fontSize: 14,color:Colors.red),
                                  ),
                                  onPressed: () => showRating(post['_id']),
                                ),
                                TextButton(
                                  child: Text(
                                    'Review',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  onPressed: () => showReview(post['_id']),
                                ),
                              ],
                            ),

                          ],
                        ),
                        trailing: Column(
                            children:[
                              GestureDetector(
                                child: Icon(MyFlutterApp.whatsapp),
                                onTap: () {
                                  lanchwhatsapp(
                                      number: "+94${post['contactNumber']}", message: "hello");
                                },
                              ),
                              SizedBox(height: 5,),
                              GestureDetector(
                                child: Icon(Icons.settings_phone_rounded),
                                onTap: () {
                                  launch("tel:+94${post['contactNumber']}");
                                  // launch("mailto:ashennilura@gmail.com?subject=Meeting&body=Can we meet via Google Meet");
                                },
                              ),
                            ]
                        ),
                        isThreeLine: true,
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => expertView(
                                designation:"${post['designation']}",
                                description:"${post['description']}",
                                city:"${post['city']}",
                                contact:"${post['contactNumber']}",
                                name:"${post['userName']}",
                                qualification:"${post['Qualification']}",
                                rating:"${post['rating']}",
                                list:_postsJson[index]['expertReviews'],
                                slots:_postsJson[index]['appointmentSlots'],
                                docs:_postsJson[index]['proofDocuments'],
                                image:"${post['user']['profilePicture']}",
                                email:"${post['email']}",
                                id:"${post['_id']}",

                              )));
                    },
                  );
                }


              }),
        ));
  }

  Widget buildRating() => RatingBar.builder(
    minRating: 1,
    itemSize: 18,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: true,
    onRatingUpdate: (rating) => setState(() {
      this.rating = rating;
    }),
  );

  Widget buildRating1(rating) => RatingBar.builder(
    minRating: 1,
    itemSize: 18,
    initialRating: rating,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: false,

  );

  void showRating(id) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Rate this Product'),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please leave a star rating',
                style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text("$rating"),
                buildRating(),
              ],
            )
          ]),
      actions: [
        TextButton(
            onPressed: ()async {

              addrate(rating.toString(),id);
              await Future.delayed(Duration(seconds: 3));
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            child: Text('Ok', style: TextStyle(fontSize: 20))),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(fontSize: 20)))
      ],
    ),
  );

  void showReview(id) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Review this Product'),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Review',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),

          ]),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(fontSize: 20))),
        TextButton(
            onPressed: () async{
              if (_formKey.currentState.validate()) {
                addreview(myController.text,id);
                myController.clear();
                await Future.delayed(Duration(seconds: 3));
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "successfull",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }

            },
            child: Text('Ok', style: TextStyle(fontSize: 20)))
      ],
    ),
  );
}
