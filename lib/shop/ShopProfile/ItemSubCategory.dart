import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'additem.dart';



class ItemSubCategory extends StatefulWidget {
  final String category;

  ItemSubCategory (
      {
        @required this.category,
      });

  @override
  State<ItemSubCategory> createState() => _ItemSubCategoryState(category);
}

class _ItemSubCategoryState extends State<ItemSubCategory> {
  var _itemSubCategory = [];
  String category;
  _ItemSubCategoryState(this.category);

  void infocategory(String id) async {
    print(id);
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/itemCategories/getCategoryByParent/$id'));
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _itemSubCategory = jsonData;
      });
      print(_itemSubCategory);

    } catch (err) {}
  }

  @override
  void initState() {
    infocategory(category);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${category}"),
          toolbarHeight: 50,
          backgroundColor: Colors.lightGreen,
          centerTitle: true,

        ),
        body:Container(
          /*     decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/about.jpg"),
            fit: BoxFit.cover,
          ),
        ),*/
          child:GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _itemSubCategory.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                final infor = _itemSubCategory[index];
                //if(_itemSubCategory[index]['categoryType']== "Sub"&&_itemSubCategory[index]['parentId']=="${category}"){
                return  GestureDetector(

                  child:Card(
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
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
                   //if(_itemSubCategory[index]['Information'][index]['Title']!=null){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddItem(categoryId:infor['_id'],categoryParentId:category)));
                  //  }

                  } ,);
                /*}else{
                  return SizedBox.shrink();
                }*/



              }),)
    );
  }
}
