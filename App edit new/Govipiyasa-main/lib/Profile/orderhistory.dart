import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class Orderhistory extends StatefulWidget {
  @override
  _OrderhistoryState createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  Future<http.Response> addrate(String rate) {
    return http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'rating': rate,
      }),
    );
  }

  Future<http.Response> addreview(String review) {
    return http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'review': review,
      }),
    );
  }

  double rating;

  void lanchwhatsapp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("can't open whatsapp");
  }

  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //https://jsonplaceholder.typicode.com/posts
  // https://mongoapi3.herokuapp.com/users
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/getExperts";
  var _postsJson = [];

  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {}
  }

  void initState() {
    super.initState();
    //  getUsers();
    setState(() {
      this.rating = 5;
    });

    fetchPosts();
    // fetchData();
  }

  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Order History',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
        ),
        body: RefreshIndicator(
          onRefresh: refreshList2,
          child: ListView.builder(
              itemCount: _postsJson.length,
              itemBuilder: (BuildContext context, index) {
                final post = _postsJson[index];
                return Container(
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(
                        5.0) //                 <--- border radius here
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network("${post['profilePicture']}"),
                    title: Text("Name:${post['userName']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Email:${post['email']}"),
                        Text("City:${post['city']}"),
                        Text("Contact:+94${post['contactNumber']}"),
                        Row(children: [
                          Text("$rating"),
                          buildRating1(),
                        ]),
                        Row(
                          children: [
                            TextButton(
                              child: Text(
                                'Rate',
                                style: TextStyle(fontSize: 14),
                              ),
                              onPressed: () => showRating(),
                            ),
                            TextButton(
                              child: Text(
                                'Review',
                                style: TextStyle(fontSize: 14),
                              ),
                              onPressed: () => showReview(),
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: Icon(Icons.settings_phone_rounded),
                          onTap: () {
                            launch("tel://+94${post['contact']}");
                            // launch("mailto:ashennilura@gmail.com?subject=Meeting&body=Can we meet via Google Meet");
                          },
                        ),
                      ],
                    ),
                    trailing: GestureDetector(
                      child: Icon(Icons.add_call),
                      onTap: () {
                        lanchwhatsapp(
                            number: "+94${post['contact']}", message: "hello");
                      },
                    ),
                    isThreeLine: true,
                  ),
                );
              }),
        ));
  }

  Widget buildRating() => RatingBar.builder(
    minRating: 1,
    itemSize: 18,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: false,
    onRatingUpdate: (rating) => setState(() {
      this.rating = rating;
    }),
  );

  Widget buildRating1() => RatingBar.builder(
    minRating: 1,
    itemSize: 18,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: true,
    onRatingUpdate: (rating) => setState(() {
      this.rating = rating;
    }),
  );

  void showRating() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Rate this Product'),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please leave a star rating',
                style: TextStyle(fontSize: 10)),
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
            onPressed: () {
              Navigator.pop(context);
              addrate(rating.toString());
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

  void showReview() => showDialog(
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
              if (_formKey.currentState.validate()) {
                addreview(myController.text);
                Navigator.pop(context);
              }

            },
            child: Text('Ok', style: TextStyle(fontSize: 20)))
      ],
    ),
  );
}
