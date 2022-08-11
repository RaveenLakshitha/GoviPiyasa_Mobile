import 'dart:convert';
import 'package:blogapp/checkout/widgets/viewgallery.dart';
import 'package:blogapp/shop/custom/BorderIcon.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class Itemdetails extends StatefulWidget {
  final String text;
  final String price;
  final String image;
  final String quantity;
  final String description;
  final String category;

  Itemdetails(
      {Key key,
      @required this.text,
      @required this.price,
      @required this.image,
      @required this.quantity,
      @required this.description,
      @required this.category})
      : super(key: key);

  @override
  State<Itemdetails> createState() =>
      _ItemdetailsState(text, price, image, quantity, description, category);
}

class _ItemdetailsState extends State<Itemdetails> {
  double rating = 0.0;
  String text;
  String price;
  String image;
  String quantity;
  String category;
  String description;

  FlutterSecureStorage storage = FlutterSecureStorage();
  addrate(String rate,String id)async{

    String token = await storage.read(key: "token");
    print(token);
    print(id);
    print(rate);
    final body = {
      "rating": rate,
      "itemId":id
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
  _ItemdetailsState(this.text, this.price, this.image, this.quantity,
      this.description, this.category);

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
                onPressed: () async {
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 35;
    final ThemeData themeData = Theme.of(context);
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      /*  gradient: LinearGradient(
                      colors: [Colors.lightGreenAccent, Colors.green],
                    ),*/
                      ),
                  child: Column(children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    Positioned(
                      width: size.width,
                      top: padding,
                      child: Padding(
                        padding: sidePadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: BorderIcon(
                                height: 50,
                                width: 50,
                                child: Icon(
                                  Icons.keyboard_backspace,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            BorderIcon(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    viewgallery(image: image)));
                      },
                      child: Container(
                        width: 500,
                        height: 240,
                        margin: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(image),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => viewgallery(
                                            image:
                                                'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80')));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                /* decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                  ),
                                ),*/
                                //width: 200,

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                      'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => viewgallery(
                                            image:
                                                'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80')));
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                        'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80'),
                                  )),
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => viewgallery(
                                            image:
                                                'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80')));
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                        'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(text,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600)),
                    GestureDetector(
                      child: Icon(Icons.share),
                      onTap: () {
                        Share.share('${text}', subject: '${description}');
                      },
                    ),

                    /* buildRating1(
                            double.parse(widget.rating.toString())),*/
                    Container(
                      /* decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.lightGreenAccent, Colors.green],
                        ),
                      ),*/
                      child: Center(
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(color: Colors.black, width: 1),
                              ),
                              margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                              child: Container(
                                  width: 310.0,
                                  height: 220.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Details",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey[300],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                /*  Container(

                                                  padding: EdgeInsets.all(10.0),
                                                  decoration: BoxDecoration(
                                                    color:Colors.amber[50],
                                                    borderRadius: BorderRadius.circular(25),
                                                    border:Border.all(
                                                      color:Colors.purple,
                                                      width:1,
                                                    )
                                                  ),

                                                ),*/
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Description",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                                Text(
                                                  description,
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.blue,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Quantity",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                                Text(
                                                  quantity,
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.blue,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Category",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                                Text(
                                                  category,
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.blue,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )))),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* void opengallery()=> Navigator.of(context).push(MaterialPageRoute(builder:(_)=>Gallerywidget(
    urlImages:urlImages,
  ),));*/
