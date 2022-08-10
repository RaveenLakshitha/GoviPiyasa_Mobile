import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:blogapp/Cart/cart_provider.dart';
import 'package:blogapp/Cart/cart_screen.dart';
import 'package:blogapp/Forum/Forumcategory.dart';
import 'package:blogapp/NewCart/CartScreenNew.dart';
import 'package:blogapp/Search/provider_cart.dart';
import 'package:blogapp/Search/Db_helper.dart';
import 'package:blogapp/Search/cart_model.dart';
import 'package:blogapp/Search/search.dart';
import 'package:blogapp/Search/user_model.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/shop/ShopProfile/shopview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:blogapp/wishlist/Db_helper1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'Api_service.dart';
import '';

class Searchitems extends StatefulWidget {
  @override
  _SearchitemsState createState() => _SearchitemsState();
}

class _SearchitemsState extends State<Searchitems>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }
  //  @override
  // Widget build(BuildContext context) {
  //   const title = 'Grid List';

  FetchUserList _userList = FetchUserList();
  DBHelper2 dbHelper = DBHelper2();
  DBHelper1 dbHelper1 = DBHelper1();
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  FlutterSecureStorage storage = FlutterSecureStorage();
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];
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
  Widget build(BuildContext context) {
    //final cart1 = Provider.of<providerCart >(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
          leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.green[400],
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchUser());
              },
              icon: Icon(Icons.search_sharp, color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreenNew()));
              },
              icon: Icon(Icons.shopping_bag_outlined, color: Colors.black),
            ),
            SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 6,
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 15.0),
              child: TabBar(
                controller: tabController,
                indicatorColor: Colors.transparent,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.withOpacity(0.5),
                isScrollable: true,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'flowers',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Vegetebels',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Seeds',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Equipment',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              //  padding: EdgeInsets.all(15),
              child: FutureBuilder<List<Userlist>>(
                  future: _userList.getuserList(),
                  builder: (context, snapshot) {
                    var data = snapshot.data;
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: data?.length,
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
                                        image:
                                            'https://source.unsplash.com/random?sig=$index',
                                        description:
                                            "${data[index].description}",
                                        quantity: "${data[index].quantity}",
                                        category:
                                            "${data[index].categoryName}"),
                                  ));
                            },
                            child: Container(
                              // color: Colors.black,
                              height: 300,
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
                                      // Align(
                                      //   alignment: Alignment.topRight,
                                      //   child: Container(
                                      //     child: IconButton(
                                      //       onPressed: () {
                                      //         Navigator.push(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //               builder: (context) => Itemdetails(
                                      //                   text:
                                      //                       "${data[index].productName}",
                                      //                   price:
                                      //                       "${data[index].price}",
                                      //                   image:
                                      //                       'https://source.unsplash.com/random?sig=$index',
                                      //                   description:
                                      //                       "${data[index].description}",
                                      //                   quantity:
                                      //                       "${data[index].quantity}",
                                      //                   category:
                                      //                       "${data[index].categoryName}"),
                                      //             ));
                                      //       },
                                      //       icon: Icon(
                                      //         Icons.favorite,
                                      //         color: Colors.red,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image(
                                            height: 100,
                                            width: 100,
                                            image: NetworkImage(
                                                "https://source.unsplash.com/random?sig=$index"),
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
                                                    fontSize: 10,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Rs:${data[index].price}",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                // Text(
                                                //     "${data[index].categoryName}",
                                                //     style: TextStyle(
                                                //       color: Colors.blue,
                                                //     )),
                                                SizedBox(
                                                  height: 5,
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
                                                Container(
                                                  child: IconButton(
                                                      icon: Icon(
                                                        Icons.store,
                                                        size: 30,
                                                      ),
                                                      onPressed: () {}),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      addtocart(data[index].id,
                                                          1, data[index].price);
                                                      Navigator.pop(context);
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
                                                              "assets/shopping_cart.jpg"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRating() => RatingBar.builder(
        minRating: 1,
        itemSize: 10,
        itemPadding: EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
        updateOnDrag: true,
        onRatingUpdate: (rating) => setState(() {
          // this.rating = rating;
        }),
      );
}
// Container(
            //   height: MediaQuery.of(context).size.height - 200.0,
            //   child: TabBarView(
            //     controller: tabController,
            //     children: <Widget>[],
            //   ),
            // ),
/*            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Center(
                child: Badge(
                  showBadge: true,

                  animationType: BadgeAnimationType.fade,
                  animationDuration: Duration(milliseconds: 300),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),*/

            // SizedBox(height: 6,
        //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [for(int i=0; i<categories.length;i++)
        //   GestureDetector(
        //     onTap: (){
        //       setState(() => selectId =categories[i].id);
        //     },
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           Categories[i].name,
        //           style: TextStyle(
        //             color:selectId == 1
        //             ?green
        //             :black.withOpacity(0.7),
        //             fontSize: 16.0;
        //           ),
        //         )
        //       ],
        //     ),
        //   )],),),


        