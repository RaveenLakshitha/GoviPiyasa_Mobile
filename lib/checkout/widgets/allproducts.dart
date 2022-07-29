import 'dart:convert';
import 'package:blogapp/Search/Api_service.dart';
import 'package:blogapp/checkout/models/cart.dart';
import 'package:blogapp/checkout/models/products.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/shop/ShopProfile/shopview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Allproduct extends StatefulWidget {
  @override
  _AllproductState createState() => _AllproductState();
}
class User {
  final String itemname;
  final String description;
  User({this.itemname, this.description});
}
class _AllproductState extends State<Allproduct> {
 // final String categoryName;
  List<String> categories = ["Plants", "Seeds", "Equipment"];
  int selectIndex = 0;
  bool order=true;
  double rating = 0;
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/";
  var _itemsJson = [];
  FetchUserList _userList = FetchUserList();
  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _itemsJson = jsonData;
      });
    } catch (err) {}
  }
  var categoryName;
  void initState() {
    super.initState();
    fetchPosts();
    _itemsJson.sort();
     categoryName="1SubCat2";
  }

  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }

//final List<itemmodel> itemdata=List.generate(_itemsJson.length, (index) => null)
  @override
  Widget build(BuildContext context) {
    // var myobj;
    final pdt = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 3.0,
            ),
            Container(
              child:IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(
                  Icons.sort_outlined,
                  size: 30,

                ),
                onPressed: (){
                  setState(() {
                    order=false;
                  });
                },
              ),
            ),

            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        categoryName="1SubCat2";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                      ),
                      width: 200,
                      child: const Center(
                          child: Text(
                            'Seeds',
                            style: TextStyle(fontSize: 18, color: Colors.lightGreen),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        categoryName="1SubCat2";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                      ),
                      width: 200,
                      child: const Center(
                          child: Text(
                            'Plants',
                            style: TextStyle(fontSize: 18, color: Colors.lightGreen),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                    ),
                    width: 200,
                    child: const Center(
                        child: Text(
                          'Equipment',
                          style: TextStyle(fontSize: 18, color: Colors.lightGreen),
                        )),
                  ),
                ],
              ),
            ),
           order!=true?  RefreshIndicator(
               onRefresh: refreshList2 ,
               child:GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _itemsJson.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  int reverseorder=_itemsJson.length-1-index;
                  final item = _itemsJson[reverseorder];

                  final qty = _itemsJson[reverseorder]['quantity'];


                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.lightGreen, width: 1),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Image.network(
                                    "https://source.unsplash.com/random?sig=$index",
                                    height: 100,width: 100,
                                  ),
                                ),
                                SizedBox(width: 8.0,),
                                Container(
                                  child: Column(
                                    children: [

                                      Text("${item['productName']}",style: TextStyle(   fontFamily: 'Roboto',fontWeight: FontWeight.bold, fontSize: 14.0),),
                                      Text("Rs${item['price']}",style: TextStyle(
                                        color: Colors.red,
                                      )),
                                      Text("${item['categoryName']}",style: TextStyle(
                                        color: Colors.blue,
                                      )),
                                      Container(
                                        child: qty == 0
                                            ? Text("Quantity:out of stock",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ))
                                            : Text("${item['quantity']}"),
                                      ),
                                      //buildRating(),
                                      Icon(Icons.star,color: Colors.yellow,size:15),
                                    ],
                                  ),
                                )

                              ],
                            )),
                        ListTile(
                          leading: GestureDetector(
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  'https://source.unsplash.com/random?sig=$index'),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Shopview(
                                        id:'${item['shopId']['_id']}',
                                        text: '${item['shopId']['shopName']}',
                                        price: '${item['shopId']['email']}',
                                        image:'https://source.unsplash.com/random?sig=$index',
                                        description: '${item['shopId']['address']}',
                                        quantity: '${item['shopId']['rating']}',
                                        category: '${item['categoryName']}',
                                        itemCount:'${item['shopId']['itemCount']}',
                                        shopitems:'${item['shopId']['shopItems']}',
                                        latlang:'${item['shopId']['location']['coordinates'][0]}',
                                        longitude:'${item['shopId']['location']['coordinates'][1]}'

                                    ),

                                  ));
                            },
                          ),

                          trailing: IconButton(
                              icon: Icon(Icons.shopping_cart),
                              onPressed: () {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text('Item Added to Cart'),
                                ));
                                //String num="$item['price']";
                                double myDouble =
                                double.parse("${item['price']}");
                                cart.addItem("${item['productName']}",
                                    "${item['productName']}", myDouble);
                              }),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Itemdetails(text: '${item['productName']}', price: '${item['price']}', image: 'https://source.unsplash.com/random?sig=$index', description: '${item['description']}', quantity: '${item['quantity']}', category: '${item['categoryName']}'),));
                          },
                        ),

                      ],
                    ),
                  );
                })): RefreshIndicator(
             onRefresh: refreshList2,
             child:GridView.builder(
               physics: ScrollPhysics(),
               shrinkWrap: true,
               itemCount: _itemsJson.length,
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2),
               itemBuilder: (BuildContext context, int index) {
                 final item = _itemsJson[index];
                 final qty = _itemsJson[index]['quantity'];

                 if(_itemsJson[index]['categoryName']== "${categoryName}"){

                   return Card(
                     shape: RoundedRectangleBorder(
                       side: BorderSide(color: Colors.blue, width: 1),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     elevation: 10.0,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Container(
                             child:Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Container(
                                   decoration: BoxDecoration(
                                     border:
                                     Border.all(color: Colors.lightGreen, width: 1),
                                     borderRadius:
                                     BorderRadius.all(Radius.circular(5.0)),
                                   ),
                                   child: Image.network(
                                     "https://source.unsplash.com/random?sig=$index",
                                     height: 100,width: 100,
                                   ),
                                 ),
                                 SizedBox(width: 8.0,),
                                 Container(
                                   child: Column(
                                     children: [

                                       Text("${item['productName']}",style: TextStyle(   fontFamily: 'Roboto',fontWeight: FontWeight.bold, fontSize: 14.0),),
                                       Text("Rs${item['price']}",style: TextStyle(
                                         color: Colors.red,
                                       )),
                                       Text("${item['categoryName']}",style: TextStyle(
                                         color: Colors.blue,
                                       )),
                                       Container(
                                         child: qty == 0
                                             ? Text("Quantity:out of stock",
                                             style: TextStyle(
                                               color: Colors.red,
                                             ))
                                             : Text("${item['quantity']}"),
                                       ),
                                       //buildRating(),
                                       Icon(Icons.star,color: Colors.yellow,size:15),
                                     ],
                                   ),
                                 )

                               ],
                             )),
                         ListTile(
                           leading: GestureDetector(
                             child: CircleAvatar(
                               radius: 25,
                               backgroundImage: NetworkImage(
                                   'https://source.unsplash.com/random?sig=$index'),
                             ),
                             onTap: () {
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                     builder: (context) => Shopview(
                                          id:'${item['shopId']['_id']}',
                                         text: '${item['shopId']['shopName']}',
                                         price: '${item['shopId']['email']}',
                                         image:'https://source.unsplash.com/random?sig=$index',
                                         description: '${item['shopId']['address']}',
                                         quantity: '${item['shopId']['rating']}',
                                         category: '${item['categoryName']}',
                                         itemCount:'${item['shopId']['itemCount']}',
                                         shopitems:'${item['shopId']['shopItems']}',
                                         latlang:'${item['shopId']['location']['coordinates'][0]}',
                                         longitude:'${item['shopId']['location']['coordinates'][1]}'

                                     ),

                                   ));
                             },
                           ),

                           trailing: IconButton(
                               icon: Icon(Icons.shopping_cart),
                               onPressed: () {
                                 Scaffold.of(context).showSnackBar(SnackBar(
                                   duration: Duration(seconds: 3),
                                   content: Text('Item Added to Cart'),
                                 ));
                                 //String num="$item['price']";
                                 double myDouble =
                                 double.parse("${item['price']}");
                                 cart.addItem("${item['productName']}",
                                     "${item['productName']}", myDouble);
                               }),
                           onTap: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => Itemdetails(text: '${item['productName']}', price: '${item['price']}', image: 'https://source.unsplash.com/random?sig=$index', description: '${item['description']}', quantity: '${item['quantity']}', category: '${item['categoryName']}'),));
                           },
                         ),

                       ],
                     ),
                   );
                 }else{
                   return SizedBox.shrink();
                 }


               }))
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
      this.rating = rating;
    }),
  );
}
