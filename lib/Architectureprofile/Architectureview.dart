import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blogapp/Architectureprofile/screens/details/components/chat_and_add_to_cart.dart';
import 'package:blogapp/Architectureprofile/screens/details/components/list_of_colors.dart';
import 'package:blogapp/assets/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Architectureview extends StatefulWidget {
  final String id;
  final String businessName;
  final String description;
  final String contactNumber;
  final String motto;
  final String image;
  final String rating;
  final String email;

  Architectureview(
      {this.id,
        this.businessName,
      this.description,
      this.contactNumber,
      this.motto,
        this.email,
        this.rating,
      this.image});

  @override
  State<Architectureview> createState() => _ArchitectureviewState();
}

class _ArchitectureviewState extends State<Architectureview> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  double rating;
  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  void lanchwhatsapp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("can't open whatsapp");
  }
  addrate(String rate,String id)async{

    String token = await storage.read(key: "token");
    print(token);
    print(id);
    print(rate);
    final body = {
      "rating": rate,
      "architectId":id
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

  addreview(String review,String id) async{

    String token = await storage.read(key: "token");
    print(token);
    print(id);
    print(review);
    final body = {
      "review": review,
      "architectId":id
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
  static const colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontFamily: 'Horizon',
  );
  var selectedCard = 'WEIGHT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: kDefaultPadding),
          icon: Icon(Icons.arrow_back_outlined, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        title: AnimatedTextKit(
          isRepeatingAnimation: true,
          animatedTexts: [
            ScaleAnimatedText(
              widget.businessName,
              textStyle: TextStyle(fontSize: 30.0, fontFamily: 'Canterbury'),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.architecture, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.redAccent,
                      ),
                      child: Image.network(
                        widget.image,
                        height: 250.0,
                        width: 150.0,
                      ),
                    ),
                  ),
                  ListOfColors(),
                  Center(
                    child:Column(
                        children:[
                        Text(widget.email),
                      Text(widget.rating.toString(),style: TextStyle(
                                color:Colors.black)),
                        ]

                  ),),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              child: Icon(MyFlutterApp.whatsapp),
                              onTap: () {
                                lanchwhatsapp(
                                    number: "+94${widget.contactNumber}",
                                    message: "hello");
                              },
                            ),

                            buildRating1(double.parse(widget.rating.toString())),
                            GestureDetector(
                              child: Icon(Icons.call),
                              onTap: () {
                                launch("tel://+94${widget.contactNumber}");
                                // launch("mailto:ashennilura@gmail.com?subject=Meeting&body=Can we meet via Google Meet");
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding / 2),
                          child: Text(
                            widget.motto,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kSecondaryColor,
                          ),
                        ),
                        Center(
                          child: Container(
                            child: AnimatedTextKit(
                              pause: const Duration(milliseconds: 100),
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  widget.contactNumber,
                                  //textStyle: colorizeTextStyle,
                                  colors: colorizeColors,
                                  textStyle: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                              isRepeatingAnimation: true,
                              onTap: () {
                                print("Tap Event");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                OutlinedButton(
                  style:OutlinedButton.styleFrom(
                    padding:const EdgeInsets.symmetric(horizontal: 40),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),),  onPressed: () => showRating(),
                  child:Text("Rate Us",style:TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color:Colors.red,
                  )),

                ),
                OutlinedButton(
                  style:OutlinedButton.styleFrom(
                    padding:const EdgeInsets.symmetric(horizontal: 40),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),),  onPressed: () => showReview(widget.id),
                  child:Text("Review Us",style:TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color:Colors.red,
                  )),

                ),
              ]
            )),

        Center(
          child: SizedBox(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 35,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.blue,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  FlickerAnimatedText('Projects'),

                ],
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ),
        ),

            SizedBox(height: 10,),
            Container(
                height: 150.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _buildInfoCard('WEIGHT', '300', 'G'),
                    SizedBox(width: 10.0),
                    _buildInfoCard('CALORIES', '267', 'CAL'),
                    SizedBox(width: 10.0),
                    _buildInfoCard('VITAMINS', 'A, B6', 'VIT'),
                    SizedBox(width: 10.0),
                    _buildInfoCard('AVAIL', 'NO', 'AV')
                  ],
                )),
            Container(
              height: 150,
              width: 350,
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 150,
                      child: Card(
                          child: ListTile(
                            title: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage("fgg"),
                                        fit: BoxFit.cover)),
                                height: 280.0,
                                width: 100.0),
                            // title: Text(widget.docs[index]['user'].toString())),
                          )),
                    );
                  }),),
            ChatAndAddToCart(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String cardTitle, String info, String unit) {
    return InkWell(
        onTap: () {
          selectCard(cardTitle);
        },
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color:
                  cardTitle == selectedCard ? Colors.lightGreen : Colors.white,
              border: Border.all(
                  color: cardTitle == selectedCard
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 0.75),
            ),
            height: 100.0,
            width: 100.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                    child: Text(cardTitle,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          color: cardTitle == selectedCard
                              ? Colors.white
                              : Colors.grey.withOpacity(0.7),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(info,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                color: cardTitle == selectedCard
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(unit,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: cardTitle == selectedCard
                                  ? Colors.white
                                  : Colors.black,
                            ))
                      ],
                    ),
                  )
                ])));
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
  void showRating() => showDialog(
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

              addrate(rating.toString(),widget.id);
              await Future.delayed(Duration(seconds: 3));
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "rating added successfully",
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

                await Future.delayed(Duration(seconds: 3));
                myController.clear();
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "review added successfully",
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
  Widget buildRating1(rating) => RatingBar.builder(
    minRating: 1,
    itemSize: 18,
    initialRating: rating,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: false,
    onRatingUpdate: (rating) => setState(() {
      this.rating = rating;
    }),
  );
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
}
