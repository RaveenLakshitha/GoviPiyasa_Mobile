import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  FlutterSecureStorage storage = FlutterSecureStorage();
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
  double rating=0.0;
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



  void lanchwhatsapp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("can't open whatsapp");
  }

  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //https://jsonplaceholder.typicode.com/posts
  // https://mongoapi3.herokuapp.com/users
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shoporders/getUsersOrders";
  var _orderhistory = [];

  void fetchOrders() async {
    String token = await storage.read(key: "token");
    try {
      final response = await get(Uri.parse(url),  headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },);
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _orderhistory = jsonData;
      });
    } catch (err) {}
  }

  void initState() {
    super.initState();
    //  getUsers();
    setState(() {
      this.rating = 5;
    });

    fetchOrders();
    // fetchData();
  }

  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Order History',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
        ),
        body: RefreshIndicator(
          onRefresh: refreshList2,
          child: ListView.builder(
              itemCount: _orderhistory.length,
              itemBuilder: (BuildContext context, index) {
                final post = _orderhistory[index];
                return Container(
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(
                        5.0) //                 <--- border radius here
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network("${post['orderedItem']['item']['thumbnail'][0]['img']}"),
                    title: Text("${post['orderedItem']['item']['productName']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${post['orderedItem']['item']['price']}"),
                        Text("${post['orderedItem']['item']['quantity']}"),
                        Text("${post['orderedItem']['item']['description']}"),
                        Row(children: [
                          Text("${post['orderedItem']['item']['rating']}"),
                          buildRating1(double.parse(post['orderedItem']['item']['rating'].toString())),
                        ]),

                      ],
                    ),
                /*    trailing: GestureDetector(
                      child: Icon(Icons.add_call),
                      onTap: () {
                        lanchwhatsapp(
                            number: "+94${post['contact']}", message: "hello");
                      },
                    ),*/
                    isThreeLine: true,
                  ),
                );
              }),
        ));
  }

  Widget buildRating1(rating) => RatingBar.builder(
    minRating: 1,
    itemSize: 18,
    initialRating: rating,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: false,

  );

/*  Widget buildRating1() => RatingBar.builder(
    minRating: 1,
    itemSize: 18,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: true,
    onRatingUpdate: (rating) => setState(() {
      this.rating = rating;
    }),
  );*/


}
