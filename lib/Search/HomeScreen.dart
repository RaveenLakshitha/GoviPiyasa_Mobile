import 'dart:convert';

import 'package:blogapp/NewCart/CartScreenNew.dart';

import 'package:blogapp/Search/search.dart';
import 'package:blogapp/Search/user_model.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/shop/ShopProfile/shopview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'Api_service.dart';

class Searchitems extends StatefulWidget {
  @override
  _SearchitemsState createState() => _SearchitemsState();
}

class _SearchitemsState extends State<Searchitems>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String category;

  @override
  void initState() {
    itemCategory();
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }
  //  @override
  // Widget build(BuildContext context) {
  //   const title = 'Grid List';

  FetchUserList _userList = FetchUserList();


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
  bool _isLoading = false;
  var _itemCategory = [];

  void itemCategory() async {
    try {
      final response = await get(Uri.parse("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/itemCategories"));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _itemCategory = jsonData;
      });
      print(_itemCategory[0]['categoryType']);
      //print(_itemCategory[3]['Information'][0]['Title'].toString());
    } catch (err) {}
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
        body: _isLoading==true?SizedBox(child:Center(child:CircularProgressIndicator())):Column(
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
                    child: GestureDetector(
                      onTap:(){
                        setState(() {
                          category="Flowers";
                          tabController.index=0;
                        });
                      },
                      child: Text(
                        'Flowers',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: GestureDetector(
                      onTap:(){
                        setState(() {

                          category="Fruits";
                          tabController.index=1;
                        });
                      },
                      child: Text(
                        'Fruits',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: GestureDetector(
                      onTap:(){
                        setState(() {
                          category="Seeds";
                          tabController.index=2;
                        });
                      },
                      child: Text(
                        'Seeds',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: GestureDetector(
                      onTap:(){
                        setState(() {
                          category="Equipment";
                          tabController.index=3;
                        });

                      },
                   child: Text(
                      'Equipment',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),)
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
                            childAspectRatio: 2 / 2.5,
                            crossAxisCount: 2),
                        itemCount: data?.length,

                        itemBuilder: (context, index) {

                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if(data[index].parentCategoryName=="${category}"){
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Itemdetails(
                                        text: "${data[index].productName}",
                                        price: "${data[index].price}",
                                        image: '${data[index].thumbnail.img}',
                                        description:
                                        "${data[index].description}",
                                        quantity: "${data[index].quantity}",
                                        category:
                                        "${data[index].parentCategoryName}",
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
                                              child: Image(
                                                height: 80,
                                                width: 80,
                                                image: NetworkImage(
                                                    "${data[index].thumbnail.img}"),
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
                                                  buildRating1(
                                                      double.parse("${data[index].rating}")),



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
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Shopview(
                                                                id: "${data[index].shopId.id}",),
                                                            ));
                                                        print(data[index].shopId.id);
                                                      }),
                                                ),
                                                Align(
                                                  alignment:
                                                  Alignment.bottomLeft,
                                                  child: InkWell(
                                                    onTap: () async{
                                                      /*  setState(() {
                                                    _isLoading=true;
                                                  });*/
                                                      setState(()async {
                                                        await Future.delayed(
                                                            Duration(seconds: 2));
                                                        addtocart(data[index].id,1,data[index].price);
                                                        Scaffold.of(context).showSnackBar(new SnackBar(
                                                            content: new Text("Item Added to Cart")
                                                        ));
                                                      });

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
                          }else{
                            return SizedBox.shrink();
                          }



                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRating1(rating) => RatingBar.builder(
    minRating: 1,
    itemSize: 10,
    initialRating: rating,
    itemPadding: EdgeInsets.symmetric(horizontal: 2),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: false,
    onRatingUpdate: (rating) => setState(() {
      //this.rating = rating;
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


