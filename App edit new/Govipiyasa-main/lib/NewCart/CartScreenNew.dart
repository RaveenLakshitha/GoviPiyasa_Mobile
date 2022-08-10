import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:blogapp/Cart/Db_helper.dart';
import 'package:blogapp/Cart/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';


import 'package:http/http.dart' as http;
enum paymentOption{Online,TakeOnDelivery,takeonCash}
class CartScreenNew extends StatefulWidget {
  const CartScreenNew({Key key}) : super(key: key);

  @override
  _CartScreenNewState createState() => _CartScreenNewState();
}

class _CartScreenNewState extends State<CartScreenNew> {
  paymentOption _value=paymentOption.Online;
  Future deletePost(String id) async {
    print(id);
    final response =
    await http.delete("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cartItems/$id");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<Cart> DeleteData(String id) async {
    var response = await http.delete(Uri.parse(
        'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cartItems/$id'));
    var data = response.body;
    print(data);
    if (response.statusCode == 201) {
      String responseString = response.body;
      //CartFromJson(responseString);
    }
  }
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cartItems/";
  var _cartitems=[];
  String gender;
  final storage = FlutterSecureStorage();
  var  total;
  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }
  decreseAmount(id)async{

    String token = await storage.read(key: "token");
    print(token);
    final body = {

    };
    http.post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cartItems//DownAmount/$id",body:jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      }
    });
  }
  increseAmount(id)async{

    String token = await storage.read(key: "token");
    print(token);
    final body = {

    };
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cartItems/AddAmount/$id",body:jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      }
    });
  }

  void fetchcartItems() async {

    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cartItems/'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');

      print('cart items : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      print(jsonData);
      setState(() {
        _cartitems = jsonData;
        //total=_cartitems['totalPrice'].toString();

      });

    } catch (err) {}
  }
  @override
  void initState() {
    fetchcartItems() ;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        centerTitle: true,
        actions: [
          SizedBox(width: 20.0),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshList2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child:    Column(
              children: [
                Container(
                  height: 600,
                  width:  MediaQuery.of(context).size.width,
                  child:_cartitems==null?SizedBox(
                      height: 20,
                      child:CircularProgressIndicator()): ListView.builder(
                      itemCount: _cartitems.length,
                      itemBuilder: (context, index){
                        return  GestureDetector(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin:EdgeInsets.all(5.0),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                              "${_cartitems[index]['_id']}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${_cartitems[index]['paymentOption']}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Container(
                                                child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {

                                                          decreseAmount(_cartitems[index]['_id']);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Icon(
                                                          Icons.remove,
                                                          color: Colors
                                                              .black,
                                                        )),
                                                    Text(
                                                        "${_cartitems[index]['amount']}",
                                                        style: TextStyle(
                                                            color: Colors.black)),
                                                    InkWell(
                                                        onTap: () {
                                                          increseAmount(_cartitems[index]['_id']);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors
                                                              .black,
                                                        )),

                                                    InkWell(
                                                        onTap: () {
                                                          deletePost(_cartitems[index]['_id']);
                                                          Navigator.pop(context);
                                                        },
                                                        child:
                                                       Icon(Icons.delete,color: Colors.red))
                                                  ],
                                                )
                                            ),
                                            Text("Rs:${_cartitems[index]['unitPrice']}",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                )),






                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        SizedBox(width: 15,),
                                        Text("Cash OnDelivery",
                                            style: TextStyle(
                                              color: Colors.red,
                                            )),
                                        Radio(
                                            value:paymentOption.Online,
                                            groupValue: _value,
                                            onChanged: (value){
                                              setState(() {
                                                _value=value;
                                              });
                                              print(value); //selected value
                                            }
                                        ),
                                        Text("Online",
                                            style: TextStyle(
                                              color: Colors.red,
                                            )),
                                        Radio(
                                            value: "radio value",
                                            groupValue:3,
                                            onChanged: (value){
                                              print(value); //selected value
                                            }
                                        ), Text("Take On Delivery",
                                            style: TextStyle(
                                              color: Colors.red,
                                            )),
                                        Radio(
                                            value: "radio value",
                                            groupValue: 3,
                                            onChanged: (value){
                                              print(value); //selected value
                                            }
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
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Card(
                    child: ListTile(
                      //title: Text("Total Price:${_cartitems[0]['totalPrice']}"),
                      subtitle: Text(""),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;

  const ReusableWidget({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          )
        ],
      ),
    );
  }
}
