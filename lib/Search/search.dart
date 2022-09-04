import 'dart:convert';

import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/shop/ShopProfile/shopview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Api_service.dart';
import 'user_model.dart';
import 'package:http/http.dart' as http;
class SearchUser extends SearchDelegate {
  FetchUserList _userList = FetchUserList();
  addtowishlist(id) async {
    String token = await storage.read(key: "token");
    print(token);
    print(id);
    final body = {"item": id};
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/listItems",
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        print(json.decode(response.body));

      }
    });
  }
  FlutterSecureStorage storage = FlutterSecureStorage();
  addtocart(id, amount, unitPrice) async {
    String token = await storage.read(key: "token");
    print(token);
    print(id);

    final body = {"item": id, "amount": amount, "unitPrice": unitPrice};
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cartItems",
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Userlist>>(
        future: _userList.getuserList(query: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Userlist> data = snapshot.data;
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2 / 2.5,
                  crossAxisCount: 2),
              itemCount: data?.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Itemdetails(
                              text: "${data[index].productName}",
                              price: "${data[index].price}",
                             // image: '${data[index].thumbnail.img}',
                            //  description:
                              //"${data[index].description}",
                              quantity: "${data[index].quantity}",
                              // category:
                              // "${data[index].parentCategoryName}",
                              //shopPic1:"${data[index].productPictures.img}",
                            ),

                          ));
                    },
                    child: Container(
                      // color: Colors.black,
                      //  height: 300,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 5.0,
                        // color: index.isEven
                        //     ? Colors.lightBlue[200]
                        //     : Colors.lightGreen[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      color: Colors.lightBlueAccent,
                                    ),
                                    child:Image(
                                      height: 80,
                                      width: 80,
                                      // image:data[index].thumbnail.img!=''?NetworkImage(
                                      //     "${data[index].thumbnail.img}"):NetworkImage(
                                      //     "https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data[index].productName}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Rs:${data[index].price}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500),
                                        ),

                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          child: data[index].quantity ==
                                              0
                                              ? Text(
                                              "Quantity:out of stock",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ))
                                              : Text(
                                              "${data[index].quantity}",
                                              style: TextStyle(
                                                color: Colors.red,
                                              )),
                                        ),
                                       // buildRating1(
                                         //   double.parse("${data[index].rating}")),



                                        SizedBox(height: 2.0),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: IconButton(
                                          onPressed: () {
                                            addtowishlist("${data[index].id}");
                                            Scaffold.of(context).showSnackBar(new SnackBar(
                                                content: new Text("Item Added to wishlist")
                                            ));
                                            /*     Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Itemdetails(
                                                            text:
                                                            "${data[index].productName}",
                                                            price:
                                                            "${data[index].price}",
                                                            image:
                                                            'https://source.unsplash.com/random?sig=$index',
                                                            description:
                                                            "${data[index].description}",
                                                            quantity:
                                                            "${data[index].quantity}",
                                                            category:
                                                            "${data[index].categoryName}"),
                                                      ));*/
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.store,
                                              size: 25,
                                            ),
                                            // onPressed: () {
                                            //   Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (context) => Shopview(
                                            //           id: "${data[index].shopId.id}",),
                                            //       ));
                                              //print(data[index].shopId.id);
                                           // }
                                            ),
                                      ),
                                      Align(
                                        alignment:
                                        Alignment.bottomLeft,
                                        child: InkWell(
                                          onTap: () async{
                                            /*  setState(() {
                                                    _isLoading=true;
                                                  });*/
                                            await Future.delayed(
                                                Duration(seconds: 2));
                                            addtocart(data[index].id,1,data[index].price);
                                            Scaffold.of(context).showSnackBar(new SnackBar(
                                                content: new Text("Item Added to Cart")
                                            ));


                                            /*     setState(() {
                                                    _isLoading=false;
                                                  });*/
                                            /*  Navigator.pop(context);
                                                      addtocart(data[index].id,
                                                          1, data[index].price);
                                                      Navigator.pop(context);*/
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                              image:
                                              new DecorationImage(
                                                image: new AssetImage(
                                                    "assets/shopping_cart.png"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );



              });
        });

  }
  Widget buildRating1(rating) => RatingBar.builder(
    minRating: 1,
    itemSize: 10,
    initialRating: rating,
    itemPadding: EdgeInsets.symmetric(horizontal: 2),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: false,

  );
  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search User'),
    );
  }
}