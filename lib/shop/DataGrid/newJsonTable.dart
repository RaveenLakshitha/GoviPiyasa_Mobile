import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:json_table/json_table.dart';


class SimpleTable extends StatefulWidget {
  @override
  _SimpleTableState createState() => _SimpleTableState();
}

class _SimpleTableState extends State<SimpleTable> {

  final url = "https://mongoapi3.herokuapp.com/experts";
  String _postsJson;

  void fetchData() async {
    try {
      final response = await get(Uri.parse(url));
     // final jsonData = jsonDecode(response.body) as List;
      //print(jsonData);
      setState(() {
        _postsJson = response.body as String;
      });
    } catch (err) {}
  }

  final String jsonSample =
      '[{"name":"Ram","email":"ram@gmail.com","age":23,"income":"10Rs","country":"India","area":"abc"},{"name":"Shyam","email":"shyam23@gmail.com",'
      '"age":28,"income":"30Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"John","email":"john@gmail.com","age":33,"income":"15Rs","country":"India",'
      '"area":"abc","day":"Monday","month":"april"},{"name":"Ram","email":"ram@gmail.com","age":23,"income":"10Rs","country":"India","area":"abc","day":"Monday","month":"april"},'
      '{"name":"Shyam","email":"shyam23@gmail.com","age":28,"income":"30Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"John","email":"john@gmail.com",'
      '"age":33,"income":"15Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"Ram","email":"ram@gmail.com","age":23,"income":"10Rs","country":"India",'
      '"area":"abc","day":"Monday","month":"april"},{"name":"Shyam","email":"shyam23@gmail.com","age":28,"income":"30Rs","country":"India","area":"abc","day":"Monday","month":"april"},'
      '{"name":"John","email":"john@gmail.com","age":33,"income":"15Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"Ram","email":"ram@gmail.com","age":23,'
      '"income":"10Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"Shyam","email":"shyam23@gmail.com","age":28,"income":"30Rs","country":"India","area":"abc",'
      '"day":"Monday","month":"april"},{"name":"John","email":"john@gmail.com","age":33,"income":"15Rs","country":"India","area":"abc","day":"Monday","month":"april"}]';
  bool toggle = true;
@override
  void initState() {
  fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(_postsJson);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text("Table Data"),

      ),
      body:_postsJson.length != null?Center(child:CircularProgressIndicator()): SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: toggle
              ? Column(
            children: [
              JsonTable(
                json,
                showColumnToggle: true,
                allowRowHighlight: true,
                rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                paginationRowCount: 4,
                onRowSelect: (index, map) {
                  print(index);
                  print(map);
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              Text("Simple table which creates table direclty from json")
            ],
          )
              : Center(
            child: Text(getPrettyJSONString(jsonSample)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.grid_on),
          onPressed: () {
            setState(
                  () {
                toggle = !toggle;
              },
            );
          }),
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }
}