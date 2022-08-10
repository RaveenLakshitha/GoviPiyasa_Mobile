
import 'dart:convert';
import 'package:blogapp/checkout/widgets/viewgallery.dart';
import 'package:blogapp/shop/custom/BorderIcon.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';
class Itemdetails extends StatelessWidget {
  final String text;
  final String price;
  final String image;
  final String quantity;
  final String description;
  final String category;


  // receive data from the FirstScreen as a parameter
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
                  child: Column(

                      children: [
                        SizedBox(height: 40.0,),
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
                                child: Icon(Icons.keyboard_backspace,color: Colors.red,),
                              ),
                            ),
                            BorderIcon(
                              height: 50,
                              width: 50,
                              child: Icon(Icons.favorite_border,color:Colors.red,),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>viewgallery(image:image)));
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
                        ),),
                    ),

                    Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) =>viewgallery(image:'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80')));
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

                                child:ClipRRect(

                                  borderRadius: BorderRadius.circular(8.0),
                                  child:
                                  Image.network('https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
                                ),

                              ),
                            ),
                            SizedBox(width: 2.0,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) =>viewgallery(image:'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80')));
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),



                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network('https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80'),
                                )
                              ),
                            ),
                            SizedBox(width: 2.0,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) =>viewgallery(image:'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80')));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),

                                child:ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network('https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80'),
                                )
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text( text,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                            fontWeight: FontWeight.w600
                        )),
                    GestureDetector(
                      child:Icon(Icons.share),
                      onTap: (){
                        Share.share('${text}', subject: '${description}');
                      },
                    ),
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                              mainAxisAlignment: MainAxisAlignment.center,

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

 /* void opengallery()=> Navigator.of(context).push(MaterialPageRoute(builder:(_)=>Gallerywidget(
    urlImages:urlImages,
  ),));*/

}
