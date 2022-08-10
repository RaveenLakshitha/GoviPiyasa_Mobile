import 'dart:convert';

import 'package:blogapp/Forum/searchquestion/user_model.dart';
import 'package:blogapp/Forum/updateqty.dart';


import 'package:blogapp/Search/search.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:blogapp/wishlist/Db_helper1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Qmodel.dart';
import 'Api_service.dart';


class SearchQty extends StatefulWidget {
  @override
  _SearchQtyState createState() => _SearchQtyState();
}

class _SearchQtyState extends State<SearchQty> {
  FetchUserList _userList = FetchUserList();
  DBHelper1 dbHelper1 = DBHelper1();

  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<Qmodel> DeleteData(String id) async {
    var response = await http.delete(Uri.parse(
        'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/RemoveQuestion/$id'));
    var data = response.body;
    print(data);
    if (response.statusCode == 201) {
      String responseString = response.body;
      qModelFromJson(responseString);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft,color: Colors.black,),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchUser());
              },
              icon: Icon(Icons.search_sharp,color:Colors.black),
            ),
            SizedBox(width: 8,),
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
            SizedBox(width: 20,),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: FutureBuilder<List<Qlist >>(
              future: _userList.getuserList(),
              builder: (context, snapshot) {
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context, index) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return GestureDetector(
                        onTap: (){
                         // Navigator.push(context, MaterialPageRoute(builder: (context) => Itemdetails(text: "${data[index].Title}", price: "${data[index].QuestionBody}", image: 'https://source.unsplash.com/random?sig=$index', description: "${data[index].description}", quantity: "${data[index].quantity}", category: "${data[index].categoryName}"),));
                          },
                        child: Card(
                          elevation: 5.0,
                            //color: index.isEven ? Colors.lightBlue[200] : Colors.lightGreen[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin:EdgeInsets.all(5.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
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
                                            "${data[index].Title}",
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
                                            "${data[index].QuestionBody}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text("${data[index].Category}",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              )),
                                          Text("${data[index].Id}",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            child:Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text("Do you want delete your question"),
                                                              content: Text(""),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: Text("Yes"),
                                                                  onPressed: () {
                                                                     DeleteData("${data[index].Id}");
                                                                     Navigator.pop(context);
                                                                    Fluttertoast.showToast(
                                                                      msg: "Deleted",
                                                                      toastLength:
                                                                      Toast.LENGTH_SHORT,
                                                                      gravity:
                                                                      ToastGravity.BOTTOM,
                                                                      backgroundColor:
                                                                      Colors.red,
                                                                      textColor: Colors.white,
                                                                      fontSize: 16.0,
                                                                    );
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text("No"),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          });

                                                    },
                                                    child: Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                          BorderRadius.circular(5)),
                                                      child: const Center(
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      //  addtocart(data[index].id,1,data[index].pri);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                          BorderRadius.circular(5)),
                                                      child: const Center(
                                                        child: Text(
                                                          'Solved',
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(builder: (context) => Updateqty(Title:"${data[index].Title}",QuestionBody:"${data[index].QuestionBody}",Category:"${data[index].Category}",id:"${data[index].Id}")));
                                                    },
                                                    child: Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                          BorderRadius.circular(5)),
                                                      child: const Center(
                                                        child: Text(
                                                          'Update',
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
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
                      );
                    });
              }),
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