import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'ItemSubCategory.dart';


class ItemMainCategory extends StatefulWidget {
  const ItemMainCategory({Key key}) : super(key: key);

  @override
  State<ItemMainCategory> createState() => _ItemMainCategoryState();
}

class _ItemMainCategoryState extends State<ItemMainCategory> {
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/infoCategories";
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
  void initState() {
    itemCategory();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*    appBar: AppBar(
          centerTitle: true,
          title:Text("Item Main Categories"),
          actions: [

          ],*/
        /*  flexibleSpace: Image(
            image: NetworkImage(
                'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
            fit: BoxFit.cover,

          ),*/
       // ),
        body:_itemCategory==null?Center(child: CircularProgressIndicator()):Container(
          /*     decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/about.jpg"),
            fit: BoxFit.cover,
          ),
        ),*/
          child:GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _itemCategory.length,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                final infor = _itemCategory[index];
                if(_itemCategory[index]['categoryType']== "Main"){
                  return     GestureDetector(
                    child:Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('${infor['image']}'))),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${infor['categoryName']}',
                              style: TextStyle(
                                fontFamily: 'Indies',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ),
                            )),
                      ),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                    ),
                    onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemSubCategory(category:_itemCategory[index]['_id'])));

                    } ,);
                }else{
                  return SizedBox.shrink();
                }



              }),)
    );
  }
}
