import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:blogapp/Screen/Maps/Map.dart';
import 'package:blogapp/shop/custom/BorderIcon.dart';
import 'package:blogapp/shop/utils/constants.dart';
import 'package:blogapp/shop/utils/custom_functions.dart';
import 'package:blogapp/shop/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../custom/OptionButton.dart';
class Shopview extends StatefulWidget {
  final String id;
  final String text;
  final String price;
  final String image;
  final String quantity;
  final String description;
  final String category;
  final String itemCount;
  final String shopitems;
  final String latlang;
  final String longitude;
  Shopview(
      {     @required this.id,
        @required this.text,
        @required this.price,
        @required this.image,
        @required this.description,
        @required this.quantity,
        @required this.category, @required this.itemCount, @required this.shopitems,@required this.latlang,@required this.longitude});

  @override
  State<Shopview> createState() => _ShopviewState(id,text,price,image,quantity,description,category,itemCount,shopitems,latlang,longitude);
}

class _ShopviewState extends State<Shopview> {
  String name;
  String message;
  final String id;
  final String text;
  final String price;
  final String image;
  final String quantity;
  final String description;
  final String category;
  final String itemCount;
  final String shopitems;
  final String latlang;
  final String longitude;
  _ShopviewState(this.id,this.text,this.price,this.image,this.quantity,this.description,this.category,this.itemCount,this.shopitems,this.latlang,this.longitude);
  var _shopitems = [];

  void fetchShop(id) async {
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/$id'));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _shopitems = jsonData;
      });
    } catch (err) {}
  }

  void initState() {
    super.initState();


    fetchShop(id);
  }
  double rating = 0;
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
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [

              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Stack(
                      children: [
                        image!=null?Image.network("$image"):AssetImage("assets/architect.jpg"),
                        Positioned(
                          width: size.width,
                          top: padding,
                          child: Padding(
                            padding: sidePadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: BorderIcon(
                                    height: 50,
                                    width: 50,
                                    child: Icon(Icons.keyboard_backspace,color: Colors.lightGreen,),
                                  ),
                                ),
                                BorderIcon(
                                  height: 50,
                                  width: 50,
                                  child: Icon(Icons.favorite_border,color:Colors.lightGreen,),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],

                    ),
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BorderIcon(child: Text('$text',style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF545D68))),padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),),
                          Text('$price',style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                         //Text(shopitems),
                          IconButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => googlemap(lat:6.9520765,long:80.5156422,
                                ),),
                            );
                          }, icon: Icon(Icons.add_location_alt)),
                          Text(id),
                          latlang!=null?Text(latlang):Text("null"),
                          longitude!=null?Text(longitude):Text("null"),
                          //Text(longitude),
                          SizedBox(height:5.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              addVerticalSpace(5),

                              Text(category),
                              SizedBox(width:80.0),
                              FlatButton(
                                onPressed: () => showRating(),
                                child: Text('Rate', style: TextStyle(
                                    color: Colors.blue
                                )
                                ),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(side: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                    style: BorderStyle.solid
                                ), borderRadius: BorderRadius.circular(50)),
                              ),

                              SizedBox(width:80.0),
                              Icon(Icons.star,color: Colors.yellow,),

                              Text(
                                quantity,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Text("Shop Information",style: themeData.textTheme.headline4,),
                    ),
                    addVerticalSpace(padding),

                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Text(description
                        ,textAlign: TextAlign.justify,style: themeData.textTheme.bodyText2,),
                    ),
                    addVerticalSpace(100),
                  ],
                ),
              ),

              Positioned(
                bottom: 15,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: RaisedButton(
                        splashColor: Colors.lightGreen,
                        padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                        color:Colors.black,
                        child:Row(children: [
                          Icon( Icons.message,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Message",style:TextStyle(color:Colors.white)),
                        ],),
                        onPressed: (){
                          print("hello");
                          launchUrl("mailto: $price?subject=From $price&body=$message");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                      ),
                    ),

                    addHorizontalSpace(10),
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: RaisedButton(
                        splashColor: Colors.lightGreen,
                        padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                        color:Colors.black,
                        child:Row(children: [
                          Icon(Icons.call,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Call",style:TextStyle(color:Colors.white)),
                        ],),
                        onPressed: (){
                          //launch("tel://+94${post['contact']}");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                      ),
                    )

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
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
             // addrate(rating.toString());
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
  _launchURLMail() async {
    const url =
        'mailto:ashennilura@gmail.com?subject=LifePlusApp&body=Your sugestions%20or Feedback..';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildRating() => RatingBar.builder(
    minRating: 1,
    itemSize: 20,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: true,

    onRatingUpdate: (rating) => setState(() {
      this.rating = rating;
    }),
  );
  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void lanchwhatsapp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("can't open whatsapp");
  }

}
